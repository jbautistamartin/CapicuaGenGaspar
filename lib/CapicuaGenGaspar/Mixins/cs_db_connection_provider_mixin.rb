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
de proveedoras de  conexciones a base de datos :data_connection_provider
=end


module CapicuaGen::Gaspar

  public

  # Devuelve el metodo para acceder a el proveedor de la coexion
  def get_db_connection_provider_method
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:data_connection_provider).each do |f|
      # Obtengo las entidades
      return f.get_db_connection_provider_method
    end

    return nil
  end

  # Devuelve el nombre de la conexión
  def get_db_connection_name_method
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:data_connection_provider).each do |f|
      # Obtengo las entidades
      return f.get_db_connection_name_method
    end

    return nil
  end

  # Devuelve la cadena de conexion de la conexión
  def get_db_connection_string_method
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:data_connection_provider).each do |f|
      # Obtengo las entidades
      return f.get_db_connection_string_method
    end

    return nil
  end

end

