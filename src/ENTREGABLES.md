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
| T_RULES01 | *PGM RPGLE | qrpglesrc/t_rules01.rpgle | Prueba calcSaldoCuenta con cuenta conciliada. |
| T_RULES02 | *PGM RPGLE | qrpglesrc/t_rules02.rpgle | Prueba calcSaldoCuenta fuera de tolerancia. |
| T_RULES03 | *PGM RPGLE | qrpglesrc/t_rules03.rpgle | Prueba calcSaldoCuenta sin movimientos. |
| T_RULES04 | *PGM RPGLE | qrpglesrc/t_rules04.rpgle | Prueba calcSaldoCuenta con signo invalido RUL001. |
| T_RULES05 | *PGM RPGLE | qrpglesrc/t_rules05.rpgle | Prueba evalTolerancia con tolerancia cero. |
| T_RULES06 | *PGM RPGLE | qrpglesrc/t_rules06.rpgle | Prueba evalTolerancia con tolerancia negativa RUL010. |
| T_RULES07 | *PGM RPGLE | qrpglesrc/t_rules07.rpgle | Prueba clasificaEstado NORMAL/CONCILIADA. |
| T_RULES08 | *PGM RPGLE | qrpglesrc/t_rules08.rpgle | Prueba clasificaEstado OBSERVADO/PARCIAL. |
| T_RULES09 | *PGM RPGLE | qrpglesrc/t_rules09.rpgle | Prueba clasificaEstado CRITICO/NO_PROCESADA. |
| T_RULES10 | *PGM RPGLE | qrpglesrc/t_rules10.rpgle | Prueba buildIncidentesCuenta DIF001. |
| T_RULES11 | *PGM RPGLE | qrpglesrc/t_rules11.rpgle | Prueba dispatchReglas version 1.0. |
| T_RULES12 | *PGM RPGLE | qrpglesrc/t_rules12.rpgle | Prueba dispatchReglas version no soportada. |
| TI_DATA01 | *PGM SQLRPGLE | qrpglesrc/ti_data01.sqlrpgle | Integracion cursor GLBLN con filtros. |
| TI_DATA02 | *PGM SQLRPGLE | qrpglesrc/ti_data02.sqlrpgle | Integracion enriquecimiento GLMST con match. |
| TI_DATA03 | *PGM SQLRPGLE | qrpglesrc/ti_data03.sqlrpgle | Integracion GLMST faltante no fatal. |
| TI_DATA04 | *PGM SQLRPGLE | qrpglesrc/ti_data04.sqlrpgle | Integracion movimientos TRANS y TTRAN. |
| TI_DATA05 | *PGM SQLRPGLE | qrpglesrc/ti_data05.sqlrpgle | Integracion descripciones faltantes. |
| TI_JSON01 | *PGM SQLRPGLE | qrpglesrc/ti_json01.sqlrpgle | Integracion JSON de cuenta conciliada. |
| TI_JSON02 | *PGM SQLRPGLE | qrpglesrc/ti_json02.sqlrpgle | Integracion JSON con incidentes y controlTotales. |
| TI_IFS01 | *PGM SQLRPGLE | qrpglesrc/ti_ifs01.sqlrpgle | Integracion escritura temporal IFS valida. |
| TI_IFS02 | *PGM SQLRPGLE | qrpglesrc/ti_ifs02.sqlrpgle | Integracion publicacion de temporal a final. |
| TI_IFS03 | *PGM SQLRPGLE | qrpglesrc/ti_ifs03.sqlrpgle | Integracion error de ruta IFS invalida. |
| TI_LOG01 | *PGM SQLRPGLE | qrpglesrc/ti_log01.sqlrpgle | Integracion bitacora TXT normalizada. |
| TI_BATCH01 | *PGM SQLRPGLE | qrpglesrc/ti_batch01.sqlrpgle | Integracion flujo completo GLBATCH y servicios. |
| MOCK_DEL | SQL Script | qsqlsrc/MOCK_DEL.sql | Limpieza idempotente del dataset de pruebas. |
| MOCK_INS | SQL Script | qsqlsrc/MOCK_INS.sql | Carga idempotente del mock data GLBLN. |
| ASSERT_JSON | SQL Script | qsqlsrc/ASSERT_JSON.sql | Validaciones de contrato JSON con JSON_TABLE. |
| ASSERT_TOTALES | SQL Script | qsqlsrc/ASSERT_TOTALES.sql | Cuadre de controlTotales contra detalle JSON. |
| BLDTST | *PGM CLLE | qcllesrc/bldtst.clle | Compilacion ordenada de programas de prueba. |
| RUNTST | *PGM CLLE | qcllesrc/runtst.clle | Orquestacion secuencial de la suite de pruebas. |
| TSTSUITE | *PGM CLLE | qcllesrc/tstsuite.clle | Submit de la suite completa de pruebas. |
| T_ASSERT | Include RPGLE | qrpglesrc/t_assert.rpgleinc | Utilidades comunes de asercion y datos base. |
| T_RULES_PR | Include RPGLE | qrpglesrc/t_rules_pr.rpgleinc | Prototipos de procedimientos GLBRULES. |
| T_SVC_PR | Include RPGLE | qrpglesrc/t_svc_pr.rpgleinc | Prototipos de servicios de integracion. |
