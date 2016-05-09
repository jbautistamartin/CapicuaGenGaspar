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

=begin
Este Mixin esta programado para obtener información de las características
de proveedoras de ventanas de bienvenida :splash_form
=end

module CapicuaGen::Gaspar

  public

  # Obtiene el nombre de las ventanas de bienvenidas existentes
  def get_splash_class_name
    # Busco  las características que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:splash_form).each do |f|
      # Obtengo las entidades
      return f.get_class_name
    end

    return nil
  end

  # Obtiene el nombre completo de las ventanas de bienvenidas existentes
  def get_splash_class_full_name
    # Busco  las características que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:splash_form).each do |f|
      # Obtengo las entidades
      return f.get_class_full_name
    end

    return nil
  end

end

