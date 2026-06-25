-- Validaciones de contrato JSON desde archivo IFS de prueba.

select count(*) as cuentas_json
  from json_table(
         get_clob_from_file('/GLBTST/output/CONCILIACION_GLBLN_TST.json'),
         'strict $.cuentas[*]'
         columns (
           cuenta varchar(24)
             path '$.identificacion.cuentaContable',
           estado varchar(15)
             path '$.estadoConciliacion'
         )
       ) as jt;

select count(*) as secciones_obligatorias
  from sysibm.sysdummy1
 where json_exists(
         get_clob_from_file('/GLBTST/output/CONCILIACION_GLBLN_TST.json'),
         '$.metadata'
       )
   and json_exists(
         get_clob_from_file('/GLBTST/output/CONCILIACION_GLBLN_TST.json'),
         '$.ejecucion'
       )
   and json_exists(
         get_clob_from_file('/GLBTST/output/CONCILIACION_GLBLN_TST.json'),
         '$.controlTotales'
       );

