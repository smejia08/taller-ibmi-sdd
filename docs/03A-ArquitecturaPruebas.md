# 03A - Arquitectura de Pruebas IBM i

> Documento complementario a `03-ArquitecturaIBMi.md`.
> No modifica la arquitectura funcional aprobada.
> Define la estrategia completa de testabilidad para el proceso de
> conciliacion GLBLN dentro del ambiente PUB400.

---

## 1. Objetivos de pruebas

| # | Objetivo |
|---|---|
| OBJ-01 | Verificar que cada programa de servicio cumple su contrato de interfaz de forma aislada. |
| OBJ-02 | Garantizar que los calculos de saldo, diferencia y tolerancia son correctos para los escenarios minimos definidos en la arquitectura. |
| OBJ-03 | Confirmar que el JSON generado es valido, UTF-8, contiene todas las secciones obligatorias y que `controlTotales` cuadra contra el detalle de cuentas. |
| OBJ-04 | Validar que la escritura IFS produce el archivo esperado en la ruta de prueba y que el nombre final solo aparece si la escritura temporal fue exitosa. |
| OBJ-05 | Asegurar que la bitacora TXT registra inicio, fin, etapas clave y errores en el formato normalizado `timestamp|idEjecucion|etapa|severidad|codigo|mensaje`. |
| OBJ-06 | Verificar el comportamiento ante datos incompletos o erroneos: maestro faltante, descripcion faltante, movimiento con signo invalido, ruta IFS inexistente. |
| OBJ-07 | Demostrar que incidentes `ALTA` o `CRITICA` afectan el estado final del proceso. |
| OBJ-08 | Evidenciar que el flujo batch completo (`GLBCONC` a `GLBATCH` a servicios a IFS) puede ejecutarse de punta a punta con mock data en PUB400. |

---

## 2. Estrategia de mock data

### 2.1 Principios

- Todos los datos de prueba viven en una libreria exclusiva `GLBTSTLIB`
  separada de produccion y desarrollo.
- Los scripts de carga de mock data son idempotentes: borran e insertan
  en cada ejecucion.
- Las claves entre tablas son consistentes: los registros de `GLBLN`,
  `GLMST`, `TRANS`, `TTRAN`, `TRDSC` y `CCDSC` referencian los mismos
  codigos de banco, sucursal, moneda y cuenta.
- Cada escenario de prueba tiene una cuenta exclusiva para no mezclar
  resultados.
- Los montos estan elegidos para que el cuadre sea verificable a mano
  (numeros redondos con diferencias controladas).

### 2.2 Cuentas de prueba por escenario

| Cuenta | Escenario | Tablas involucradas |
|---|---|---|
| `100000` | Cuenta conciliada | `GLBLN`, `GLMST`, `TRANS`, `TTRAN`, `TRDSC`, `CCDSC` |
| `110000` | Fuera de tolerancia | `GLBLN`, `GLMST`, `TRANS`, `TTRAN` |
| `120000` | Sin movimientos | `GLBLN`, `GLMST` |
| `130000` | Saldo cero | `GLBLN`, `GLMST` |
| `140000` | Maestro faltante | `GLBLN` (sin `GLMST`) |
| `150000` | Descripcion faltante | `GLBLN`, `GLMST`, `TRANS` (sin `TRDSC`) |
| `160000` | Centro costo opcional ausente | `GLBLN`, `GLMST`, `TRANS` (sin `CCDSC`) |
| `170000` | Error por cuenta (signo invalido) | `GLBLN`, `GLMST`, `TRANS` (movimiento con debitoCredito='X') |

### 2.3 Reglas de coherencia del mock data

- Cuenta `100000`: saldoFuente = 1000.00. Movimientos D=700.00, C=700.00.
  saldoCalculado esperado = 1000.00. diferenciaNeta = 0.00.
- Cuenta `110000`: saldoFuente = 500.00. Movimientos D=300.00, C=0.00.
  saldoCalculado esperado = 800.00. diferenciaNeta = -300.00
  (excede tolerancia 10.00).
- Cuenta `120000`: saldoFuente = 250.00. Sin movimientos.
  saldoCalculado = 250.00.
- Cuenta `130000`: saldoFuente = 0.00. Sin movimientos.
  saldoCalculado = 0.00.
- Cuenta `140000`: saldoFuente = 800.00. Sin match GLMST.
  centroCosto = nulo.
- Cuenta `150000`: movimiento en TRANS sin descripcion en TRDSC.
  Monto = 200.00.
- Cuenta `160000`: movimientos normales, sin match CCDSC.
  centroCosto = nulo.
- Cuenta `170000`: un movimiento con debitoCredito = 'X'. Provoca RUL001.

### 2.4 Rutas IFS de prueba

| Ruta | Uso |
|---|---|
| `/GLBTST/output/` | Directorio de salida JSON en pruebas. |
| `/GLBTST/logs/` | Directorio de bitacoras TXT en pruebas. |
| `/GLBTST/invalid/` | Ruta con permisos insuficientes para prueba de error IFS. |

---

## 3. Programas de pruebas unitarias

Los programas de prueba unitaria se almacenan en `GLBTSTLIB/QRPGLESRC`
con prefijo `T_` seguido del nombre del programa bajo prueba.

