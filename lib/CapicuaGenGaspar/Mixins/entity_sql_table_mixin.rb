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
de proveedoras de ventanas principales :main_form
=end


require 'CapicuaGenMelchior/Mixins/entity_sql_table_mixin'

module CapicuaGen::Gaspar

  public

  # Obtiene el nombre de las clase de persistenacia que le corresponde a una entidad
  def get_entity_data_access_name(entity_name)
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:data_access).each do |f|
      # Obtengo las entidades
      name= f.get_entity_data_access_name(entity_name)
      return name if name
    end
    return nil
  end

  # Obtiene el nombre completo de las clase de persistenacia que le corresponde a una entidad
  def get_entity_data_access_full_name(entity_name)
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:data_access).each do |f|
      # Obtengo las entidades
      name= f.get_entity_data_access_full_name(entity_name)
      return name if name
    end
    return nil
  end


end

