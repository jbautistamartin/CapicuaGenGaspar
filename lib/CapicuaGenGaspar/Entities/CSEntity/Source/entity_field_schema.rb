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


module CapicuaGen::Melchior

  # Modifica la case Entity Field Schema, para agregar
  # referencias a componentes de .NET
  class EntityFieldSchema

    # Convierte el tipo de un campo o un tipo de .NET
    def net_type

      case @type.upcase
        when "SMALLINT"
          return "Int16"
        when "INTEGER", "INT"
          return "int"
        when "DECIMAL", "REAL", "MONEY"
          return "decimal"
        when "CHAR", "VARCHAR", "NCHAR", "NVARCHAR"
          return "string"
        when "DATE", "DATETIME"
          return "DateTime"
        when "BIT"
          return "bool"
        else
          return "object"
      end
    end


    # Convierte el tipo de un campo o un tipo SQL de .NET
    def sql_net_type

      case @type.upcase
        when "SMALLINT"
          return "DbType.Int16"
        when "INTEGER", "INT"
          return "DbType.Int32"
        when "DECIMAL", "REAL", "MONEY"
          return "DbType.Decimal"
        when "CHAR", "VARCHAR", "NCHAR", "NVARCHAR"
          return "DbType.String"
        when "DATE", "DATETIME"
          return "DbType.DateTime"
        when "BIT"
          return "DbType.Boolean"
        else
          return "DbType.String"
      end

    end


    # Convierte el tipo de un campo desde un texto, a un objeto .NET
    def convert_from_text
      case @type.upcase
        when "SMALLINT"
          return "Convert.ToInt16("
        when "INTEGER", "INT"
          return "Convert.ToInt32("
        when "DECIMAL", "REAL", "MONEY"
          return "Convert.ToDecimal("
        when "CHAR", "VARCHAR", "NCHAR", "NVARCHAR"
          return "("
        when "DATE", "DATETIME"
          return "Convert.ToDateTime("
        when "BIT"
          return "Convert.ToBoolean("
        else
          return "("
      end
    end

  end

end