| Programa de prueba | Programa bajo prueba | Funcion probada |
|---|---|---|
| `T_RULES01` | `GLBRULES` | `calcSaldoCuenta` — cuenta conciliada |
| `T_RULES02` | `GLBRULES` | `calcSaldoCuenta` — fuera de tolerancia |
| `T_RULES03` | `GLBRULES` | `calcSaldoCuenta` — sin movimientos |
| `T_RULES04` | `GLBRULES` | `calcSaldoCuenta` — movimiento con signo invalido |
| `T_RULES05` | `GLBRULES` | `evalTolerancia` — tolerancia cero |
| `T_RULES06` | `GLBRULES` | `evalTolerancia` — tolerancia negativa |
| `T_RULES07` | `GLBRULES` | `clasificaEstado` — estado NORMAL/CONCILIADA |
| `T_RULES08` | `GLBRULES` | `clasificaEstado` — estado OBSERVADO/PARCIAL |
| `T_RULES09` | `GLBRULES` | `clasificaEstado` — estado CRITICO/NO_PROCESADA |
| `T_RULES10` | `GLBRULES` | `buildIncidentesCuenta` — incidente DIF001 |
| `T_RULES11` | `GLBRULES` | `dispatchReglas` — version 1.0 valida |
| `T_RULES12` | `GLBRULES` | `dispatchReglas` — version no soportada |

---

## 4. Programas de pruebas de integracion

Los programas de prueba de integracion se almacenan en `GLBTSTLIB/QRPGLESRC`
con prefijo `TI_`.

| Programa de prueba | Programas involucrados | Escenario |
|---|---|---|
| `TI_DATA01` | `GLBDATA` + DB2 | Lectura cursor `GLBLN` con filtros banco/sucursal/moneda |
| `TI_DATA02` | `GLBDATA` + DB2 | Enriquecimiento con `GLMST` — match existente |
| `TI_DATA03` | `GLBDATA` + DB2 | Enriquecimiento con `GLMST` — maestro faltante |
| `TI_DATA04` | `GLBDATA` + DB2 | Carga de movimientos `TRANS` y `TTRAN` normalizados |
| `TI_DATA05` | `GLBDATA` + DB2 | Carga de descripciones `TRDSC` — descripcion faltante |
| `TI_JSON01` | `GLBJSON` + DB2 | Generacion JSON un ciclo completo — cuenta conciliada |
| `TI_JSON02` | `GLBJSON` + DB2 | Generacion JSON — multiples cuentas con incidentes |
| `TI_IFS01`  | `GLBIFS` + IFS  | Escritura archivo JSON en ruta valida `/GLBTST/output/` |
| `TI_IFS02`  | `GLBIFS` + IFS  | Publicacion archivo temporal al nombre final |
| `TI_IFS03`  | `GLBIFS` + IFS  | Error en ruta invalida — archivo temporal no publicado |
| `TI_LOG01`  | `GLBLOG` + IFS  | Apertura, escritura de eventos y cierre de bitacora |
| `TI_BATCH01`| `GLBATCH` + todos | Flujo completo con mock data — todos los escenarios |

---

## 5. Validaciones de contrato JSON

Cada validacion de contrato se ejecuta sobre el JSON producido por
`GLBJSON` antes de publicar. Las validaciones usan las funciones
`validateJsonSyntax`, `validateUtf8` y `validateControlTotales`
definidas en la arquitectura funcional.

| ID | Validacion | Mecanismo IBM i |
|---|---|---|
| VJ-01 | JSON sintacticamente valido y parseable | `validateJsonSyntax` via `JSON_TABLE` Db2 |
| VJ-02 | Codificacion UTF-8 sin caracteres invalidos | `validateUtf8` + `IFS_WRITE_UTF8` |
| VJ-03 | Seccion `metadata` presente con campos obligatorios | `JSON_TABLE` sobre seccion `metadata` |
| VJ-04 | Seccion `ejecucion` con `idEjecucion`, `estado`, `inicio`, `fin` | `JSON_TABLE` sobre seccion `ejecucion` |
| VJ-05 | Seccion `cuentas` es arreglo con al menos un elemento | `JSON_TABLE` + COUNT |
| VJ-06 | Cada elemento de `cuentas` tiene campos obligatorios | `JSON_TABLE` sobre arreglo `cuentas` |
| VJ-07 | Seccion `controlTotales` presente y cuadre automatico | `validateControlTotales` |
| VJ-08 | `totalCuentasLeidas` = COUNT filas `GLBLN` filtradas | Comparacion acumulados vs. JSON |
| VJ-09 | `sumatoriaSaldoFuente` = SUM saldoFuente exportadas | Comparacion acumulados vs. JSON |
| VJ-10 | `sumatoriaDiferenciaNeta` = SUM diferenciaNeta exportadas | Comparacion acumulados vs. JSON |
| VJ-11 | `totalIncidentes` = COUNT incidentes severidad >= MEDIA | Comparacion acumulados vs. JSON |
| VJ-12 | Seccion `incidentes` presente cuando existen incidentes | `JSON_TABLE` condicional |
| VJ-13 | Incidentes ALTA o CRITICA hacen estado final != EXITOSO | Validacion en `determinaEstadoFinal` |

---

## 6. Datos minimos por escenario

### Escenario E-01: Cuenta conciliada

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=100000, banco=001, saldo=1000.00 |
| `GLMST` | 1 | cuenta=100000, descripcion='CAJA PRINCIPAL' |
| `TRANS` | 1 | cuenta=100000, tipo=D, monto=700.00 |
| `TTRAN` | 1 | cuenta=100000, tipo=C, monto=700.00 |
| `TRDSC` | 2 | descripcion para cada movimiento |
| `CCDSC` | 1 | centro costo valido |

