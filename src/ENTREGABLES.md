# Entregables tecnicos

| Objeto | Tipo | Archivo | Responsabilidad |
|---|---|---|---|
| GLBCONC | CLLE | qcllesrc/glbconc.clle | Entrada batch, validacion basica y llamada a GLBATCH. |
| GLBATCH | SQLRPGLE | qrpglesrc/glbatch.sqlrpgle | Orquestacion de ejecucion, estados, totales y flujo batch. |
| GLBDATA | SRVPGM | qrpglesrc/glbdata.sqlrpgle | Acceso DB2 for i mediante vistas normalizadas. |
| GLBRULES | SRVPGM | qrpglesrc/glbrules.rpgle | Calculo de saldos, tolerancia, estados e incidentes. |
| GLBJSON | SRVPGM | qrpglesrc/glbjson.sqlrpgle | Construccion y validacion basica del contrato JSON. |
| GLBIFS | SRVPGM | qrpglesrc/glbifs.rpgle | Validacion y publicacion atomica en IFS. |
| GLBLOG | SRVPGM | qrpglesrc/glblog.rpgle | Bitacora TXT normalizada de ejecucion. |
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
