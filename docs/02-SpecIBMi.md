# 02 - Especificacion IBM i

## Proposito

Definir la especificacion tecnica IBM i para procesar balances de cuentas
mayores desde `GLBLN`, calcular saldos de conciliacion, clasificar el estado
financiero y generar una salida JSON valida en IFS con trazabilidad completa.

La solucion se limita a IBM i y usa SQLRPGLE, RPGLE Free, CLLE, DB2 for i,
programas de servicio, tablas SQL y vistas SQL.

## Alcance funcional

Incluye:

- Lectura de `GLBLN` con filtros por banco, sucursal, moneda, cuenta y fecha.
- Enriquecimiento opcional con `GLMST`, `TRANS`, `TTRAN`, `TRDSC` y `CCDSC`.
- Calculo de saldo fuente, saldo calculado, saldo conciliado y diferencia.
- Asignacion de estado financiero y estado de conciliacion por cuenta.
- Registro de incidentes tecnicos y funcionales.
- Generacion de un archivo JSON UTF-8 por ejecucion.
- Escritura del JSON en una ruta IFS parametrizable.
- Bitacora TXT de ejecucion con inicio, fin, conteos y estado final.

No incluye:

- Interfaces web o moviles.
- Integracion en linea con sistemas externos.
- Cambios fisicos sobre tablas fuente existentes.
- Creacion de objetos DDS, PF o LF.

## Parametros de ejecucion

| Parametro | Obligatorio | Descripcion |
|---|---:|---|
| `codigo_banco` | Si | Banco a procesar. |
| `codigo_sucursal` | No | Sucursal a procesar; vacio significa todas. |
| `codigo_moneda` | No | Moneda a procesar; vacio significa todas. |
| `cuenta_desde` | No | Limite inferior de cuenta contable. |
| `cuenta_hasta` | No | Limite superior de cuenta contable. |
| `fecha_proceso` | Si | Fecha de corte de la ejecucion. |
| `ruta_ifs` | Si | Directorio IFS donde se publicara el JSON. |
| `modo_ejecucion` | Si | `PRUEBA` o `PRODUCTIVO`. |
| `ambiente` | Si | Ambiente informado en `metadata.ambiente`. |
| `tolerancia` | Si | Tolerancia global para diferencias. |

Los parametros deben validarse antes de leer datos fuente. Una falla de
parametrizacion invalida aborta la ejecucion.

## Fuentes de datos

| Fuente | Uso |
|---|---|
| `GLBLN` | Fuente principal de balances generales. |
| `GLMST` | Descripcion, naturaleza y nivel de cuenta. |
| `TRANS` | Movimientos historicos para saldo calculado y partidas. |
| `TTRAN` | Movimientos del dia para saldo calculado y trazabilidad. |
| `TRDSC` | Descripciones adicionales de movimientos. |
| `CCDSC` | Centro de costo, si esta disponible. |

## Mapeo logico minimo

| Concepto | Campo logico |
|---|---|
| Banco | `codigo_banco` |
| Sucursal | `codigo_sucursal` |
| Moneda | `codigo_moneda` |
| Cuenta contable | `cuenta_contable` |
| Saldo fuente | `saldo_actual` |
| Fecha de proceso | `fecha_proceso_sistema` |
| Movimiento debito/credito | `debito_credito` |
| Monto de movimiento | `monto` |
| Tipo de movimiento | `tipo_movimiento` |

Los nombres son logicos de diseno y deben homologarse con el diccionario fisico
real antes de construir el codigo.

## Reglas de procesamiento

1. Seleccionar desde `GLBLN` las cuentas que cumplan los filtros de ejecucion.
2. Obtener datos maestros desde `GLMST` cuando existan.
3. Obtener movimientos desde `TRANS` y `TTRAN` cuando esten disponibles.
4. Usar `GLBLN.saldo_actual` como saldo fuente.
5. Calcular saldo comparativo con saldo inicial, debitos y creditos cuando
   existan movimientos confirmados.
6. Determinar diferencia neta entre saldo fuente, calculado y conciliado.
7. Marcar `excedeTolerancia` cuando la diferencia absoluta supere tolerancia.
8. Marcar `requiereRevision` si excede tolerancia o existe incidente relevante.
9. Asignar estado de conciliacion por cuenta.
10. Asignar estado financiero por cuenta.
11. Agregar incidentes funcionales y tecnicos al JSON.
12. Calcular `controlTotales` desde las cuentas exportadas.
13. Validar sintaxis JSON y codificacion UTF-8 antes de finalizar.