### Escenario E-02: Fuera de tolerancia

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=110000, saldo=500.00 |
| `GLMST` | 1 | cuenta=110000 |
| `TRANS` | 1 | cuenta=110000, tipo=D, monto=300.00 |
| `TTRAN` | 0 | Sin registros para cuenta 110000 |
| `TRDSC` | 1 | descripcion para movimiento TRANS |

### Escenario E-03: Sin movimientos

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=120000, saldo=250.00 |
| `GLMST` | 1 | cuenta=120000 |
| `TRANS` | 0 | Sin registros |
| `TTRAN` | 0 | Sin registros |

### Escenario E-04: Saldo cero

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=130000, saldo=0.00 |
| `GLMST` | 1 | cuenta=130000 |
| `TRANS` | 0 | Sin registros |
| `TTRAN` | 0 | Sin registros |

### Escenario E-05: Maestro faltante

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=140000, saldo=800.00 |
| `GLMST` | 0 | Sin fila para cuenta 140000 |

### Escenario E-06: Descripcion faltante

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=150000 |
| `GLMST` | 1 | cuenta=150000 |
| `TRANS` | 1 | cuenta=150000, tipo=D, monto=200.00 |
| `TRDSC` | 0 | Sin descripcion para el movimiento |

### Escenario E-07: Centro costo opcional ausente

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=160000 |
| `GLMST` | 1 | cuenta=160000 |
| `TRANS` | 1 | cuenta=160000, tipo=D, monto=100.00 |
| `CCDSC` | 0 | Sin match de centro costo |

### Escenario E-08: Error por cuenta (signo invalido)

| Tabla | Filas minimas | Campos clave |
|---|---|---|
| `GLBLN` | 1 | cuenta=170000 |
| `GLMST` | 1 | cuenta=170000 |
| `TRANS` | 1 | cuenta=170000, debitoCredito='X', monto=50.00 |

### Escenario E-09: Error global (ruta IFS invalida)

| Campo | Valor |
|---|---|
| `RunParms.rutaIfs` | `/GLBTST/invalid/` (sin permiso *W para perfil de prueba) |
| `GLBLN` | >= 1 fila con cualquier cuenta valida |

---

## 7. Evidencias esperadas

### 7.1 Tipos de evidencia

| Tipo | Descripcion | Formato |
|---|---|---|
| EV-JOB | Joblog capturado de la ejecucion batch | TXT / spool |
| EV-JSON | Archivo JSON generado en `/GLBTST/output/` | `.json` |
| EV-LOG | Bitacora TXT generada en `/GLBTST/logs/` | `.log` |
| EV-SQL | Resultado de sentencia SQL de validacion en ACS Run SQL Scripts | Captura pantalla o CSV |
| EV-ASSERT | Comparacion valor esperado vs. obtenido dentro del programa de prueba | DSPLY o JOBLOG |

### 7.2 Evidencias por escenario

| Escenario | Evidencia minima requerida |
|---|---|
| E-01 Conciliada | EV-JSON con `estadoConciliacion=CONCILIADA`, EV-LOG con FIN, EV-SQL cuadre controlTotales |
| E-02 Fuera tolerancia | EV-JSON con `estadoConciliacion=PARCIAL`, `excedeTolerancia=true`, incidente DIF001 |
| E-03 Sin movimientos | EV-JSON cuenta exportada, `cantidadMovimientos=0`, `diferenciaNeta=0.00` |
| E-04 Saldo cero | EV-JSON cuenta exportada con `saldoFuente=0.00` en `sumatoriaSaldoFuente` |
| E-05 Maestro faltante | EV-JSON campo `centroCosto` nulo, incidente no fatal, cuenta exportada |
| E-06 Descripcion faltante | EV-JSON movimiento exportado con `textoDescripcion` vacio o con observacion |
| E-07 Centro costo ausente | EV-JSON cuenta exportada con `centroCosto` nulo, proceso continua |
| E-08 Error por cuenta | EV-JSON `estadoConciliacion=NO_PROCESADA`, codigo `RUL001`, proceso continua para otras cuentas |
| E-09 Error global | EV-JOB estado `ERROR`, EV-LOG con registro del error antes de FIN, sin JSON publicado |

---

## 8. Estructura de librerias y objetos IBM i para pruebas

