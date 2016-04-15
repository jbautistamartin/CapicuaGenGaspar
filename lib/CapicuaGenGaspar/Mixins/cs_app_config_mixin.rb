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
Este Mixin esta programado para obtener información de las caracteristicas
de proveedoras del archivo app.config :app_config
=end


module CapicuaGen::Gaspar

  public

  def get_app_config_file
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:app_config).each do |f|
      # Obtengo las entidades
      return f.get_app_config_file
    end
  end

end