## Catalogos provisionales

### Estado financiero

| Codigo | Criterio inicial |
|---|---|
| `NORMAL` | Sin diferencias fuera de tolerancia ni incidentes relevantes. |
| `OBSERVADO` | Diferencia fuera de tolerancia o incidente de severidad media/alta. |
| `CRITICO` | Incidente critico o cuenta no procesada por falla funcional. |

### Estado de conciliacion

| Codigo | Criterio inicial |
|---|---|
| `CONCILIADA` | Diferencia dentro de tolerancia. |
| `PARCIAL` | Diferencia fuera de tolerancia con datos suficientes. |
| `NO_CONCILIADA` | Diferencia fuera de tolerancia sin partida explicativa. |
| `NO_PROCESADA` | Cuenta omitida por error propio de la cuenta. |

### Severidad

| Codigo | Efecto |
|---|---|
| `BAJA` | Informativa, no afecta estado final. |
| `MEDIA` | Genera observacion y puede requerir revision. |
| `ALTA` | Puede dejar la ejecucion en `PARCIAL`. |
| `CRITICA` | Deja la ejecucion en `ERROR` si impide completar el flujo. |

## Contrato JSON

El archivo debe contener las secciones:

- `metadata`
- `ejecucion`
- `contexto`
- `cuentas`
- `controlTotales`
- `incidentes`

Estructura logica minima:

```json
{
  "metadata": {
    "nombreProceso": "CONCILIACION_GLBLN",
    "versionContrato": "1.0",
    "ambiente": "QA",
    "fechaGeneracion": "2026-06-24T10:00:00"
  },
  "ejecucion": {
    "idEjecucion": "20260624100000",
    "usuario": "USRIBM",
    "programa": "GLBATCH",
    "libreria": "TALLER",
    "inicio": "2026-06-24T10:00:00",
    "fin": "2026-06-24T10:01:30",
    "estado": "FINALIZADO"
  },
  "contexto": {
    "codigoBanco": "001",
    "codigoSucursal": "001",
    "codigoMoneda": "COP",
    "cuentaDesde": "100000",
    "cuentaHasta": "199999",
    "fechaProceso": "2026-06-24",
    "modoEjecucion": "PRUEBA",
    "tolerancia": 1.00
  },
  "cuentas": [],
  "controlTotales": {},
  "incidentes": []
}
```

Cada elemento de `cuentas` debe incluir:

- Identificacion: banco, sucursal, moneda y cuenta.
- Datos maestros: descripcion, naturaleza, nivel y centro de costo si aplica.
- Saldos: fuente, calculado, conciliado y diferencia neta.
- Resumen de movimientos: debitos, creditos y cantidad de movimientos.
- Partidas conciliatorias si existe diferencia.
- Estado financiero.
- Estado de conciliacion.
- Marcas `excedeTolerancia` y `requiereRevision`.
- Trazabilidad de registros fuente.

## Control de totales

`controlTotales` debe incluir al menos:

- `totalCuentasLeidas`
- `totalCuentasExportadas`
- `totalCuentasConDiferencia`
- `totalCuentasConRevision`
- `sumatoriaSaldoFuente`
- `sumatoriaSaldoCalculado`
- `sumatoriaSaldoConciliado`
- `sumatoriaDiferenciaNeta`
- `totalIncidentes`

La `sumatoriaDiferenciaNeta` debe coincidir con la suma de diferencias por
cuenta exportada.

## Nombre de archivos

Formato de JSON:

`CONCILIACION_GLBLN_YYYYMMDD_HHMMSS_IDEJECUCION.json`

Formato de bitacora TXT:

`CONCILIACION_GLBLN_YYYYMMDD_HHMMSS_IDEJECUCION.log`

Ambos archivos se escriben en la ruta IFS recibida por parametro.

## Bitacora TXT

Cada linea debe tener:

`timestamp|idEjecucion|etapa|severidad|codigo|mensaje`

Etapas sugeridas:

- `INICIO`
- `VALIDACION_PARAMETROS`
- `LECTURA_GLBLN`
- `PROCESO_CUENTA`
- `GENERACION_JSON`
- `ESCRITURA_IFS`
- `VALIDACION_JSON`
- `FIN`

## Manejo de errores

Abortan la ejecucion:

- Parametros obligatorios invalidos.
- Error global de lectura de `GLBLN`.
- Error no recuperable al crear o escribir el archivo IFS.
- JSON final invalido o no legible como UTF-8.