```
GLBTSTLIB/
|
+-- QRPGLESRC/
|   +-- T_RULES01.rpgle     (prueba unitaria calcSaldoCuenta conciliada)
|   +-- T_RULES02.rpgle     (prueba unitaria calcSaldoCuenta fuera tolerancia)
|   +-- T_RULES03.rpgle     (prueba unitaria calcSaldoCuenta sin movimientos)
|   +-- T_RULES04.rpgle     (prueba unitaria calcSaldoCuenta signo invalido)
|   +-- T_RULES05.rpgle     (prueba unitaria evalTolerancia cero)
|   +-- T_RULES06.rpgle     (prueba unitaria evalTolerancia negativa)
|   +-- T_RULES07.rpgle     (prueba unitaria clasificaEstado NORMAL)
|   +-- T_RULES08.rpgle     (prueba unitaria clasificaEstado OBSERVADO)
|   +-- T_RULES09.rpgle     (prueba unitaria clasificaEstado CRITICO)
|   +-- T_RULES10.rpgle     (prueba unitaria buildIncidentesCuenta DIF001)
|   +-- T_RULES11.rpgle     (prueba unitaria dispatchReglas version 1.0)
|   +-- T_RULES12.rpgle     (prueba unitaria dispatchReglas version no soportada)
|   +-- TI_DATA01.sqlrpgle  (integracion lectura cursor GLBLN)
|   +-- TI_DATA02.sqlrpgle  (integracion enriquecimiento GLMST match)
|   +-- TI_DATA03.sqlrpgle  (integracion enriquecimiento GLMST faltante)
|   +-- TI_DATA04.sqlrpgle  (integracion carga movimientos TRANS+TTRAN)
|   +-- TI_DATA05.sqlrpgle  (integracion descripciones TRDSC faltante)
|   +-- TI_JSON01.sqlrpgle  (integracion buildJson cuenta conciliada)
|   +-- TI_JSON02.sqlrpgle  (integracion buildJson multiples cuentas)
|   +-- TI_IFS01.sqlrpgle   (integracion escritura JSON ruta valida)
|   +-- TI_IFS02.sqlrpgle   (integracion publicacion temporal a final)
|   +-- TI_IFS03.sqlrpgle   (integracion error ruta invalida)
|   +-- TI_LOG01.sqlrpgle   (integracion openLog writeEvent closeLog)
|   +-- TI_BATCH01.sqlrpgle (integracion flujo completo)
|
+-- QSQLSRC/
|   +-- MOCK_INS.sql        (insercion idempotente de mock data)
|   +-- MOCK_DEL.sql        (borrado de mock data)
|   +-- ASSERT_JSON.sql     (validaciones JSON con JSON_TABLE)
|   +-- ASSERT_TOTALES.sql  (cuadre automatico controlTotales)
|
+-- QCLLESRC/
    +-- RUNTST.clle         (orquestador suite completa de pruebas)
    +-- BLDTST.clle         (compilacion ordenada de programas de prueba)
    +-- TSTSUITE.clle       (submit de jobs de prueba individuales)
```

### 8.1 Objetos *PGM compilados para pruebas

| Objeto | Tipo IBM i | Descripcion |
|---|---|---|
| `T_RULES01` a `T_RULES12` | `*PGM` | Pruebas unitarias de `GLBRULES` |
| `TI_DATA01` a `TI_DATA05` | `*PGM` | Pruebas integracion `GLBDATA` |
| `TI_JSON01` a `TI_JSON02` | `*PGM` | Pruebas integracion `GLBJSON` |
| `TI_IFS01` a `TI_IFS03`  | `*PGM` | Pruebas integracion `GLBIFS` |
| `TI_LOG01`                | `*PGM` | Prueba integracion `GLBLOG` |
| `TI_BATCH01`              | `*PGM` | Prueba flujo completo |
| `RUNTST`                  | `*PGM` | Orquestador de suite de pruebas |

### 8.2 Lista de librerias por perfil de ejecucion de pruebas

```
LIBL de prueba:  GLBTSTLIB  GLBDEVLIB  QTEMP  QSYS  QSYSBAS
```

`GLBTSTLIB` debe preceder a `GLBDEVLIB` para que los objetos de prueba
tengan precedencia sobre los de desarrollo.

### 8.3 Rutas IFS necesarias

| Ruta IFS | Creacion | Observacion |
|---|---|---|
| `/GLBTST/` | Manual antes de pruebas | Directorio raiz de pruebas |
| `/GLBTST/output/` | `MOCK_INS.sql` o manual | Salida JSON de prueba |
| `/GLBTST/logs/` | `MOCK_INS.sql` o manual | Bitacoras de prueba |
| `/GLBTST/invalid/` | Manual sin permiso `*W` para perfil de prueba | Simula ruta sin permisos |

---

## 9. Automatizacion posible dentro de PUB400

### 9.1 Restricciones del ambiente PUB400

| Restriccion | Impacto |
|---|---|
| Sin acceso a scheduler nativo `QPROCML` | No es posible calendarizar jobs automaticamente desde IBM i. |
| Sin `SBMJOB` a colas protegidas de produccion | Los jobs de prueba deben someterse a colas de desarrollo. |
| Sin acceso SSH externo para CI/CD | No es posible invocar desde GitHub Actions directamente a PUB400. |
| Permisos IFS limitados al perfil del usuario | Las rutas de prueba deben crearse bajo el directorio del usuario o areas acordadas. |

### 9.2 Automatizacion factible en PUB400

#### A. Script SQL de carga y validacion (ACS Run SQL Scripts)

El archivo `MOCK_INS.sql` borra e inserta el mock data completo. Puede
ejecutarse desde IBM ACS Run SQL Scripts o desde una sesion SQL
interactiva en PUB400.

Secuencia de ejecucion manual reproducible:

```
1. Ejecutar MOCK_DEL.sql      Limpia datos de ejecucion anterior.
2. Ejecutar MOCK_INS.sql      Carga mock data completo.
3. Ejecutar BLDTST            Compila programas de prueba.
4. CALL GLBTSTLIB/RUNTST      Ejecuta suite y escribe resultado en /GLBTST/logs/.
5. Ejecutar ASSERT_JSON.sql   Valida JSON generado con JSON_TABLE en ACS.
6. Ejecutar ASSERT_TOTALES.sql Valida cuadre de controlTotales.
```

#### B. Programa orquestador RUNTST (CLLE)

`RUNTST` es un programa CL que:

- Llama a `TI_BATCH01` con `RunParms` apuntando a `GLBTSTLIB` y
  `/GLBTST/output/`.
- Llama a cada programa `T_RULES*` de forma secuencial.
- Registra PASS / FAIL en `/GLBTST/logs/RUNTST_YYYYMMDD.log`.
- Retorna `*ON` si todos los programas terminaron sin estado `ERROR`.

