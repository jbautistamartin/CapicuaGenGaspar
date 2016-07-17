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

# Agrega opciones de refleccion a las clases que lo implementan
module CapicuaGen

  # Modifica la clase MessageHelper para agregar informacion relativa
  # a los mensajes generados por GASPAR
  class MessageHelper

    public


    # Indica que un archivo fue limpiado (por CodeMaid)
    def puts_code_clean(out_file)
      result= "*".colorize(:yellow) + " -> '#{out_file}': Modificado"
      puts_message result
    end


  end


end