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
require 'uuidtools'


require_relative '../../../Mixins/main_form_mixin'
require_relative '../../../Mixins/splash_mixin'
require_relative '../../../Proyect/CSProyect/Source/cs_proyect_feature'
require_relative '../../../gaspar'


module CapicuaGen::Gaspar
  # Caracteristica generadora para crear un proyecto RestFul
  class CSProyectRESTFulFeature < CapicuaGen::Gaspar::CSProyectFeature
    include CapicuaGen
    include CapicuaGen::Gaspar

    public

    # Inicializa la caracteristica
    def initialize(values= {})
      super(values)

      # Configuro los tipos si estos no han sido configurados previamente
      self.types= [:proyect, :soluction, :app_config] if self.types.blank?

      # Configuro los templates
      set_template('soluction', Template.new(:file => 'Soluction.erb'))
      set_template('proyect', Template.new(:file => 'Proyect.erb'))
      set_template('web.config', Template.new(:file => 'Web.erb'))
      set_template('assemblyInfo', Template.new(:file => 'AssemblyInfo.erb'))
      set_template('excepcion_controlada', Template.new(:file => 'ExcepcionControlada.erb'))

      # Configuro los Guid de la solucion
      self.generation_attributes[:soluction_guid]= UUIDTools::UUID.random_create.to_s.upcase
      self.generation_attributes[:project_guid]  = UUIDTools::UUID.random_create.to_s.upcase


    end


    # Configura los objetivos de las platillas (despues de establecer el generador)
    def configure_template_targets

      # Configuro los templates
      set_template_target('soluction', TemplateTarget.new(:out_file => "../#{@generator.generation_attributes[:namespace]}.sln", :types => :soluction))
      set_template_target('proyect', TemplateTarget.new(:out_file => "#{@generator.generation_attributes[:namespace]}.csproj", :types => :proyect))
      set_template_target('web.config', TemplateTarget.new(:out_file => "Web.Config", :types => :proyect_file))
      set_template_target('assemblyInfo', TemplateTarget.new(:out_file => 'Properties/AssemblyInfo.cs', :types => :proyect_file))
      set_template_target('excepcion_controlada', TemplateTarget.new(:out_file => "ExcepcionControlada.cs", :types => :proyect_file))


    end

    # Devuelve la localizacion del archivo app.config
    def get_app_config_file
      return File.join(generation_attributes[:out_dir], get_template_target_by_name('web.config').out_file)
    end


  end
end