No requiere scheduler. Puede invocarse con `CALL GLBTSTLIB/RUNTST`
desde una sesion 5250 o desde ACS Run SQL via sentencia `CALL`.

#### C. Validacion JSON desde ACS Run SQL Scripts

```sql
-- Lectura de prueba de controlTotales desde JSON en IFS
SELECT jt.*
  FROM JSON_TABLE(
         GET_CLOB_FROM_FILE(
           PATH_NAME => '/GLBTST/output/'
             CONCAT 'CONCILIACION_GLBLN_TST.json'
         ),
         'strict $.controlTotales'
         COLUMNS(
           totalCuentasLeidas   INTEGER      PATH '$.totalCuentasLeidas',
           sumatoriaSaldoFuente DECIMAL(18,2) PATH '$.sumatoriaSaldoFuente',
           sumatoriaDiferencia  DECIMAL(18,2) PATH '$.sumatoriaDiferenciaNeta'
         )
       ) AS jt;
```

Este script puede guardarse como `ASSERT_TOTALES.sql` y ejecutarse
desde ACS sin necesidad de compilar programas adicionales.

#### D. Script de compilacion de pruebas (BLDTST.clle)

`BLDTST` compila todos los programas de prueba en el orden correcto:

```
1. CRTSRVPGM GLBRULES  (desde GLBDEVLIB, referenciado por pruebas)
2. CRTBNDRPG T_RULES01 ... T_RULES12
3. CRTBNDRPG TI_DATA01 ... TI_DATA05
4. CRTBNDRPG TI_JSON01 TI_JSON02
5. CRTBNDRPG TI_IFS01 TI_IFS02 TI_IFS03
6. CRTBNDRPG TI_LOG01
7. CRTBNDRPG TI_BATCH01
8. CRTPGM    RUNTST
```

#### E. Control de resultados esperados

Cada programa de prueba unitaria usa `DSPLY` para mostrar PASS / FAIL
en el JOBLOG. `RUNTST` captura el `OpStatus.ok` de cada llamada y
acumula fallos. Al terminar emite un resumen al JOBLOG.

El JOBLOG puede consultarse desde ACS Work with Job Logs y exportarse
como evidencia EV-JOB.

### 9.3 Lo que NO es automatizable en PUB400 en el alcance del taller

| Aspecto | Razon |
|---|---|
| Ejecucion automatica ante push GitHub | PUB400 no tiene webhook ni agente CI accesible desde Internet. |
| Reporte HTML de cobertura | No existe framework xUnit nativo disponible en PUB400 publico. |
| Rollback automatico de mock data si falla una prueba | Requiere control transaccional coordinado; factible en produccion, fuera del alcance del taller. |

---

## Catalogo de pruebas

### Pruebas unitarias — GLBRULES

---

#### UT-01

| Campo | Valor |
|---|---|
| **ID** | UT-01 |
| **Objetivo** | Verificar que `calcSaldoCuenta` calcula correctamente saldo, debitos, creditos y diferencia neta para una cuenta conciliada. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `calcSaldoCuenta` |
| **Datos de entrada** | CuentaFuente: cuenta=100000, saldoFuente=1000.00. Movimientos: D=700.00, C=700.00. movCount=2. |
| **Resultado esperado** | totalDebitos=700.00, totalCreditos=700.00, saldoCalculado=1000.00, diferenciaNeta=0.00. OpStatus.ok=*ON, codigo='OK'. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS y valores calculados. |

---

#### UT-02

| Campo | Valor |
|---|---|
| **ID** | UT-02 |
| **Objetivo** | Verificar que `calcSaldoCuenta` detecta movimiento con debito/credito invalido y retorna OpStatus con severidad ALTA y codigo RUL001. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `calcSaldoCuenta` |
| **Datos de entrada** | CuentaFuente: cuenta=170000, saldoFuente=100.00. Movimiento con debitoCredito='X', monto=50.00. |
| **Resultado esperado** | OpStatus.ok=*OFF, severidad='ALTA', codigo='RUL001'. incidenteCodigo='RUL001'. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS con codigo RUL001. |

---

#### UT-03

| Campo | Valor |
|---|---|
| **ID** | UT-03 |
| **Objetivo** | Verificar que `calcSaldoCuenta` maneja correctamente una cuenta sin movimientos. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `calcSaldoCuenta` |
| **Datos de entrada** | CuentaFuente: cuenta=120000, saldoFuente=250.00. movCount=0. |
| **Resultado esperado** | totalDebitos=0.00, totalCreditos=0.00, saldoCalculado=250.00, diferenciaNeta=0.00. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS. |

---

#### UT-04

| Campo | Valor |
|---|---|
| **ID** | UT-04 |
| **Objetivo** | Verificar que `calcSaldoCuenta` calcula diferencia neta correcta cuando los movimientos no coinciden con el saldo fuente. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `calcSaldoCuenta` |
| **Datos de entrada** | CuentaFuente: cuenta=110000, saldoFuente=500.00. Movimientos: D=300.00. movCount=1. |
| **Resultado esperado** | saldoCalculado=800.00, diferenciaNeta=-300.00. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando diferenciaNeta=-300.00. |

---

#### UT-05

| Campo | Valor |
|---|---|
| **ID** | UT-05 |
| **Objetivo** | Verificar que `evalTolerancia` marca excedeTolerancia=*ON cuando la diferencia supera la tolerancia. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `evalTolerancia` |
| **Datos de entrada** | CuentaResultado con diferenciaNeta=-300.00. tolerancia=10.00. |
| **Resultado esperado** | excedeTolerancia=*ON, requiereRevision=*ON. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS. |

