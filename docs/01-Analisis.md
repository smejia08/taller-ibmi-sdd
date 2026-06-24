# 01 - Análisis funcional

## Objetivo

Construir una solución en IBM i para consultar y procesar información financiera de cuentas mayores desde `GLBLN`, calcular el balance por cuenta, clasificar su estado financiero y generar salidas estandarizadas en formato JSON publicadas en el IFS para consumo posterior por otros procesos o aplicaciones.

El proceso también debe permitir trazabilidad de ejecución mediante registro de inicio, fin, total de cuentas procesadas, errores detectados y resultado final.

## Alcance

Incluye:

- Lectura de saldos y datos base de cuentas mayores desde `GLBLN`.
- Consulta de cuentas mayores usando filtros configurables.
- Cálculo y exposición del balance por cada cuenta mayor procesada.
- Determinación del estado financiero por cuenta según reglas definidas para el taller.
- Consolidación de datos de identificación de cuenta, balance calculado, estado financiero y metadatos de ejecución.
- Generación de objetos JSON válidos con codificación UTF-8.
- Escritura de archivos JSON en una ruta IFS parametrizable.
- Registro de ejecución y trazabilidad del proceso.
- Manejo de errores de lectura, procesamiento y escritura en IFS.
- Controles de conciliación en la salida JSON, incluyendo saldos, partidas conciliatorias, diferencias, estados de conciliación, control de totales e incidentes.

No incluye:

- Interfaz gráfica web o móvil.
- Integración con sistemas externos en tiempo real.
- Modificación del modelo fuente de `GLBLN` fuera de ajustes necesarios para consulta.
- Diseño de código, arquitectura técnica o definición física final de tablas.

## Entradas

- Tabla principal `GLBLN` para saldos y datos base de cuentas mayores.
- Parámetros de ejecución sugeridos:
  - Banco.
  - Sucursal.
  - Moneda.
  - Rango de cuenta contable.
  - Fecha de proceso.
  - Ruta IFS de salida.
  - Modo de ejecución: prueba o productivo.
- Información de ejecución generada por el entorno IBM i:
  - Usuario.
  - Programa.
  - Librería.
  - Fecha y hora de inicio.
  - Fecha y hora de fin.
  - Identificador de ejecución.
- Tablas o fuentes mencionadas para conciliación y trazabilidad:
  - `GLMST`.
  - `TRANS`.
  - `TRDSC`.
  - `TTRAN`.
  - `CCDSC`.
- Reglas de negocio del taller para estado financiero, estado de conciliación, severidad, tolerancia y revisión.

Pendientes o dudas:

- Confirmar cuáles de las tablas complementarias son obligatorias para la primera versión y cuáles solo forman parte de la estructura objetivo de conciliación.
- Confirmar nombres reales de campos en `GLBLN` y demás tablas fuente.
- Confirmar la fuente oficial para descripciones de cuenta, naturaleza, nivel de cuenta y centro de costo.

## Salidas

- Archivo JSON válido con codificación UTF-8.
- Archivo publicado en una ruta IFS parametrizable.
- Nombre de archivo trazable mediante fecha, hora y/o identificador de corrida.
- Registro de ejecución con:
  - Inicio.
  - Fin.
  - Total de cuentas procesadas.
  - Errores detectados.
  - Resultado final de la ejecución.
- Estructura JSON objetivo con secciones funcionales:
  - `metadata`.
  - `ejecucion`.
  - `contexto`.
  - `cuentas`.
  - `controlTotales`.
  - `incidentes`.
- Por cada cuenta, la salida debe considerar:
  - Identificación de cuenta mayor.
  - Saldos de origen, calculados y conciliados.
  - Resumen de movimientos.
  - Partidas conciliatorias cuando exista diferencia.
  - Diferencias y evaluación de tolerancia.
  - Estado de conciliación.
  - Trazabilidad de registros fuente.

## Reglas de negocio

