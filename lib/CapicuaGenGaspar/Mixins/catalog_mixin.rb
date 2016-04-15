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
de proveedoras de los ventanas de administracion (persistencia)
de entidades :catalog
=end

module CapicuaGen::Gaspar

  public

  # Obtiene el nombre completo de los catalogos
  def get_entity_catalogs_full_name
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:catalog).each do |f|
      # Obtengo las entidades
      f.get_entity_catalogs_full_name do |e|
        yield e
      end
    end
  end

  # Obtiene el nombre  de los catalogos
  def get_entity_catalogs_name
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:catalog).each do |f|
      # Obtengo las entidades
      f.get_entity_catalogs_name do |e|
        yield e
      end
    end
  end

  # Obtiene una entidad en base al nombre del catalogo
  def get_entity_by_catalog_name(catalog_name)
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    generator.get_features_in_targets_by_type(:catalog).each do |f|
      # Obtengo las entidades
      return f.get_entity_by_catalog_name(catalog_name)
    end
  end

end