Permiten continuar:

- Cuenta individual con datos incompletos.
- Movimiento asociado no disponible para una cuenta.
- Falla de enriquecimiento en `GLMST`, `TRDSC` o `CCDSC`.
- Diferencia fuera de tolerancia.

Los errores por cuenta deben generar incidente y marcar la cuenta como
`NO_PROCESADA`, `OBSERVADO` o `CRITICO`, segun corresponda.

## Estado final de ejecucion

| Estado | Criterio |
|---|---|
| `FINALIZADO` | Todas las cuentas procesan sin incidentes altos o criticos. |
| `PARCIAL` | Existen errores por cuenta o diferencias relevantes. |
| `ERROR` | Falla global de lectura, procesamiento base o escritura IFS. |

## Reglas IBM i y DB2 for i

- Crear nuevas estructuras solo como tablas SQL o vistas SQL.
- No crear PF, LF ni artefactos DDS.
- Los scripts SQL deben incluir metadata, `FOR COLUMN`, `PRIMARY KEY`,
  `RCDFMT`, comentarios y labels completos cuando creen tablas nuevas.
- Mantener lineas de SQL de hasta 80 caracteres.
- Usar nombres de objeto cortos de sistema cuando aplique.
- Encapsular acceso a datos, negocio, JSON, IFS y logging en componentes
  separados.
- Evitar logica monolitica en el programa principal.

## Supuestos documentados

| ID | Supuesto |
|---|---|
| DS-001 | `GLBLN.saldo_actual` es saldo fuente inicial; `TRANS` y `TTRAN` se usan para saldo calculado cuando esten disponibles. |
| DS-002 | Catalogo provisional de estados financieros: `NORMAL`, `OBSERVADO`, `CRITICO`. |
| DS-003 | El estado financiero deriva de diferencia, tolerancia e incidentes asociados. |
| DS-004 | Catalogo provisional de conciliacion: `CONCILIADA`, `PARCIAL`, `NO_CONCILIADA`, `NO_PROCESADA`. |
| DS-005 | `TRANS.tipo_movimiento`, `TTRAN.tipo_movimiento` y `TRDSC.tipo_descripcion` clasifican partidas. |
| DS-006 | La tolerancia es parametrizable y 1.00 puede usarse como valor de taller. |
| DS-007 | La primera version usa tolerancia global por ejecucion. |
| DS-008 | Severidades provisionales: `BAJA`, `MEDIA`, `ALTA`, `CRITICA`; altas y criticas afectan el estado final. |
| DS-009 | Errores por cuenta continuan; errores globales de datos, parametros o IFS abortan. |
| DS-010 | Se genera un unico archivo JSON por ejecucion. |
| DS-011 | Nombre: `CONCILIACION_GLBLN_YYYYMMDD_HHMMSS_IDEJECUCION.json`. |
| DS-012 | La ruta IFS es parametro obligatorio. |
| DS-013 | Se exportan cuentas sin movimientos si cumplen filtros. |
| DS-014 | Se incluyen cuentas con saldo cero si cumplen filtros. |
| DS-015 | Los campos de `estructura_bd.md` son nombres logicos sujetos a homologacion fisica. |
| DS-016 | `GLMST`, `TRANS`, `TRDSC` y `TTRAN` son complementarias; `CCDSC` es opcional. |
| DS-017 | `GLMST` es fuente preferente de descripcion, naturaleza y nivel; `CCDSC` de centro de costo si existe. |
| DS-018 | La bitacora del taller es TXT con linea normalizada. |
| DS-019 | El JSON debe validarse como minimo por sintaxis y UTF-8; esquema queda para fase posterior. |
| DS-020 | La prueba de rendimiento sera incremental por rangos de cuentas. |
| DS-021 | `metadata.ambiente` es parametro obligatorio con valores controlados. |
| DS-022 | `FINALIZADO`, `PARCIAL` y `ERROR` se determinan por incidentes y tipo de falla. |

## Criterios de aceptacion

- El flujo batch tiene id de ejecucion trazable de inicio a fin.
- El JSON es valido, UTF-8 y contiene todas las secciones minimas.
- Los totales globales cuadran contra el detalle de cuentas.
- Las diferencias fuera de tolerancia quedan marcadas para revision.
- Incidentes `ALTA` o `CRITICA` impactan el estado de ejecucion.
- La arquitectura evidencia separacion entre datos, negocio, JSON, IFS y log.
- No se propone tecnologia prohibida ni objetos PF/LF.
