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

require_relative '../../../gaspar'
require 'active_support/core_ext/object/blank'
require_relative '../../../Mixins/entity_sql_table_mixin'
require_relative '../../../Mixins/entity_interface_mixin'
require_relative '../../../Mixins/entity_mixin'
require_relative '../../../Mixins/cs_namespace_mixin'


module CapicuaGen::Gaspar

  # Caracteristica generadora de catalogos para las entidades
  class CSCatalogWindowsFormFeature < CapicuaGen::TemplateFeature
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
      set_template('catalogForm', Template.new(:file => 'catalogForm.erb'))
      set_template('catalogForm.designer', Template.new(:file => 'catalogForm.Designer.erb'))
      set_template('catalogForm.resx', Template.new(:file => 'catalogForm.resx.erb'))

    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Configuro los templates
      set_template_target('catalogState', TemplateTarget.new(:out_file => "CatalogState.cs", :types => :proyect_file))

      # Busco  las caracteristicas que contiene entidades de SQL para una table
      get_tables do |e|

        set_template_target("catalogForm/#{get_entity_catalog_name(e.name)}",
                            TemplateTarget.new(
                                :out_file      => "#{get_entity_catalog_name(e.name)}.cs",
                                :types         => :proyect_file,
                                :class_name    => get_entity_catalog_name(e.name),
                                :entity_schema => e
                            )
        )

        set_template_target("catalogForm.designer/#{get_entity_catalog_name(e.name)}",
                            TemplateTarget.new(
                                :out_file      => "#{get_entity_catalog_name(e.name)}.designer.cs",
                                :types         => :proyect_file,
                                :class_name    => get_entity_catalog_name(e.name),
                                :entity_schema => e
                            )
        )

        set_template_target("catalogForm.resx/#{get_entity_catalog_name(e.name)}",
                            TemplateTarget.new(
                                :out_file      => "#{get_entity_catalog_name(e.name)}.resx",
                                :types         => :proyect_file,
                                :class_name    => get_entity_catalog_name(e.name),
                                :entity_schema => e
                            )
        )

      end

    end

    # Resetea los atributos personalizados de la caracteristica (antes de establecer el generador)
    def reset_attributes
      self.generation_attributes[:out_dir]  = nil
      self.generation_attributes[:namespace]= nil
    end

    # Configura los atributos personalizados de la caracteristica (antes de establecer el generador)
    def configure_attributes()
      self.generation_attributes[:out_dir]  = "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}/Windows.Forms/EntityCatalogs" unless self.generation_attributes.has_in_self?(:out_dir)
      self.generation_attributes[:namespace]= "#{self.generation_attributes[:namespace]}.Windows.Forms.EntityCatalogs" unless self.generation_attributes.has_in_self?(:namespace)
    end

    # Obtiene el nombre de un catalogo en base al nombre de una entidad
    def get_entity_catalog_name(entity_name)
      return "#{entity_name}Catalog"
    end

    # Obtiene el nombre completo de un catalogo en base al nombre de una entidad
    def get_entity_catalog_full_name (entity_name)
      return "#{self.generation_attributes[:namespace]}.#{get_entity_catalog_name(entity_name)}"
    end

    # Obtiene el nombre completo de todos los catalogos
    def get_entity_catalogs_full_name
      # Busco  las caracteristicas que contiene entidades de SQL para una table
      get_tables do |e|
        yield get_entity_catalog_full_name e.name
      end
    end

    # Obtiene el nombre  de todos los catalogos
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

  end

end