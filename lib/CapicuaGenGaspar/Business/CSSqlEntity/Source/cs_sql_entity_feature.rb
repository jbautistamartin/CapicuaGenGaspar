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

require_relative '../../../gaspar'
require 'CapicuaGenMelchior/Mixins/entity_sql_table_mixin'

module CapicuaGen::Gaspar

  # Característica generadora para crear entidades de negocio
  # a traves de entidades extraidas un archivo .sql
  class CSSqlEntityFeature < CapicuaGen::TemplateFeature
    include CapicuaGen
    include CapicuaGen::Gaspar
    include CapicuaGen::Melchior


    attr_accessor :class_accessor

    public

    # Inicializa la característica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente

      @class_accessor= "" unless @class_accessor

      self.types     = [:business_entities] if self.types.blank?

      # Configuro los templates
      set_template("table_entity", Template.new(:file => 'table_entity.erb'))


    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Busco  las características que contiene entidades de SQL para una table
      get_tables do |e|
        set_template_target("table_entity/#{get_entity_name(e.name)}",
                            TemplateTarget.new(
                                :out_file       => "#{get_entity_name(e.name)}.cs",
                                :types          => :proyect_file,
                                :class_name     => get_entity_name(e.name),
                                :entity_schema  => e,
                                :class_accessor => @class_accessor,
                            )
        )

      end

    end

    # Resetea los atributos personalizados de la característica (antes de establecer el generador)
    def reset_attributes
      self.generation_attributes[:out_dir]  = nil
      self.generation_attributes[:namespace]= nil
    end

    # Configura los atributos personalizados de la característica (antes de establecer el generador)
    def configure_attributes()
      self.generation_attributes[:out_dir]  = "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}/Entities" unless self.generation_attributes.has_in_self?(:out_dir)
      self.generation_attributes[:namespace]= "#{self.generation_attributes[:namespace]}.Entities" unless self.generation_attributes.has_in_self?(:namespace)
    end


    # Devuelve el nombre de una clase relacionada a un entidad
    def get_entity_name(entity_name)
      return entity_name
    end


    # Devuelve el nombre completo  de una clase relacionada a un entidad
    def get_entity_full_name(entity_name)
      return "#{self.generation_attributes[:namespace]}.#{get_entity_name(entity_name)}"
    end

  end
end


