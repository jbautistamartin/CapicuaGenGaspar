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

require_relative '../../../Mixins/about_mixin'
require_relative '../../../Mixins/catalog_mixin'
require_relative '../../../Mixins/cs_namespace_mixin'
require_relative '../../../gaspar'

module CapicuaGen::Gaspar

  # Caracteristica generador de un formulario MDI
  class CSMDIWindowsFormFeature < CapicuaGen::TemplateFeature
    include CapicuaGen
    include CapicuaGen::Gaspar
    include CapicuaGen::Melchior


    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:gui, :main_form] if self.types.blank?

      # Configuro los templates
      set_template('mainForm', Template.new(:file => 'MainForm.erb'))
      set_template('mainForm.designer', Template.new(:file => 'MainForm.Designer.erb'))
      set_template('mainForm.resx', Template.new(:file => 'MainForm.resx.erb'))
      set_template('msgboxConsts', Template.new(:file => 'MsgboxConsts.erb'))


    end

    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets


      # Configuro los templates
      set_template_target('mainForm', TemplateTarget.new(:out_file => "#{get_class_name}.cs", :types => :proyect_file, :class_name => get_class_name))
      set_template_target('mainForm.designer', TemplateTarget.new(:out_file => "#{get_class_name}.Designer.cs", :types => :proyect_file, :class_name => get_class_name))
      set_template_target('mainForm.resx', TemplateTarget.new(:out_file => "#{get_class_name}.resx", :types => :proyect_file, :class_name => get_class_name))
      set_template_target('msgboxConsts', TemplateTarget.new(:out_file => 'MsgboxConsts.cs', :types => :proyect_file, :class_name => 'MsgboxConsts'))


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

    # Obtiene el nombre de la clae
    def get_class_name
      return "MainForm"
    end

    # Obtiene el nombre completo de la clae
    def get_class_full_name
      return "#{self.generation_attributes[:namespace]}.#{get_class_name}"
    end


  end
end