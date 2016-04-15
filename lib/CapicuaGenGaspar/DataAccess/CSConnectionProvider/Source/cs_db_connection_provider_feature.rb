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


require 'active_support/core_ext/object/blank'
require 'nokogiri'

require_relative '../../../gaspar'
require_relative '../../../Mixins/cs_app_config_mixin'

module CapicuaGen::Gaspar
# Caracteristica generadora que devuelve un metodo
  # para configurar una cadena de conexion dentro del codigo generado
  class CSDBConnectionProviderFeature < CapicuaGen::Feature
    include CapicuaGen
    include CapicuaGen::Gaspar


    public
	
		# Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
   self.types= [:data_connection_provider, :transformer]   if self.types.blank?
          
    end


    # Devuelve el metodo que genera el proveedor de conexion
    def get_db_connection_provider_method
      return "DbProviderFactories.GetFactory(ConfigurationManager.ConnectionStrings[\"#{generation_attributes[:app_config_db_connection_name]}\"].ProviderName)"
    end

    def get_db_connection_name_method
      return "\"#{generation_attributes[:app_config_db_connection_name]}\""
    end

    # Devuelve la cadena de conexión
    def get_db_connection_string_method
      return "ConfigurationManager.ConnectionStrings[\"#{generation_attributes[:app_config_db_connection_name]}\"].ConnectionString"
    end

    # Modifica el archivo App.Config para que contenga la cadena de conexión a la base de datos
    def generate

      # Ruta para conseguir el archivo app.config
      xml= Nokogiri::XML(File.read(get_app_config_file))
      xpath= "connectionStrings/add[@name= '#{generation_attributes[:app_config_db_connection_name]}']"

      # Recupero el nodo
      node= XMLHelper.get_node_from_xml_document(xml, xpath)

      # Configuro el nodo
      node['name']= generation_attributes[:app_config_db_connection_name]
      node['connectionString']= generation_attributes[:app_config_db_connection_string]
      node['providerName']= generation_attributes[:app_config_db_connection_provider]

      # Formateo el texto
      formatted_xml= XMLHelper.format(xml.to_xml)

      # Guardo el resultado
      File.write(get_app_config_file,formatted_xml)

    end

  end
end



