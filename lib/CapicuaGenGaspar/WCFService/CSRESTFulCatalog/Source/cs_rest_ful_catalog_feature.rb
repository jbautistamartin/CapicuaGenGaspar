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


require 'CapicuaGen/Mixins/attributes_mixin'
require_relative '../../../Mixins/cs_namespace_mixin'
require_relative '../../../Mixins/entity_interface_mixin'
require_relative '../../../Mixins/entity_mixin'
require_relative '../../../Mixins/entity_sql_table_mixin'


module CapicuaGen::Gaspar
  # Caracteristica generadora para acceso a catalogos de RestFUL
  # creados a traves de entidades de negocio
  class CSRESTFULCatalogFeature < CapicuaGen::TemplateFeature
    include CapicuaGen
    include CapicuaGen::Gaspar
    include CapicuaGen::Melchior

    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:catalog] if self.types.blank?

      # Configuro los templates
      set_template("catalogState", Template.new(:file => 'CatalogState.erb'))
      set_template('catalogs', Template.new(:file => 'Catalogs.erb'))
      set_template('catalogs.svc', Template.new(:file => 'Catalogs.svc.erb'))
      set_template('icatalogs', Template.new(:file => 'ICatalogs.erb'))


    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Configuro los templates
      set_template_target('catalogState', TemplateTarget.new(:out_file => "CatalogState.cs", :types => :proyect_file))
      set_template_target('catalogs', TemplateTarget.new(:out_file => "Catalogs.svc.cs", :types => :proyect_file, :class_name => 'Catalogs'))
      set_template_target('catalogs.svc', TemplateTarget.new(:out_file => "Catalogs.svc", :types => :proyect_file, :class_name => 'Catalogs'))
      set_template_target('icatalogs', TemplateTarget.new(:out_file => "ICatalogs.cs", :types => :proyect_file, :class_name => 'ICatalogs'))


    end

    # Resetea los atributos personalizados de la caracteristica (antes de establecer el generador)
    def reset_attributes
      self.generation_attributes[:out_dir]  = nil
      self.generation_attributes[:namespace]= nil
    end

    # Configura los atributos personalizados de la caracteristica (antes de establecer el generador)
    def configure_attributes()
      self.generation_attributes[:out_dir]  = "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}/Services" unless self.generation_attributes.has_in_self?(:out_dir)
      self.generation_attributes[:namespace]= "#{self.generation_attributes[:namespace]}.Services" unless self.generation_attributes.has_in_self?(:namespace)
    end

    # Obtiene el nombre de un catalogo asociado a una entidad
    def get_entity_catalog_name(entity_name)
      return "#{entity_name}Catalog"
    end

    # Obtiene el nombre completo de un catalogo asociado a una entidad
    def get_entity_catalog_full_name (entity_name)
      return "#{self.generation_attributes[:namespace]}.#{get_entity_catalog_name(entity_name)}"
    end


    # Obtiene el nombre completo de todos los catalogos asociados a una entidad
    def get_entity_catalogs_full_name
      # Busco  las caracteristicas que contiene entidades de SQL para una table
      get_tables do |e|
        yield get_entity_catalog_full_name e.name
      end
    end

    # Obtiene el nombre  de todos los catalogos asociados a una entidad
    def get_entity_catalogs_name
      # Busco  las caracteristicas que contiene entidades de SQL para una table
      get_tables do |e|
        yield get_entity_catalog_name e.name
      end
    end

    # Devuelve una entidad en base al nombre de su catalogo
    def get_entity_by_catalog_name(catalog_name)
      # Busco  las caracteristicas que contiene entidades de SQL para una table
      get_tables do |e|
        if catalog_name==get_entity_catalog_name(e.name)
          return e
        end
      end
      return nil
    end

    # Genera la caracteristica
    def generate
      super()
      generate_configuration
    end

    # Genera las configuraciones necesarias dentro del archivo web.config
    def generate_configuration

      web_config_file= get_app_config_file

      return unless web_config_file

      # Ruta para conseguir el archivo app.config

      xml                          = Nokogiri::XML(File.read(web_config_file))

      # Recupero el nodo
      xpath                        = "system.serviceModel/services/service[@name= '#{self.generation_attributes[:namespace]}.Catalogs']"
      node                         = XMLHelper.get_node_from_xml_document(xml, xpath)

      # Configuro el nodo
      node['name']                 = "#{self.generation_attributes[:namespace]}.Catalogs"

      # Recupero el nodo
      xpath                        = "#{xpath}/endpoint"
      node                         = XMLHelper.get_node_from_xml_document(xml, xpath)

      #Configuro el nodo
      node['binding']              = "webHttpBinding"
      node['contract']             = "#{self.generation_attributes[:namespace]}.ICatalogs"
      node['behaviorConfiguration']= "web"


      # Recupero el nodo
      xpath                        = "system.serviceModel/behaviors/endpointBehaviors/behavior[@name= 'web']"
      path                         = "system.serviceModel/behaviors/endpointBehaviors/behavior"
      node                         = XMLHelper.get_node_from_xml_document(xml, xpath)

      # Configuro el nodo
      node['name']                 = "web"

      xpath        = "system.serviceModel/behaviors/endpointBehaviors/behavior/webHttp"
      path         = "system.serviceModel/behaviors/endpointBehaviors/behavior/webHttp"
      node         = XMLHelper.get_node_from_xml_document(xml, xpath)

      # Formateo el texto
      formatted_xml= XMLHelper.format(xml.to_xml)

      # Guardo el resultado
      File.write(web_config_file, formatted_xml)

    end

  end

end