---

#### UT-06

| Campo | Valor |
|---|---|
| **ID** | UT-06 |
| **Objetivo** | Verificar que `evalTolerancia` retorna error CRITICA y codigo RUL010 cuando la tolerancia es negativa. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `evalTolerancia` |
| **Datos de entrada** | tolerancia=-5.00. CuentaResultado con diferenciaNeta=0.00. |
| **Resultado esperado** | OpStatus.ok=*OFF, severidad='CRITICA', codigo='RUL010'. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS con RUL010. |

---

#### UT-07

| Campo | Valor |
|---|---|
| **ID** | UT-07 |
| **Objetivo** | Verificar que `clasificaEstado` asigna estadoFinanciero=NORMAL y estadoConciliacion=CONCILIADA cuando no hay incidentes ni exceso de tolerancia. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `clasificaEstado` |
| **Datos de entrada** | CuentaResultado: excedeTolerancia=*OFF, incidenteSeveridad=''. cantidadMovimientos=2. |
| **Resultado esperado** | estadoFinanciero='NORMAL', estadoConciliacion='CONCILIADA'. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS. |

---

#### UT-08

| Campo | Valor |
|---|---|
| **ID** | UT-08 |
| **Objetivo** | Verificar que `clasificaEstado` asigna estadoFinanciero=OBSERVADO y estadoConciliacion=PARCIAL cuando excede tolerancia y hay movimientos. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `clasificaEstado` |
| **Datos de entrada** | CuentaResultado: excedeTolerancia=*ON, incidenteSeveridad='MEDIA'. cantidadMovimientos=1. |
| **Resultado esperado** | estadoFinanciero='OBSERVADO', estadoConciliacion='PARCIAL'. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS. |

---

#### UT-09

| Campo | Valor |
|---|---|
| **ID** | UT-09 |
| **Objetivo** | Verificar que `clasificaEstado` asigna estadoFinanciero=CRITICO y estadoConciliacion=NO_PROCESADA cuando incidenteSeveridad='CRITICA'. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `clasificaEstado` |
| **Datos de entrada** | CuentaResultado: incidenteSeveridad='CRITICA'. |
| **Resultado esperado** | estadoFinanciero='CRITICO', estadoConciliacion='NO_PROCESADA'. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS. |

---

#### UT-10

| Campo | Valor |
|---|---|
| **ID** | UT-10 |
| **Objetivo** | Verificar que `buildIncidentesCuenta` genera incidente DIF001 cuando excede tolerancia y no habia incidente previo. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `buildIncidentesCuenta` |
| **Datos de entrada** | CuentaResultado: excedeTolerancia=*ON, incidenteCodigo=''. |
| **Resultado esperado** | incidenteCodigo='DIF001', incidenteSeveridad='MEDIA', requiereRevision=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS con DIF001. |

---

#### UT-11

| Campo | Valor |
|---|---|
| **ID** | UT-11 |
| **Objetivo** | Verificar que `dispatchReglas` ejecuta correctamente la version 1.0 del contrato de reglas sin error. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `dispatchReglas` |
| **Datos de entrada** | version='1.0'. CuentaResultado valido con excedeTolerancia=*OFF. |
| **Resultado esperado** | OpStatus.ok=*ON. Estado clasificado correctamente. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS. |

---

#### UT-12

| Campo | Valor |
|---|---|
| **ID** | UT-12 |
| **Objetivo** | Verificar que `dispatchReglas` retorna error CRITICA y codigo RUL020 para una version no soportada. |
| **Programa bajo prueba** | `GLBRULES` — procedimiento `dispatchReglas` |
| **Datos de entrada** | version='2.0'. CuentaResultado valido. |
| **Resultado esperado** | OpStatus.ok=*OFF, severidad='CRITICA', codigo='RUL020'. |
| **Evidencia esperada** | EV-ASSERT: DSPLY en JOBLOG mostrando PASS con RUL020. |

---

### Pruebas de integracion — GLBDATA

---

#### IT-01

| Campo | Valor |
|---|---|
| **ID** | IT-01 |
| **Objetivo** | Verificar que `openCuentaCursor`, `fetchCuenta` y `closeCuentaCursor` devuelven los 8 registros mock de `GLBLN` y cierran sin error. |
| **Programa bajo prueba** | `GLBDATA` — procedimientos `openCuentaCursor`, `fetchCuenta`, `closeCuentaCursor` |
| **Datos de entrada** | RunParms: banco=001, moneda=COP. Mock data: 8 cuentas en GLBLN. |
| **Resultado esperado** | Fetch devuelve exactamente 8 filas. eof=*ON al agotar el cursor. OpStatus.ok=*ON en cierre. |
| **Evidencia esperada** | EV-ASSERT: contador de filas = 8 en JOBLOG mostrando PASS. |

---

#### IT-02

| Campo | Valor |
|---|---|
| **ID** | IT-02 |
| **Objetivo** | Verificar que `loadMovimientos` une correctamente movimientos de `TRANS` y `TTRAN` para cuenta=100000. |
| **Programa bajo prueba** | `GLBDATA` — procedimiento `loadMovimientos` |
| **Datos de entrada** | CuentaFuente: cuenta=100000. Mock data: 1 fila TRANS D=700.00, 1 fila TTRAN C=700.00. |
| **Resultado esperado** | Lista Movimiento con 2 elementos. D=700.00, C=700.00. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY cantidadMovimientos=2 en JOBLOG. |

