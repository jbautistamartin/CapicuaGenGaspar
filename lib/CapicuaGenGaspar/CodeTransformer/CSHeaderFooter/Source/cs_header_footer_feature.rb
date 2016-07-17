# encoding: utf-8
=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martín, el 6 de enero
de 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso al
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end

require 'rubygems'
require 'rchardet'
require 'active_support/core_ext/object/blank'

require_relative '../../../gaspar'
require_relative '../../../Mixins/cs_db_connection_provider_mixin'
require_relative '../../../Mixins/cs_namespace_mixin'
require_relative '../../../Mixins/entity_interface_mixin'
require_relative '../../../Mixins/entity_sql_table_mixin'

module CapicuaGen::Gaspar

  # Característica generadora de caceberas y pies de página
  # en el código fuente generado por otras características
  class CSHeaderFooterFeature < CapicuaGen::TemplateFeature
    include CapicuaGen
    include CapicuaGen::Gaspar

    attr_accessor :include_regex, :exclude_regex

    public

    # Inicializa la característica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:code_transformer] if self.types.blank?

      # Configuro los templates
      set_template("header", Template.new(:file => 'header.erb'))
      set_template("footer", Template.new(:file => 'footer.erb'))

      #Configuro los include y exclude
      @include_regex= [/\.cs$/i] unless @include_regex
      @exclude_regex= [/\.Designer\.cs$/i] unless @exclude_regex


    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Configuro los templates
      @header_template_target= set_template_target('header', TemplateTarget.new())
      @footer_template_target= set_template_target('footer', TemplateTarget.new())

    end

    # Recorre las plantilla y genera las cabeceras
    def generate
      message_helper.puts_generating_feature(self)

      message_helper.add_indent

      begin


        resultado= ''

        template_target= get_template_target_by_name('proyect')

        directory_base= self.generation_attributes[:out_dir]
        # Recorro todas las características
        generator.features().each do |feature|
          #Obtengo todos los archivos asociados
          feature.get_relative_out_files(:directory_base => directory_base, :types => :proyect_file).each do |unix_path|
            begin

              # Nombre del archivo
              file     = unix_path.gsub(/\//, '\\')
              file_name= File.basename file

              next unless check_include(file)

              file_content= ''

              Dir.chdir directory_base do
                # Cargo el acrhivo
                file_content= File.read(file)
                file_content.force_encoding(CharDet.detect(file_content)['encoding'])
              end


              # Genero los las licencias
              modified=false

              # Limpio file_content para comparciones

              # Genero cabecera
              header  =generate_template_target(@header_template_target, binding)
              begin
                header_check=header.clone
                header_check.force_encoding(CharDet.detect(file_content)['encoding']) unless header.blank?
                header_check.blank?
                header=header_check
              rescue
              end

              if header.blank? or file_content.gsub(/\s*/, '').include?(header.gsub(/\s*/, ''))
                header =''
              else
                modified=true
              end

              # Genero pie
              footer= generate_template_target(@footer_template_target, binding)
              begin
                footer_check=footer.clone
                footer_check.force_encoding(CharDet.detect(file_content)['encoding']) unless footer.blank?
                footer_check.blank?
                footer_check=footer_check
              rescue
              end

              if footer.blank? or file_content.gsub(/\s*/, '').include?(footer.gsub(/\s*/, ''))
                footer =''
              else
                modified=true
              end

              if modified
                file_out= "#{header}#{file_content}#{footer}"
                Dir.chdir directory_base do
                  # Guardo el archivo
                  File.write(file, file_out)
                  message_helper.puts_created_template("header.erb, footer.erb", file, :override)
                end
              else
                message_helper.puts_created_template("header.erb, footer.erb", file, :ignore)
              end

            rescue => e
              error_message="Error en #{unix_path}"
              message_helper.puts_error_message error_message
              raise e
            end
            
          end

        end

      ensure
        message_helper.remove_indent
        puts

      end

    end

    # Revisa si un archivo debe ser incluido
    def check_include(file)
      return false if @include_regex.blank?

      @include_regex.each do |include|
        return false unless include.match(file)
      end

      return true if @exclude_regex.blank?

      @exclude_regex.each do |exclude|
        return false if exclude.match(file)
      end

      return true

    end
  end

end


