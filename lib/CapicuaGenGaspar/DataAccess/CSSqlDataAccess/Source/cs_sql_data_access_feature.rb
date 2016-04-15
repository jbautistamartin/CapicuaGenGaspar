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

require_relative '../../../gaspar'
require_relative '../../../Mixins/cs_db_connection_provider_mixin'
require_relative '../../../Mixins/cs_namespace_mixin'
require_relative '../../../Mixins/entity_interface_mixin'
require_relative '../../../Mixins/entity_sql_table_mixin'


module CapicuaGen::Gaspar

  # Caracteristica generadora para la capa de persistencia
  # en case a las entidades obtenidas en un archivo .SQL
  class CSSqlDataAccessFeature < CapicuaGen::TemplateFeature
    include CapicuaGen
    include CapicuaGen::Gaspar
    include CapicuaGen::Melchior


    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:data_access] if self.types.blank?

      # Configuro los templates
      set_template("data_access_exception", Template.new(:file => 'data_access_exception.erb'))
      set_template("data_access", Template.new(:file => 'data_access.erb'))
      set_template("data_access_table", Template.new(:file => 'data_access_table.erb'))


    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Configuro los templates
      set_template_target('data_access_exception', TemplateTarget.new(:out_file => "DataAccessException.cs", :types => :proyect_file, :class_name => 'DataAccessException'))
      set_template_target('data_access', TemplateTarget.new(:out_file => "DataAccess.cs", :types => :proyect_file, :class_name => 'DataAccess'))

      # Busco  las caracteristicas que contiene entidades de SQL para una table
      get_tables do |e|
        set_template_target("data_access_table/#{get_entity_data_access_name(e.name)}",
                            TemplateTarget.new(
                                :out_file      => "#{get_entity_data_access_name(e.name)}.cs",
                                :types         => :proyect_file,
                                :class_name    => get_entity_data_access_name(e.name),
                                :entity_schema => e,
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
      self.generation_attributes[:out_dir]  = "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}/Data.Access" unless self.generation_attributes.has_in_self?(:out_dir)
      self.generation_attributes[:namespace]= "#{self.generation_attributes[:namespace]}.Data.Access" unless self.generation_attributes.has_in_self?(:namespace)
    end


    # Obtiene el nombre de la clase de persistencia asociada a una entidad
    def get_entity_data_access_name(entity_name)
      return "#{entity_name}DataAccess"
    end

    # Obtiene el nombre completo de la clase de persistencia asociada a una entidad
    def get_entity_data_access_full_name(entity_name)
      return "#{self.generation_attributes[:namespace]}.#{get_entity_data_access_name(entity_name)}"
    end

  end
end