---

#### IT-03

| Campo | Valor |
|---|---|
| **ID** | IT-03 |
| **Objetivo** | Verificar que cuando `GLMST` no tiene fila para la cuenta, `fetchCuenta` retorna descripcionCuenta vacio y OpStatus no fatal. |
| **Programa bajo prueba** | `GLBDATA` — procedimiento `fetchCuenta` con enriquecimiento `GLMST` |
| **Datos de entrada** | CuentaFuente: cuenta=140000. Sin fila en GLMST. |
| **Resultado esperado** | descripcionCuenta='' o nulo. OpStatus.ok=*ON. Proceso continua. |
| **Evidencia esperada** | EV-ASSERT: DSPLY descripcionCuenta vacio, estado OK. |

---

#### IT-04

| Campo | Valor |
|---|---|
| **ID** | IT-04 |
| **Objetivo** | Verificar que `loadDescripciones` maneja ausencia de `TRDSC` sin abortar y marca textoDescripcion vacio. |
| **Programa bajo prueba** | `GLBDATA` — procedimiento `loadDescripciones` |
| **Datos de entrada** | Lista Movimiento de cuenta=150000. Sin fila TRDSC para ese movimiento. |
| **Resultado esperado** | textoDescripcion='' o indicador de no disponible. OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-ASSERT: DSPLY textoDescripcion vacio, estado OK. |

---

### Pruebas de integracion — GLBJSON

---

#### IT-05

| Campo | Valor |
|---|---|
| **ID** | IT-05 |
| **Objetivo** | Verificar que `buildJson` genera JSON valido, UTF-8, con secciones obligatorias para la cuenta conciliada. |
| **Programa bajo prueba** | `GLBJSON` — procedimiento `buildJson` |
| **Datos de entrada** | RunParms validos. CuentaResultado de cuenta=100000 conciliada. ControlTotales con 1 cuenta. |
| **Resultado esperado** | JsonDoc CLOB no nulo. Secciones `metadata`, `ejecucion`, `cuentas`, `controlTotales` presentes. `validateJsonSyntax` retorna *ON. |
| **Evidencia esperada** | EV-SQL: `JSON_TABLE` sobre CLOB devuelve 1 fila. EV-ASSERT: DSPLY PASS. |

---

#### IT-06

| Campo | Valor |
|---|---|
| **ID** | IT-06 |
| **Objetivo** | Verificar que `validateControlTotales` detecta inconsistencia entre `controlTotales` declarado y la suma real de cuentas. |
| **Programa bajo prueba** | `GLBJSON` — procedimiento `validateControlTotales` |
| **Datos de entrada** | JsonDoc con `totalCuentasLeidas=5` pero solo 4 cuentas en el arreglo `cuentas`. |
| **Resultado esperado** | OpStatus.ok=*OFF. Mensaje indicando inconsistencia. |
| **Evidencia esperada** | EV-ASSERT: DSPLY PASS con OpStatus.ok=*OFF y mensaje de error de cuadre. |

---

### Pruebas de integracion — GLBIFS

---

#### IT-07

| Campo | Valor |
|---|---|
| **ID** | IT-07 |
| **Objetivo** | Verificar que `validatePath`, `writeTempFile` y `publishFile` escriben el JSON en `/GLBTST/output/` con el nombre final correcto. |
| **Programa bajo prueba** | `GLBIFS` — procedimientos `validatePath`, `writeTempFile`, `publishFile` |
| **Datos de entrada** | ruta='/GLBTST/output/'. JsonDoc CLOB valido. Nombre temporal y final generados por orquestador. |
| **Resultado esperado** | Archivo final existe en `/GLBTST/output/`. Temporal eliminado. OpStatus.ok=*ON en cada paso. |
| **Evidencia esperada** | EV-SQL: `QSYS2.IFS_OBJECT_STATISTICS` muestra el archivo publicado. |

---

#### IT-08

| Campo | Valor |
|---|---|
| **ID** | IT-08 |
| **Objetivo** | Verificar que cuando `validatePath` detecta ruta sin permisos, retorna OpStatus de error y el orquestador aborta sin publicar ningun archivo. |
| **Programa bajo prueba** | `GLBIFS` — procedimiento `validatePath` |
| **Datos de entrada** | ruta='/GLBTST/invalid/' (sin permiso *W para perfil de prueba). |
| **Resultado esperado** | OpStatus.ok=*OFF. Sin archivo JSON en ruta invalida. Estado final del batch = ERROR. |
| **Evidencia esperada** | EV-JOB: JOBLOG con codigo de error. EV-SQL: No existe archivo en ruta invalida. |

---

### Prueba de integracion — GLBLOG

---

#### IT-09

| Campo | Valor |
|---|---|
| **ID** | IT-09 |
| **Objetivo** | Verificar que `openLog`, `writeEvent` y `closeLog` generan un archivo TXT en `/GLBTST/logs/` con el formato normalizado correcto. |
| **Programa bajo prueba** | `GLBLOG` — procedimientos `openLog`, `writeEvent`, `closeLog` |
| **Datos de entrada** | ruta='/GLBTST/logs/'. idEjecucion='TST001'. Eventos: INICIO, ETAPA_DATOS, FIN. |
| **Resultado esperado** | Archivo `.log` existe. Cada linea tiene formato `timestamp\|idEjecucion\|etapa\|severidad\|codigo\|mensaje`. Exactamente 3 lineas. |
| **Evidencia esperada** | EV-LOG: Contenido verificado con `GET_CLOB_FROM_FILE` en ACS. |