- El sistema debe consultar cuentas mayores desde `GLBLN` usando filtros configurables de banco, sucursal, moneda, rango de cuentas y fecha de proceso.
- El sistema debe calcular y exponer el balance por cada cuenta mayor procesada.
- El sistema debe asignar un estado financiero a cada cuenta con base en reglas de negocio definidas para el taller.
- El sistema debe consolidar en una estructura única los datos de identificación de cuenta, balance calculado, estado financiero y metadatos de ejecución.
- El sistema debe generar objetos JSON válidos con codificación UTF-8.
- El sistema debe escribir los JSON en una ruta IFS parametrizable.
- El nombre del archivo debe ser trazable por fecha, hora y/o identificador de corrida.
- El sistema debe registrar inicio, fin, total de cuentas procesadas, errores detectados y resultado final de cada ejecución.
- El sistema debe capturar errores de lectura, procesamiento y escritura en IFS.
- La estrategia ante errores debe ser continuar o abortar según severidad.
- El JSON debe incluir un objeto por cuenta contable dentro de `cuentas`.
- El JSON debe publicar saldos de origen, saldos calculados y saldo conciliado.
- El JSON debe incluir `partidasConciliatorias` cuando exista diferencia.
- El JSON debe marcar explícitamente `excedeTolerancia` y `requiereRevision`.
- El JSON debe incluir `controlTotales` para cuadratura global del archivo.
- El JSON debe registrar incidentes funcionales o técnicos para auditoría.
- Toda corrida debe quedar identificada con timestamp y estado final.
- Debe garantizarse integridad de la salida JSON y consistencia entre totales procesados y registros exportados.
- El proceso debe ejecutarse con perfiles autorizados para acceder a `GLBLN` y a rutas IFS de salida.

Reglas pendientes de definición:

- Catálogo final de estados financieros.
- Reglas exactas para asignar estado financiero por cuenta.
- Catálogo final de estados de conciliación.
- Reglas para determinar severidad.
- Umbral de tolerancia permitido.
- Reglas para definir cuándo una ejecución queda `FINALIZADO`, `PARCIAL` o `ERROR`.
- Estrategia exacta de manejo de errores por severidad.

## Entidades

- `GLBLN`: balances generales. Entidad principal para lectura de saldos y datos base de cuentas mayores. Clave reportada: banco, sucursal, moneda, cuenta contable.
- Cuenta mayor o cuenta contable: unidad funcional procesada por el reporte y la conciliación.
- Balance o saldo: información financiera calculada, fuente y conciliada por cuenta.
- Estado financiero: clasificación asignada a cada cuenta según reglas del taller.
- Ejecución: corrida del proceso con identificador, fechas, usuario, programa, librería y estado final.
- Contexto de proceso: banco, sucursal, moneda, periodo y rango de cuentas.
- Archivo JSON: salida estructurada publicada en IFS.
- Incidente: evento funcional o técnico registrado para auditoría.
- Partida conciliatoria: detalle asociado a diferencias de conciliación.
- Diferencia: comparación entre saldo fuente, saldo calculado y saldo conciliado.
- Control de totales: agregados globales para cuadratura del archivo.
- `GLMST`: maestro de cuentas contables. Mencionado como fuente preferente para descripción de cuenta, naturaleza y nivel.
- `TRANS`: histórico de transacciones. Mencionado para movimientos y partidas.
- `TRDSC`: descripciones adicionales a transacciones. Mencionado para observaciones y subclasificación.
- `TTRAN`: maestro de transacciones del día. Mencionado para movimientos del periodo y trazabilidad.
- `CCDSC`: maestro de centros de costos. Mencionado como posible fuente para centro de costo.
- IFS: medio de publicación de archivos JSON.

Pendientes o dudas:

- Validar si `GLMST`, `TRANS`, `TRDSC`, `TTRAN` y `CCDSC` son dependencias obligatorias del alcance inicial o solo fuentes previstas para la estructura robusta de conciliación.
- Confirmar si se requiere una entidad funcional separada para bitácora o si el registro de ejecución se resolverá con objetos TXT/logs existentes.

## Supuestos

- `GLBLN` contiene información consistente para cálculo de balance.
- Existen permisos en IBM i para lectura de base y escritura en IFS.
- El taller definirá el catálogo final de estados financieros y reglas exactas.
- La ruta IFS de salida será provista como parámetro o configuración.
- La fecha de proceso será provista como parámetro y podrá usarse como fecha de corte.
- Los datos de ejecución como usuario, programa, librería y timestamps podrán obtenerse desde el entorno de ejecución IBM i.
- La salida JSON será consumida posteriormente por otros procesos o aplicaciones, pero no se requiere integración en tiempo real.

