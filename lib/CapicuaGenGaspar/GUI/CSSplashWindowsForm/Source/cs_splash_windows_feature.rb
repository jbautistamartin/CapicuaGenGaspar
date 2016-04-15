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


module CapicuaGen::Gaspar

  # Caracteristica generadora de una pantalla de Bienvenida
  class CSSplashWindowsFeature < CapicuaGen::TemplateFeature
    include CapicuaGen


    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:gui, :splash_form] if self.types.blank?

      # Configuro los templates
      set_template('splashForm', Template.new(:file => 'SplashForm.erb'))
      set_template('splashForm.designer', Template.new(:file => 'SplashForm.Designer.erb'))
      set_template('splashForm.resx', Template.new(:file => 'SplashForm.resx.erb'))


    end

    # Resetea los atributos personalizados de la caracteristica (antes de establecer el generador)
    def reset_attributes
      self.generation_attributes[:out_dir]  = nil
      self.generation_attributes[:namespace]= nil
    end

    # Configura los atributos personalizados de la caracteristica (antes de establecer el generador)
    def configure_attributes()
      self.generation_attributes[:out_dir]  = "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}/Windows.Forms" unless self.generation_attributes.has_in_self?(:out_dir)
      self.generation_attributes[:namespace]= "#{self.generation_attributes[:namespace]}.Windows.Forms" unless self.generation_attributes.has_in_self?(:namespace)
    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets


      # Configuro los templates
      set_template_target('splashForm', TemplateTarget.new(:out_file => "#{get_class_name}.cs", :types => :proyect_file, :class_name => get_class_name))
      set_template_target('splashForm.designer', TemplateTarget.new(:out_file => "#{get_class_name}.Designer.cs", :types => :proyect_file, :class_name => get_class_name))
      set_template_target('splashForm.resx', TemplateTarget.new(:out_file => "#{get_class_name}.resx", :types => :proyect_file, :class_name => get_class_name))

    end

    # Obtiene el nombre de la clase
    def get_class_name
      return "SplashForm"
    end

    # Obtiene el nombre completo de la clase
    def get_class_full_name
      return "#{self.generation_attributes[:namespace]}.#{get_class_name}"
    end


  end
end