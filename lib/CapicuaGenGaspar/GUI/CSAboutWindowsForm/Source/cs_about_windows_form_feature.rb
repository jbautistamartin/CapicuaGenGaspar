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

  # Clase generadora de una ventada "Acerca de ..."
  class CSAboutWindowsFormFeature < CapicuaGen::TemplateFeature
    include CapicuaGen


    public
	
	# Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
       self.types= [:gui, :about_form] if self.types.blank?
      

      # Configuro los templates
      set_template('aboutForm', Template.new(:file=>'aboutForm.erb'))
      set_template('aboutForm.designer', Template.new(:file=>'aboutForm.Designer.erb'))
      set_template('aboutForm.resx', Template.new(:file=>'aboutForm.resx.erb'))


    end

	# Resetea los atributos personalizados de la caracteristica (antes de establecer el generador)
    def reset_attributes
      self.generation_attributes[:out_dir]= nil
      self.generation_attributes[:namespace]= nil
    end

	# Configura los atributos personalizados de la caracteristica (antes de establecer el generador)
    def configure_attributes()
      self.generation_attributes[:out_dir]= "#{self.generation_attributes[:out_dir]}/#{self.generation_attributes[:namespace]}/Windows.Forms" unless self.generation_attributes.has_in_self?(:out_dir)
      self.generation_attributes[:namespace]= "#{self.generation_attributes[:namespace]}.Windows.Forms" unless self.generation_attributes.has_in_self?(:namespace)
    end

# Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets


      # Configuro los templates
      set_template_target('aboutForm', TemplateTarget.new(:out_file=>"#{get_class_name}.cs", :types=>:proyect_file, :class_name=>get_class_name))
      set_template_target('aboutForm.designer', TemplateTarget.new(:out_file=>"#{get_class_name}.Designer.cs", :types=>:proyect_file, :class_name=>get_class_name))
      set_template_target('aboutForm.resx', TemplateTarget.new(:out_file=>"#{get_class_name}.resx", :types=>:proyect_file, :class_name=>get_class_name))

    end

    def get_class_name
      return "AboutForm"
    end

    def get_class_full_name
      return "#{self.generation_attributes[:namespace]}.#{get_class_name}"
    end


  end
end