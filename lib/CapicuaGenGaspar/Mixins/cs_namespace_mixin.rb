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
de proveedoras de funcionalidad para acceder a los namespaces generados
=end


require 'CapicuaGen/Mixins/parameter_mixin'
require 'CapicuaGen/Mixins/attributes_mixin'

module CapicuaGen::Gaspar
  include CapicuaGen

  public

  # Devuelve una coleccion de namespace
  def get_namespaces(target_types= [])
    get_attributes( :attributes=>:namespace, :target_types=>target_types) do |a,values|
      values.each {|v| yield v}
    end
  end

  # Devuelve un unico string con imports del namespace
  def get_namespaces_text(target_types= [])
    result= ''
    # Busco  las caracteristicas que contiene entidades de SQL para una table
    get_namespaces(target_types) do |n|
      result << "using #{n};#{$/}"
    end
    return result;
  end
end

