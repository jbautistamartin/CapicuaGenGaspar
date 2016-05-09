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
Gaspar es un conjunto de generadores de características de ejemplo pertenecientes a CapicuaGen
que generan un proyecto de Windows
=end

require_relative 'version'
require 'CapicuaGenMelchior/melchior'
require_relative 'Business/CSSqlEntitityInterface/Source/cs_sql_entity_interface_feature'
require_relative 'Business/CSSqlEntity/Source/cs_sql_entity_feature'
require_relative 'CodeTransformer/CSHeaderFooter/Source/cs_header_footer_feature'
require_relative 'CodeTransformer/CodeMaidCleaner/Source/code_maid_cleaner_feature'
require_relative 'DataAccess/CSConnectionProvider/Source/cs_db_connection_provider_feature'
require_relative 'DataAccess/CSSqlDataAccess/Source/cs_sql_data_access_feature'
require_relative 'Entities/CSEntity/Source/entity_field_schema'
require_relative 'GUI/CSAboutWindowsForm/Source/cs_about_windows_form_feature'
require_relative 'GUI/CSCatalogWindowsForm/Source/cs_catalog_windows_form_feature'
require_relative 'GUI/CSMDIWindowsForm/Source/cs_mdi_windows_form_feature'
require_relative 'GUI/CSSplashWindowsForm/Source/cs_splash_windows_feature'
require_relative 'Proyect/CSProyect/Source/cs_proyect_feature'
require_relative 'Proyect/CSProyectRESTFul/Source/cs_proyect_rest_ful_feature'
require_relative 'Proyect/CSProyectWindowsForm/Source/cs_proyect_windows_form_feature'
require_relative 'Tools/message_helper'
require_relative 'WCFService/CSRESTFulCatalog/Source/cs_rest_ful_catalog_feature'