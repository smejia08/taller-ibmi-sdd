# Entregables tecnicos

| Objeto | Tipo | Archivo | Responsabilidad |
|---|---|---|---|
| GLBCONC | CLLE | qcllesrc/glbconc.clle | Entrada batch, validacion basica y llamada a GLBATCH. |
| GLBATCH | SQLRPGLE | qrpglesrc/glbatch.sqlrpgle | Orquestacion de ejecucion, estados, totales y flujo batch. |
| GLBDATA | SRVPGM | qrpglesrc/glbdata.sqlrpgle | Acceso DB2 for i mediante vistas normalizadas. |
| GLBRULES | SRVPGM | qrpglesrc/glbrules.rpgle | Calculo de saldos, tolerancia, estados e incidentes. |
| GLBJSON | SRVPGM | qrpglesrc/glbjson.sqlrpgle | Construccion y validacion basica del contrato JSON. |
| GLBIFS | SRVPGM | qrpglesrc/glbifs.sqlrpgle | Validacion y publicacion atomica en IFS con QSYS2.IFS_WRITE_UTF8. |
| GLBLOG | SRVPGM | qrpglesrc/glblog.sqlrpgle | Bitacora TXT normalizada de ejecucion con QSYS2.IFS_WRITE_UTF8. |
| GLBTYPES | Include | qrpglesrc/glbtypes.rpgleinc | Contratos comunes entre componentes. |
| V_GLBLN_CTX | SQL View | qsqlsrc/V_GLBLN_CTX.sql | Vista GLBLN filtrable y enriquecida. |
| V_GL_MOVS | SQL View | qsqlsrc/V_GL_MOVS.sql | Vista de movimientos TRANS y TTRAN normalizados. |
| GLBDATA | Binder | qsrvsrc/GLBDATA.bnd | Exportaciones del servicio de datos. |
| GLBRULES | Binder | qsrvsrc/GLBRULES.bnd | Exportaciones del servicio de reglas. |
| GLBJSON | Binder | qsrvsrc/GLBJSON.bnd | Exportaciones del servicio JSON. |
| GLBIFS | Binder | qsrvsrc/GLBIFS.bnd | Exportaciones del servicio IFS. |
| GLBLOG | Binder | qsrvsrc/GLBLOG.bnd | Exportaciones del servicio de logging. |
| GLBUTIL | Binder | qsrvsrc/GLBUTIL.bnd | Contrato utilitario de IFS y logging. |
| DDM_GLBLN | DDM | qsqlsrc/DDM_GLBLN.md | Mapeo logico de balances generales. |
| DDM_GLMST | DDM | qsqlsrc/DDM_GLMST.md | Mapeo logico de maestro contable. |
| DDM_TRANS | DDM | qsqlsrc/DDM_TRANS.md | Mapeo logico de movimientos historicos. |
| DDM_TTRAN | DDM | qsqlsrc/DDM_TTRAN.md | Mapeo logico de movimientos del dia. |
| DDM_TRDSC | DDM | qsqlsrc/DDM_TRDSC.md | Mapeo logico de descripciones. |
| DDM_CCDSC | DDM | qsqlsrc/DDM_CCDSC.md | Mapeo logico de centros de costo. |
| MOCK_DATA | SQL | qsqlsrc/mock_data.sql | Dataset documental para escenarios minimos. |

## Objetos IBM i para pruebas

| Objeto | Tipo | Archivo | Responsabilidad |
|---|---|---|---|
| TSTRULES | *SRVPGM RPGLE | qrpglesrc/tstrules.rpgle | Procedimientos de los 12 casos unitarios de GLBRULES. |
| TSTDATA | *SRVPGM SQLRPGLE | qrpglesrc/tstdata.sqlrpgle | Procedimientos de los 5 casos de integracion GLBDATA. |
| TSTJSON | *SRVPGM SQLRPGLE | qrpglesrc/tstjson.sqlrpgle | Procedimientos de los 2 casos de integracion GLBJSON. |
| TSTIFS | *SRVPGM SQLRPGLE | qrpglesrc/tstifs.sqlrpgle | Procedimientos de los 3 casos de integracion GLBIFS. |
| TSTLOG | *SRVPGM SQLRPGLE | qrpglesrc/tstlog.sqlrpgle | Procedimiento de integracion GLBLOG. |
| TSTBATCH | *SRVPGM RPGLE | qrpglesrc/tstbatch.rpgle | Procedimiento de flujo completo GLBATCH. |
| MOCK_DEL | SQL Script | qsqlsrc/MOCK_DEL.sql | Limpieza idempotente del dataset de pruebas. |
| MOCK_INS | SQL Script | qsqlsrc/MOCK_INS.sql | Carga idempotente del mock data GLBLN. |
| ASSERT_JSON | SQL Script | qsqlsrc/ASSERT_JSON.sql | Validaciones de contrato JSON con JSON_TABLE. |
| ASSERT_TOTALES | SQL Script | qsqlsrc/ASSERT_TOTALES.sql | Cuadre de controlTotales contra detalle JSON. |
| BLDTST | *PGM CLLE | qcllesrc/bldtst.clle | Compilacion ordenada de programas de prueba. |
| RUNTST | *PGM RPGLE | qrpglesrc/runtst.rpgle | Orquestacion secuencial por procedimientos. |
| TSTSUITE | *PGM CLLE | qcllesrc/tstsuite.clle | Submit de la suite completa de pruebas. |
| T_ASSERT | Include RPGLE | qrpglesrc/t_assert.rpgleinc | Utilidades comunes de asercion y datos base. |
| T_RULES_PR | Include RPGLE | qrpglesrc/t_rules_pr.rpgleinc | Prototipos de procedimientos GLBRULES. |
| T_SVC_PR | Include RPGLE | qrpglesrc/t_svc_pr.rpgleinc | Prototipos de servicios de integracion. |
| T_TESTS_PR | Include RPGLE | qrpglesrc/t_tests_pr.rpgleinc | Prototipos de procedimientos de prueba. |
