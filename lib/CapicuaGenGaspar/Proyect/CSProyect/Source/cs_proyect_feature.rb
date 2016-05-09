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


require 'active_support/core_ext/object/blank'
require 'uuidtools'


require_relative '../../../Mixins/main_form_mixin'
require_relative '../../../Mixins/splash_mixin'
require_relative '../../../gaspar'

module CapicuaGen::Gaspar

  # Característica generadora para proyectos Windows de CS.
  class CSProyectFeature < CapicuaGen::TemplateFeature
    include CapicuaGen
    include CapicuaGen::Gaspar

    public

    # Inicializa la característica
    def initialize(values= {})
      super(values)

    end

    # Resetea los atributos personalizados de la característica (antes de establecer el generador)
    def reset_attributes
      self.generation_attributes[:out_dir]  = nil
      self.generation_attributes[:namespace]= nil
    end

    # Configura los atributos personalizados de la característica (antes de establecer el generador)
    def configure_attributes()
      self.generation_attributes[:out_dir]= "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}" unless self.generation_attributes.has_in_self?(:out)
    end

    # Obtiene los archivos que se incluiran en este proyeto
    def get_proyect_files()
      resultado= ''

      template_target= get_template_target_by_name('proyect')

      directory_base= File.dirname(File.join(self.generation_attributes[:out_dir], template_target.out_file))

      # Recorro todas las características
      generator.features().each do |f|
        #Obtengo todos los archivos asociados
        f.get_relative_out_files(:directory_base => directory_base, :types => :proyect_file).each do |unix_path|

          p        = unix_path.gsub /\//, '\\'
          extension= File.extname(p).downcase
          file_type= :proyect_file
          Dir.chdir directory_base do
            file_type= get_type(p)
          end


          case extension
            when '.cs'

              case file_type
                when :proyect_file
                  if p=~ /(?:.+\\)?(.+)\.Designer.cs/i
                    resultado << "      <Compile Include= \"#{p}\" >" << $/
                    resultado << "        <DependentUpon>#{$1}.cs</DependentUpon>" << $/
                    resultado << "      </Compile>" << $/
                  elsif p=~ /(?:.+\\)?(.+)\.svc\.cs/i
                    resultado << "      <Compile Include= \"#{p}\" >" << $/
                    resultado << "        <DependentUpon>#{$1}.svc</DependentUpon>" << $/
                    resultado << "      </Compile>" << $/
                  else
                    resultado << "      <Compile Include= \"#{p}\" />" << $/
                  end
                when :form_proyect_file
                  resultado << "      <Compile Include= \"#{p}\" >" << $/
                  resultado << "        <SubType>Form</SubType>" << $/
                  resultado << "      </Compile>" << $/
              end

            when '.resx'
              if p=~ /(?:.+\\)?(.+)\.resx/i
                resultado << "      <EmbeddedResource Include= \"#{p}\" >" << $/
                resultado << "        <DependentUpon>#{$1}.cs</DependentUpon>" << $/
                resultado << "      </EmbeddedResource>" << $/
              end
            when '.config', '.svc'
              resultado << "      <Content Include= \"#{p}\" />" << $/
            else
              resultado << "      <Compile Include= \"#{p}\" />" << $/
          end
        end
      end

      return resultado
    end

    # Devuelve el tipo de archivo de un elemento.
    def get_type(file)

      return :proyect_file unless file=~/.cs$/

      # Compruebo si es un archivo de Windows
      designed= file.sub(/\.cs$/, ".designer.cs")

      return :proyect_file if file==designed
      return :proyect_file if not File.exist?(designed)

      text= File.open(designed).read

      if text=~/:\s*(Form|System.Windows.Form)/
        return :form_proyect_file
      else
        return :proyect_file
      end

    end


  end
end