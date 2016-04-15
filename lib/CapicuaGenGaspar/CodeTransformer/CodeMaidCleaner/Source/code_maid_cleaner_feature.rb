=begin

CapicuaGen

CapicuaGen es un software que ayuda a la creación automática de
sistemas empresariales a través de la definición y ensamblado de
diversos generadores de características.

El proyecto fue iniciado por José Luis Bautista Martin, el 6 de enero
del 2016.

Puede modificar y distribuir este software, según le plazca, y usarlo
para cualquier fin ya sea comercial, personal, educativo, o de cualquier
índole, siempre y cuando incluya este mensaje, y se permita acceso el
código fuente.

Este software es código libre, y se licencia bajo LGPL.

Para más información consultar http://www.gnu.org/licenses/lgpl.html
=end


=begin
  Este clase se comunica con la extensiòn CodeMaid  de Visual Stuido,
  para formatear y limpiar la salida del codigo fuente
  para mas informaciòn visistar la pagina del producto

  http://www.codemaid.net/

=end

require 'nokogiri'
require 'tempfile'

require_relative '../../../gaspar'
require 'active_support/core_ext/object/blank'
require_relative '../../../Mixins/cs_app_config_mixin'


module CapicuaGen::Gaspar
  # Caracteristica generadora para limpiar y formatear el codigo generado
  # a traves de la herramienta CodeMaid (Extesion de Visual Studio)
  class CodeMaidCleanerFeature < CapicuaGen::Feature
    include CapicuaGen
    include CapicuaGen::Gaspar

    attr_accessor :bin_directories, :target_feature_types

    BINARY= "RunCodeMaidCleaner.exe"

    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)


      # Configuro los tipos si estos no han sido configurados previamente
      self.types           = [:transformer] if self.types.blank?

      @target_feature_types= [:soluction] if @target_feature_types.blank?


      @bin_directories     = [] if self.bin_directories.blank?
      @bin_directories << File.join(File.dirname(__FILE__), '../bin')


    end


    # Genera las cabeceras y pie de paginas
    def generate
      super()


      message_helper.add_indent

      begin

        directory_base= self.generation_attributes[:out_dir]
        binary_file   = find_binary
        parameters    = ' /mo'
        files         = []


        # Recorro todas las caracteristicas
        generator.features.each do |feature|

          return unless feature.respond_to?('get_relative_out_files')

          #Obtengo todos los archivos asociados
          feature.get_relative_out_files(:directory_base => directory_base).each do |unix_path|

            file= unix_path.gsub(/\//, '\\')
            Dir.chdir directory_base do
              file= File.absolute_path(file)
            end
            extension= File.extname(file).downcase

            case extension
              when '.sln'
                parameters<<" /s \"#{file}\""
              when '.csproj'
                parameters<<" /p \"#{file}\"" if @target_feature_types.include?(:proyect)
              else

                Dir.chdir directory_base do
                  #Compruebo si debe ser includo
                  stat=File::Stat.new(unix_path)
                  if (stat.mtime > self.generator.start_time)
                    file= File.basename(unix_path)
                    files<<file
                  end
                end
            end

          end
        end

        Dir.chdir directory_base do
          #Guardo el archivo de directorio
          file= Tempfile.new('files')

          begin
            file.write(files.join($/))
            file.close
            file_path= file.path.gsub /\//, '\\'

            parameters<<" /f #{file_path}"

            #Ejecuto el programa
            IO.popen("\"#{binary_file}\" #{parameters}").each do |line|
              message_helper.puts_code_clean(line.chomp)
            end


          ensure
            file.close
            file.unlink # deletes the temp file
          end


        end
      ensure
        message_helper.remove_indent
        puts
      end

    end

    def find_binary
      bin_directories.each do |bin|
        current_path= File.join(bin, BINARY)
        return current_path if File.exist?(current_path)
      end

    end
  end
end