## Ambigüedades

- No están definidas las reglas exactas para calcular el balance por cuenta.
- No está definido el catálogo de estados financieros.
- No están definidas las reglas exactas para asignar estado financiero.
- No está definido el catálogo final de estados de conciliación.
- No está definido el criterio exacto para clasificar partidas conciliatorias.
- No está definido el umbral de tolerancia ni si varía por banco, moneda, cuenta o ambiente.
- No está definida la estrategia exacta para continuar o abortar ante errores de lectura, procesamiento o escritura.
- No se especifica si debe generarse un JSON por ejecución, por cuenta, por banco, por sucursal, por moneda o por combinación de parámetros.
- No se especifica si el JSON debe incluir cuentas sin movimientos o con saldo cero.
- No se especifica la ventana operativa concreta para evaluar rendimiento.
- No se especifican volúmenes representativos de `GLBLN`.
- No se especifican nombres físicos definitivos de campos en las tablas fuente dentro del requerimiento funcional.
- La matriz JSON vs BD incluye orígenes complementarios, pero falta confirmar su disponibilidad y obligatoriedad.
- No está definido el formato exacto del log de ejecución.
- No está definido si los objetos TXT son parámetros, bitácoras, documentación operativa o todos los anteriores.

## Riesgos

- Calidad inconsistente de datos en `GLBLN`, con impacto en cálculo de balance y conciliación.
- Permisos insuficientes para lectura de base de datos o escritura en rutas IFS.
- Cambios en reglas financieras durante el desarrollo.
- Falta de definición del catálogo de estados financieros, lo que puede bloquear la clasificación de cuentas.
- Falta de definición del umbral de tolerancia, lo que puede afectar `excedeTolerancia`, `requiereRevision` y estado de conciliación.
- Ambigüedad sobre tablas complementarias puede producir diferencias entre la salida esperada y los datos disponibles.
- Inconsistencia entre totales procesados y registros exportados si no se define una regla clara de conteo.
- Riesgo de archivos JSON inválidos o incompletos ante errores de escritura o codificación.
- Riesgo operativo si no se define qué errores permiten continuar y cuáles obligan a abortar.
- Rendimiento no validado sobre volúmenes representativos de `GLBLN`.

## Preguntas abiertas

- ¿Cuál es la fórmula exacta para calcular el balance por cuenta?
- ¿Cuál es el catálogo final de estados financieros?
- ¿Qué reglas determinan el estado financiero de cada cuenta?
- ¿Cuál es el catálogo final de estados de conciliación?
- ¿Cuál es la tolerancia permitida para diferencias?
- ¿La tolerancia se define globalmente o por banco, moneda, cuenta, ambiente u otro criterio?
- ¿Qué severidades existen y qué efecto tiene cada una sobre la ejecución?
- ¿Qué errores deben abortar la ejecución y cuáles permiten continuar?
- ¿La salida debe ser un único JSON por corrida o varios archivos por agrupación funcional?
- ¿Cuál es la convención exacta de nombre del archivo JSON?
- ¿Cuál será la ruta IFS por ambiente?
- ¿Se deben exportar cuentas sin movimientos?
- ¿Se deben exportar cuentas con saldo cero?
- ¿Qué campos físicos de `GLBLN` corresponden a banco, sucursal, moneda, cuenta contable y saldos?
- ¿`GLMST`, `TRANS`, `TRDSC`, `TTRAN` y `CCDSC` estarán disponibles para el alcance del taller?
- ¿Cuál es la fuente oficial para descripción de cuenta, naturaleza, nivel y centro de costo?
- ¿Qué formato debe tener el log o bitácora de ejecución?
- ¿Cómo se validará formalmente que el JSON generado es válido y legible?
- ¿Qué volumen de datos se considera representativo para la prueba de rendimiento?
- ¿Qué ambiente debe informarse en `metadata.ambiente` para cada ejecución?