---

### Prueba de integracion — Flujo completo

---

#### IT-10

| Campo | Valor |
|---|---|
| **ID** | IT-10 |
| **Objetivo** | Verificar que el flujo completo `GLBCONC` a `GLBATCH` a servicios a IFS ejecuta de punta a punta con mock data, genera JSON y bitacora, y retorna estado EXITOSO. |
| **Programa bajo prueba** | `GLBCONC`, `GLBATCH`, `GLBDATA`, `GLBRULES`, `GLBJSON`, `GLBIFS`, `GLBLOG` |
| **Datos de entrada** | RunParms: banco=001, moneda=COP, fechaProceso=CURDATE, rutaIfs='/GLBTST/output/', tolerancia=10.00, modoEjecucion=BATCH, ambiente=TST. Mock data completo de 8 cuentas. |
| **Resultado esperado** | JSON publicado en `/GLBTST/output/`. Bitacora en `/GLBTST/logs/`. Estado final EXITOSO. ControlTotales cuadra para 8 cuentas. Cuenta 170000 en estado NO_PROCESADA. |
| **Evidencia esperada** | EV-JSON, EV-LOG, EV-SQL cuadre controlTotales, EV-JOB con estado EXITOSO. |

---

#### IT-11

| Campo | Valor |
|---|---|
| **ID** | IT-11 |
| **Objetivo** | Verificar que el flujo completo termina con estado ERROR y no publica JSON cuando la ruta IFS es invalida. |
| **Programa bajo prueba** | `GLBCONC`, `GLBATCH`, `GLBIFS` |
| **Datos de entrada** | RunParms identicos a IT-10 pero rutaIfs='/GLBTST/invalid/'. Mock data completo. |
| **Resultado esperado** | Sin archivo JSON en `/GLBTST/invalid/`. Estado final ERROR. Bitacora registra el error con severidad CRITICA antes de FIN. |
| **Evidencia esperada** | EV-JOB: estado ERROR. EV-LOG: linea de error IFS. EV-SQL: no existe archivo en ruta invalida. |

---

### Pruebas de contrato JSON

---

#### CT-01

| Campo | Valor |
|---|---|
| **ID** | CT-01 |
| **Objetivo** | Confirmar que el JSON del flujo completo es sintacticamente valido y parseable por Db2 for i. |
| **Programa bajo prueba** | `GLBJSON` — procedimiento `validateJsonSyntax` |
| **Datos de entrada** | JsonDoc generado en IT-10. |
| **Resultado esperado** | `JSON_TABLE` no lanza excepcion. `validateJsonSyntax` retorna OpStatus.ok=*ON. |
| **Evidencia esperada** | EV-SQL: `SELECT COUNT(*) FROM JSON_TABLE(...)` devuelve 8 (una por cuenta). |

---

#### CT-02

| Campo | Valor |
|---|---|
| **ID** | CT-02 |
| **Objetivo** | Confirmar que el archivo JSON en IFS esta codificado en UTF-8 sin caracteres invalidos. |
| **Programa bajo prueba** | `GLBJSON` — procedimiento `validateUtf8` |
| **Datos de entrada** | Archivo JSON en `/GLBTST/output/` generado en IT-10. |
| **Resultado esperado** | `validateUtf8` retorna OpStatus.ok=*ON. `GET_CLOB_FROM_FILE` lo lee sin error. |
| **Evidencia esperada** | EV-SQL: Lectura exitosa. EV-ASSERT: DSPLY PASS. |

---

#### CT-03

| Campo | Valor |
|---|---|
| **ID** | CT-03 |
| **Objetivo** | Confirmar que `controlTotales` en el JSON cuadra contra la suma real de las cuentas exportadas. |
| **Programa bajo prueba** | `GLBJSON` — procedimiento `validateControlTotales` |
| **Datos de entrada** | JsonDoc generado en IT-10 con 8 cuentas procesadas. |
| **Resultado esperado** | `totalCuentasLeidas`=8. `totalCuentasConDiferencia`=1 (cuenta 110000). `sumatoriaSaldoFuente` coincide con la suma de los 8 saldos mock. `validateControlTotales` retorna *ON. |
| **Evidencia esperada** | EV-SQL: `ASSERT_TOTALES.sql` devuelve todas las comparaciones = 0. |

---

#### CT-04

| Campo | Valor |
|---|---|
| **ID** | CT-04 |
| **Objetivo** | Confirmar que incidentes con severidad ALTA o CRITICA hacen que el estado final del JSON sea distinto de EXITOSO. |
| **Programa bajo prueba** | `GLBATCH` — procedimiento `determinaEstadoFinal`, `GLBJSON` — seccion `ejecucion` |
| **Datos de entrada** | Mock data con cuenta 170000 (incidente RUL001 severidad ALTA). |
| **Resultado esperado** | Seccion `ejecucion.estado` del JSON distinta de 'EXITOSO'. Seccion `incidentes` contiene elemento con severidad='ALTA'. |
| **Evidencia esperada** | EV-SQL: `JSON_TABLE` sobre `$.ejecucion.estado` devuelve valor distinto a 'EXITOSO'. |

---

> **Nota de uso:** Este documento debe actualizarse cada vez que se
> agregue una nueva regla de negocio a `GLBRULES`, un nuevo procedimiento
> exportado a cualquier servicio, o un nuevo escenario de mock data.
> La arquitectura funcional en `03-ArquitecturaIBMi.md` permanece
> inalterada.
