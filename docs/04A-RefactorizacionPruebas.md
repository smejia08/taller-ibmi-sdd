# 04A - Refactorizacion de programas de prueba

## Resumen

La suite conserva los 24 casos existentes, sus datos, validaciones,
resultados esperados y orden de ejecucion. La implementacion cambia de
24 programas independientes a seis programas de servicio de pruebas,
uno por componente. `RUNTST` sigue siendo el punto de entrada y ahora
invoca procedimientos exportados.

## Mapa antes/despues

| Antes | Despues | Procedimientos |
|---|---|---|
| `T_RULES01` a `T_RULES12` | `TSTRULES` `*SRVPGM` | `TestRules01` a `TestRules12` |
| `TI_DATA01` a `TI_DATA05` | `TSTDATA` `*SRVPGM` | `TestData01` a `TestData05` |
| `TI_JSON01` a `TI_JSON02` | `TSTJSON` `*SRVPGM` | `TestJson01` a `TestJson02` |
| `TI_IFS01` a `TI_IFS03` | `TSTIFS` `*SRVPGM` | `TestIfs01` a `TestIfs03` |
| `TI_LOG01` | `TSTLOG` `*SRVPGM` | `TestLog01` |
| `TI_BATCH01` | `TSTBATCH` `*SRVPGM` | `TestBatch01` |
| `RUNTST` CLLE | `RUNTST` RPGLE | Invoca los 24 procedimientos |

## Artefactos

- Modulos: `tstrules.rpgle`, `tstdata.sqlrpgle`, `tstjson.sqlrpgle`,
  `tstifs.sqlrpgle`, `tstlog.sqlrpgle`, `tstbatch.rpgle`.
- Binder sources: `TSTRULES.bnd`, `TSTDATA.bnd`, `TSTJSON.bnd`,
  `TSTIFS.bnd`, `TSTLOG.bnd`, `TSTBATCH.bnd`.
- Prototipos: `t_tests_pr.rpgleinc`.
- Orquestador: `runtst.rpgle`.
- Compilacion: `bldtst.clle`.

## Justificacion tecnica

La agrupacion reduce objetos compilados, centraliza las dependencias y
mantiene una interfaz publica estable mediante binder source. Cada caso
sigue aislado en un procedimiento sin parametros y conserva el nombre
original en su evidencia `PASS`/`FAIL`. Los servicios funcionales no se
modifican y las pruebas continuan enlazandose contra sus contratos
existentes.

El orden de `BLDTST` es:

1. Crear cada modulo de pruebas.
2. Crear su programa de servicio con binder source.
3. Compilar `RUNTST` enlazado a los seis programas de servicio.
4. Compilar `TSTSUITE`, que sigue sometiendo `RUNTST`.
