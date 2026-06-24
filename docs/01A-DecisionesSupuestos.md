# 01A - Decisiones y supuestos

## DS-001

Pregunta abierta:

¿Cuál es la fórmula exacta para calcular el balance por cuenta?

Impacto en el diseño:

Sin una fórmula base no se puede diseñar el cálculo de saldos ni validar la consistencia entre el saldo fuente, el saldo calculado y el saldo conciliado.

Alternativas:

Opción A:
Usar `GLBLN.saldo_actual` como balance reportado por cuenta.

Ventajas:
Simplifica el alcance inicial y se apoya en la tabla principal indicada por el requerimiento.

Desventajas:
No valida el saldo contra movimientos y limita la conciliación.

Opción B:
Calcular el balance como saldo inicial más débitos menos créditos usando movimientos de `TRANS` y `TTRAN`.

Ventajas:
Permite conciliación y trazabilidad de diferencias.

Desventajas:
Requiere confirmar disponibilidad, completitud y ventana de movimientos.

Opción C:
Usar `GLBLN.saldo_actual` como saldo fuente y calcular un saldo comparativo con `TRANS` y `TTRAN` cuando estén disponibles.

Ventajas:
Permite avanzar con `GLBLN` y deja preparada la conciliación robusta.

Desventajas:
Mantiene dependencia pendiente sobre movimientos.

Recomendación:

Adoptar la opción C.

Supuesto adoptado:

Se asume que `GLBLN.saldo_actual` será el saldo fuente inicial y que `TRANS`/`TTRAN` se usarán para saldo calculado o conciliado cuando estén disponibles y confirmados.

Riesgo:

El riesgo permanece abierto hasta confirmar la regla contable exacta de cálculo y la cobertura de movimientos.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-002

Pregunta abierta:

¿Cuál es el catálogo final de estados financieros?

Impacto en el diseño:

El catálogo define valores permitidos, validaciones, reportes y criterios de agrupación en la salida JSON.

Alternativas:

Opción A:
Definir un catálogo mínimo temporal: `NORMAL`, `OBSERVADO`, `CRITICO`.

Ventajas:
Permite continuar el diseño de contratos y validaciones.

Desventajas:
Puede no coincidir con el lenguaje funcional final.

Opción B:
No definir catálogo temporal y dejar el campo como texto libre.

Ventajas:
Evita imponer valores no confirmados.

Desventajas:
Debilita validación y consistencia.

Recomendación:

Adoptar la opción A como catálogo temporal.

Supuesto adoptado:

Se asume un catálogo provisional de estados financieros `NORMAL`, `OBSERVADO` y `CRITICO`, sujeto a confirmación funcional.

Riesgo:

Puede requerirse ajuste si el taller define estados distintos o más granulares.

Nivel de confianza:

Bajo

Estado:

Supuesto

## DS-003

Pregunta abierta:

¿Qué reglas determinan el estado financiero de cada cuenta?

Impacto en el diseño:

La asignación de estado afecta la lógica de negocio, los incidentes, las alertas y el estado final de la ejecución.

Alternativas:

Opción A:
Asignar estado según diferencia neta y tolerancia.

Ventajas:
Es coherente con la estructura JSON de conciliación.

Desventajas:
No cubre reglas financieras adicionales no documentadas.

Opción B:
Asignar estado solo por existencia de errores o incidentes.

Ventajas:
Es simple y auditable.

Desventajas:
No representa necesariamente la salud financiera de la cuenta.

Opción C:
Combinar diferencia, tolerancia e incidentes de severidad.

Ventajas:
Integra conciliación y control operativo.

Desventajas:
Requiere confirmar umbrales y severidades.

Recomendación:

Adoptar la opción C.

Supuesto adoptado:

Se asume que el estado financiero se derivará de diferencia contra tolerancia e incidentes asociados a la cuenta.

Riesgo:

El riesgo permanece abierto porque las reglas financieras exactas no están confirmadas.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-004

Pregunta abierta:

¿Cuál es el catálogo final de estados de conciliación?

Impacto en el diseño:

El catálogo condiciona los valores de `estadoConciliacion.codigo`, los totales por estado y las reglas de revisión.

Alternativas:

Opción A:
Usar `CONCILIADA`, `PARCIAL`, `NO_CONCILIADA`.

Ventajas:
Coincide con ejemplos del requerimiento y cubre escenarios básicos.

Desventajas:
Puede faltar un estado para errores técnicos o datos incompletos.

Opción B:
Agregar `NO_PROCESADA` al catálogo.

Ventajas:
Permite diferenciar fallas de procesamiento de diferencias contables.

Desventajas:
Amplía el contrato JSON.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume catálogo provisional `CONCILIADA`, `PARCIAL`, `NO_CONCILIADA`, `NO_PROCESADA`.

Riesgo:

Puede requerirse homologación con catálogo funcional del banco o del taller.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-005

Pregunta abierta:

¿Cuál es el criterio exacto para clasificar partidas conciliatorias?

Impacto en el diseño:

Sin clasificación no se puede poblar de forma consistente `tipo`, `subtipo`, `motivoPrincipal` ni observaciones de conciliación.

Alternativas:

Opción A:
Clasificar por `TRANS.tipo_movimiento` y `TRDSC.tipo_descripcion`.

Ventajas:
Usa campos documentados en la estructura de BD.

Desventajas:
Depende de calidad y codificación de movimientos.

Opción B:
Clasificar solo por diferencia contable sin detallar partidas.

Ventajas:
Reduce dependencia de tablas complementarias.

Desventajas:
No cumple plenamente la estructura robusta propuesta.

Recomendación:

Adoptar la opción A.

Supuesto adoptado:

Se asume que `TRANS.tipo_movimiento`, `TTRAN.tipo_movimiento` y `TRDSC.tipo_descripcion` permitirán clasificar partidas conciliatorias.

Riesgo:

El riesgo permanece abierto si esos campos no contienen códigos suficientes o no están disponibles.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-006

Pregunta abierta:

¿Cuál es la tolerancia permitida para diferencias?

Impacto en el diseño:

La tolerancia afecta `excedeTolerancia`, `requiereRevision`, estado de conciliación, severidad e incidentes.

Alternativas:

Opción A:
Usar tolerancia fija de 0.00.

Ventajas:
Evita aceptar diferencias no autorizadas.

Desventajas:
Puede generar demasiadas revisiones por diferencias menores.

Opción B:
Usar tolerancia fija de 1.00 como aparece en el ejemplo JSON.

Ventajas:
Permite continuar con un umbral ilustrado en el requerimiento.

Desventajas:
El ejemplo no confirma política final.

Opción C:
Parametrizar la tolerancia.

Ventajas:
Permite ajustar por ambiente o necesidad funcional.

Desventajas:
Requiere parámetro adicional y validación.

Recomendación:

Adoptar la opción C con valor inicial sugerido 1.00 solo para pruebas.

Supuesto adoptado:

Se asume que la tolerancia será parametrizable y que 1.00 podrá usarse como valor provisional de taller.

Riesgo:

El riesgo permanece abierto hasta aprobación funcional del umbral.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-007

Pregunta abierta:

¿La tolerancia se define globalmente o por banco, moneda, cuenta, ambiente u otro criterio?

Impacto en el diseño:

Define el modelo de parametrización y la forma de aplicar reglas en cada cuenta.

Alternativas:

Opción A:
Tolerancia global por ejecución.

Ventajas:
Simple de implementar y probar.

Desventajas:
No distingue monedas, bancos o criticidad de cuentas.

Opción B:
Tolerancia por moneda.

Ventajas:
Considera diferencias por escala monetaria.

Desventajas:
Requiere catálogo adicional.

Opción C:
Tolerancia por banco, moneda y rango/cuenta.

Ventajas:
Mayor precisión funcional.

Desventajas:
Mayor complejidad y mayor dependencia de parametrización.

Recomendación:

Adoptar la opción A para la primera versión, dejando extensión a opción C.

Supuesto adoptado:

Se asume tolerancia global por ejecución en el alcance inicial.

Riesgo:

Podría ser insuficiente para producción si existen políticas diferenciadas.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-008

Pregunta abierta:

¿Qué severidades existen y qué efecto tiene cada una sobre la ejecución?

Impacto en el diseño:

Las severidades gobiernan incidentes, continuidad del proceso y estado final de ejecución.

Alternativas:

Opción A:
Usar `BAJA`, `MEDIA`, `ALTA`, `CRITICA`.

Ventajas:
Coincide con el ejemplo y cubre una escala operativa clara.

Desventajas:
Falta confirmar reglas de transición.

Opción B:
Usar solo `INFO`, `WARN`, `ERROR`.

Ventajas:
Más simple para logging técnico.

Desventajas:
Pierde granularidad funcional.

Recomendación:

Adoptar la opción A.

Supuesto adoptado:

Se asume catálogo de severidad `BAJA`, `MEDIA`, `ALTA`, `CRITICA`; `ALTA` y `CRITICA` afectan estado final de ejecución.

Riesgo:

Se deben confirmar reglas exactas para convertir severidad en `PARCIAL` o `ERROR`.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-009

Pregunta abierta:

¿Qué errores deben abortar la ejecución y cuáles permiten continuar?

Impacto en el diseño:

Define transaccionalidad, logging, reintentos y estado final de la corrida.

Alternativas:

Opción A:
Abortar ante cualquier error.

Ventajas:
Reduce riesgo de salida parcial.

Desventajas:
Puede impedir procesar cuentas válidas.

Opción B:
Continuar ante errores por cuenta y abortar ante errores globales.

Ventajas:
Balancea disponibilidad y control.

Desventajas:
Requiere clasificar errores.

Opción C:
Continuar siempre y registrar incidentes.

Ventajas:
Maximiza generación de salida.

Desventajas:
Puede producir archivos incompletos o engañosos.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume que errores de una cuenta generan incidente y continúan; errores de lectura global de `GLBLN`, parametrización inválida o escritura IFS no recuperable abortan.

Riesgo:

Debe validarse con operación si una salida parcial es aceptable.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-010

Pregunta abierta:

¿La salida debe ser un único JSON por corrida o varios archivos por agrupación funcional?

Impacto en el diseño:

Impacta tamaño de archivos, naming, consumo posterior, control de totales y reintentos.

Alternativas:

Opción A:
Un único JSON por ejecución.

Ventajas:
Simplifica control de totales y trazabilidad de corrida.

Desventajas:
Puede crecer demasiado con alto volumen.

Opción B:
Un JSON por banco/sucursal/moneda.

Ventajas:
Reduce tamaño por archivo y facilita reprocesos parciales.

Desventajas:
Complica consolidación global.

Recomendación:

Adoptar la opción A para el taller.

Supuesto adoptado:

Se asume un único archivo JSON por ejecución con `controlTotales` global.

Riesgo:

Si el volumen real es alto, puede requerirse particionamiento posterior.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-011

Pregunta abierta:

¿Cuál es la convención exacta de nombre del archivo JSON?

Impacto en el diseño:

El nombre debe garantizar trazabilidad, evitar colisiones y facilitar auditoría.

Alternativas:

Opción A:
Nombre por fecha y hora: `GLBLN_YYYYMMDD_HHMMSS.json`.

Ventajas:
Simple y trazable.

Desventajas:
Puede colisionar si hay ejecuciones simultáneas.

Opción B:
Nombre por proceso, fecha, hora e identificador de ejecución.

Ventajas:
Reduce colisiones y mejora auditoría.

Desventajas:
Nombre más largo.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume formato `CONCILIACION_GLBLN_YYYYMMDD_HHMMSS_IDEJECUCION.json`.

Riesgo:

Debe confirmarse compatibilidad con estándares internos de nombres IFS.

Nivel de confianza:

Alto

Estado:

Supuesto

## DS-012

Pregunta abierta:

¿Cuál será la ruta IFS por ambiente?

Impacto en el diseño:

La ruta define permisos, despliegue, parametrización y validaciones previas.

Alternativas:

Opción A:
Ruta fija por ambiente.

Ventajas:
Simple para operación.

Desventajas:
Requiere cambios si el ambiente cambia.

Opción B:
Ruta parametrizable por ejecución.

Ventajas:
Coincide con el requerimiento y facilita pruebas.

Desventajas:
Requiere validar permisos y existencia en cada corrida.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume que la ruta IFS será parámetro obligatorio de ejecución.

Riesgo:

Permanece abierto hasta confirmar rutas y permisos por ambiente.

Nivel de confianza:

Alto

Estado:

Supuesto

## DS-013

Pregunta abierta:

¿Se deben exportar cuentas sin movimientos?

Impacto en el diseño:

Define filtros de selección, totales y expectativas de conciliación.

Alternativas:

Opción A:
Exportar todas las cuentas de `GLBLN` que cumplan filtros, aunque no tengan movimientos.

Ventajas:
Representa el balance completo por cuenta mayor.

Desventajas:
Puede aumentar volumen de salida.

Opción B:
Exportar solo cuentas con movimientos en el periodo.

Ventajas:
Reduce volumen y foco en actividad.

Desventajas:
Puede omitir cuentas con saldo relevante.

Recomendación:

Adoptar la opción A.

Supuesto adoptado:

Se asume que toda cuenta en `GLBLN` que cumpla filtros debe exportarse, con resumen de movimientos en cero si aplica.

Riesgo:

Debe confirmarse si el consumidor espera únicamente cuentas con actividad.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-014

Pregunta abierta:

¿Se deben exportar cuentas con saldo cero?

Impacto en el diseño:

Afecta conteo de cuentas procesadas, tamaño del JSON y criterios de control.

Alternativas:

Opción A:
Incluir cuentas con saldo cero.

Ventajas:
Mantiene trazabilidad completa de cuentas filtradas.

Desventajas:
Aumenta registros sin impacto financiero.

Opción B:
Excluir cuentas con saldo cero y sin movimientos.

Ventajas:
Reduce volumen.

Desventajas:
Puede afectar auditoría y comparabilidad.

Recomendación:

Adoptar la opción A.

Supuesto adoptado:

Se asume inclusión de cuentas con saldo cero cuando cumplan filtros de ejecución.

Riesgo:

Si el volumen es alto, podría requerirse parámetro para excluirlas.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-015

Pregunta abierta:

¿Qué campos físicos de `GLBLN` corresponden a banco, sucursal, moneda, cuenta contable y saldos?

Impacto en el diseño:

Sin mapeo de campos no se pueden definir consultas, filtros ni estructura de salida.

Alternativas:

Opción A:
Usar los campos normalizados de `estructura_bd.md`: `codigo_banco`, `codigo_sucursal`, `codigo_moneda`, `cuenta_contable`, `saldo_actual`.

Ventajas:
Está documentado en la estructura disponible.

Desventajas:
Puede no coincidir con nombres físicos reales del IBM i.

Opción B:
Postergar diseño de consultas hasta obtener diccionario físico real.

Ventajas:
Evita construir sobre nombres incorrectos.

Desventajas:
Bloquea avance del diseño.

Recomendación:

Adoptar la opción A como mapeo lógico provisional.

Supuesto adoptado:

Se asume que esos campos son nombres lógicos de diseño y deberán mapearse a nombres físicos reales antes de construir código.

Riesgo:

Alto si la nomenclatura real difiere del documento normalizado.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-016

Pregunta abierta:

¿`GLMST`, `TRANS`, `TRDSC`, `TTRAN` y `CCDSC` estarán disponibles para el alcance del taller?

Impacto en el diseño:

Estas fuentes determinan si la salida puede incluir descripción, movimientos, partidas conciliatorias, observaciones y centro de costo.

Alternativas:

Opción A:
Alcance mínimo solo con `GLBLN`.

Ventajas:
Reduce dependencia y permite reporte básico.

Desventajas:
No cubre conciliación robusta completa.

Opción B:
Incluir `GLMST`, `TRANS`, `TRDSC` y `TTRAN`; dejar `CCDSC` opcional.

Ventajas:
Cubre la mayor parte del JSON robusto documentado.

Desventajas:
Requiere validar disponibilidad y calidad de datos.

Opción C:
Incluir todas las fuentes desde el inicio.

Ventajas:
Mayor completitud funcional.

Desventajas:
Mayor complejidad y riesgo de integración.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume que `GLMST`, `TRANS`, `TRDSC` y `TTRAN` son fuentes complementarias del alcance de conciliación; `CCDSC` queda como fuente opcional para centro de costo.

Riesgo:

Permanece abierto hasta confirmar acceso real a las tablas.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-017

Pregunta abierta:

¿Cuál es la fuente oficial para descripción de cuenta, naturaleza, nivel y centro de costo?

Impacto en el diseño:

Define joins, prioridad de datos y completitud de `cuentaMayor`.

Alternativas:

Opción A:
Usar `GLBLN` para todos los datos descriptivos.

Ventajas:
Evita joins.

Desventajas:
Puede duplicar o desactualizar información maestra.

Opción B:
Usar `GLMST` para descripción, naturaleza y nivel; `CCDSC` para centro de costo si existe.

Ventajas:
Respeta fuentes maestras documentadas.

Desventajas:
Requiere joins y manejo de datos faltantes.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume `GLMST` como fuente preferente para descripción, naturaleza y nivel; `CCDSC` será fuente de centro de costo cuando esté disponible.

Riesgo:

Si `GLMST` no contiene datos completos, se requerirá regla de fallback.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-018

Pregunta abierta:

¿Qué formato debe tener el log o bitácora de ejecución?

Impacto en el diseño:

El formato de bitácora afecta auditoría, soporte, operación y evidencia del taller.

Alternativas:

Opción A:
Bitácora en archivo TXT.

Ventajas:
Coincide con artefactos TXT mencionados y es simple.

Desventajas:
Menor capacidad de consulta estructurada.

Opción B:
Bitácora en JSON.

Ventajas:
Consistente con salida estructurada y fácil de procesar.

Desventajas:
Requiere definición adicional de contrato.

Opción C:
Bitácora en ambos formatos.

Ventajas:
Cubre operación humana y procesamiento automático.

Desventajas:
Duplica escritura y validación.

Recomendación:

Adoptar la opción A para el taller, con estructura de líneas normalizada.

Supuesto adoptado:

Se asume bitácora TXT con timestamp, id de ejecución, etapa, severidad, código y mensaje.

Riesgo:

Puede ser insuficiente si se exige auditoría consultable por base de datos.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-019

Pregunta abierta:

¿Cómo se validará formalmente que el JSON generado es válido y legible?

Impacto en el diseño:

Define controles de calidad, pruebas y criterios de aceptación.

Alternativas:

Opción A:
Validar solo generación sin error.

Ventajas:
Simple.

Desventajas:
No garantiza JSON válido.

Opción B:
Validar sintaxis JSON y codificación UTF-8.

Ventajas:
Cumple requerimiento mínimo de JSON válido y legible.

Desventajas:
No valida contrato completo.

Opción C:
Validar sintaxis, UTF-8 y esquema JSON esperado.

Ventajas:
Mayor confiabilidad y trazabilidad.

Desventajas:
Requiere definir esquema.

Recomendación:

Adoptar la opción C como objetivo, con opción B como mínimo obligatorio.

Supuesto adoptado:

Se asume que cada archivo generado debe validarse al menos por sintaxis JSON y UTF-8; el esquema será definido en fase posterior.

Riesgo:

Permanece abierto hasta disponer de contrato o esquema formal.

Nivel de confianza:

Alto

Estado:

Supuesto

## DS-020

Pregunta abierta:

¿Qué volumen de datos se considera representativo para la prueba de rendimiento?

Impacto en el diseño:

El volumen define estrategia de lectura, paginación, memoria, tamaño de JSON y ventana operativa.

Alternativas:

Opción A:
Usar muestra pequeña de taller.

Ventajas:
Facilita pruebas iniciales.

Desventajas:
No representa producción.

Opción B:
Usar volumen representativo definido por operación.

Ventajas:
Permite validar rendimiento real.

Desventajas:
Requiere datos y criterio externo.

Opción C:
Definir prueba incremental por rangos de cuentas.

Ventajas:
Permite observar escalamiento aunque falte volumen final.

Desventajas:
No reemplaza prueba productiva.

Recomendación:

Adoptar la opción C hasta que operación confirme el volumen.

Supuesto adoptado:

Se asume prueba incremental por rangos de cuentas y medición de tiempo, cuentas procesadas y tamaño de archivo.

Riesgo:

El riesgo de rendimiento permanece abierto hasta probar con volumen real.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-021

Pregunta abierta:

¿Qué ambiente debe informarse en `metadata.ambiente` para cada ejecución?

Impacto en el diseño:

El ambiente forma parte de trazabilidad y puede condicionar ruta IFS, permisos y consumo posterior.

Alternativas:

Opción A:
Informar ambiente fijo en el programa.

Ventajas:
Simple.

Desventajas:
No es portable entre ambientes.

Opción B:
Informar ambiente como parámetro de ejecución.

Ventajas:
Consistente con modo de ejecución y despliegues.

Desventajas:
Requiere validación de valores.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume que `metadata.ambiente` será parámetro obligatorio con valores controlados como `QA`, `UAT` o `PRD`.

Riesgo:

Debe confirmarse catálogo de ambientes usado por el taller u organización.

Nivel de confianza:

Alto

Estado:

Supuesto

## DS-022

Pregunta abierta:

¿Cómo se define cuándo una ejecución queda `FINALIZADO`, `PARCIAL` o `ERROR`?

Impacto en el diseño:

El estado final de ejecución afecta auditoría, consumo posterior y criterios de aceptación.

Alternativas:

Opción A:
`FINALIZADO` si termina el proceso, sin importar incidentes.

Ventajas:
Simple.

Desventajas:
Oculta errores funcionales.

Opción B:
`FINALIZADO` sin incidentes altos, `PARCIAL` con errores por cuenta, `ERROR` con falla global.

Ventajas:
Coherente con trazabilidad e incidentes.

Desventajas:
Requiere clasificar severidad.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume `FINALIZADO` cuando todas las cuentas procesan sin incidentes `ALTA` o `CRITICA`; `PARCIAL` cuando hay cuentas con errores o diferencias relevantes; `ERROR` cuando no se puede completar lectura global, procesamiento base o escritura IFS.

Riesgo:

Debe confirmarse si diferencias dentro de tolerancia cuentan como ejecución parcial o finalizada con advertencias.

Nivel de confianza:

Medio

Estado:

Supuesto

## DS-023

Pregunta abierta:

¿Se requiere una entidad funcional separada para bitácora o los objetos TXT serán suficientes?

Impacto en el diseño:

Define persistencia de auditoría, consultas históricas y responsabilidades de soporte.

Alternativas:

Opción A:
Usar solo TXT/log en IFS.

Ventajas:
Cumple el alcance de artefactos TXT y reduce dependencias.

Desventajas:
Menor capacidad de explotación histórica.

Opción B:
Crear entidad/tablas de bitácora.

Ventajas:
Mejora consulta, auditoría y control.

Desventajas:
Implica diseño de nuevas tablas no confirmado.

Recomendación:

Adoptar la opción A para no inventar tablas.

Supuesto adoptado:

Se asume que la bitácora se resolverá mediante objeto TXT/log parametrizado en IFS o entorno definido por el taller.

Riesgo:

Si auditoría exige consulta estructurada, hará falta una decisión posterior de persistencia.

Nivel de confianza:

Alto

Estado:

Supuesto

## DS-024

Pregunta abierta:

¿Los objetos TXT son parámetros, bitácoras, documentación operativa o todos los anteriores?

Impacto en el diseño:

Define uso funcional de artefactos TXT y separación entre configuración, evidencia y documentación.

Alternativas:

Opción A:
Usar TXT solo para bitácoras.

Ventajas:
Reduce ambigüedad operativa.

Desventajas:
No cubre parametrización mencionada en entregables.

Opción B:
Usar TXT para parámetros y bitácoras.

Ventajas:
Aprovecha artefactos esperados del taller.

Desventajas:
Requiere formato claro para evitar mezcla de responsabilidades.

Opción C:
Usar TXT para parámetros, bitácoras y documentación operativa.

Ventajas:
Cubre todos los usos mencionados.

Desventajas:
Puede generar desorden si no hay convención.

Recomendación:

Adoptar la opción B.

Supuesto adoptado:

Se asume que los TXT se usarán para parametrización simple y bitácoras, manteniendo documentación operativa en Markdown dentro de `docs`.

Riesgo:

Debe confirmarse estándar interno para ubicación y formato de objetos TXT.

Nivel de confianza:

Medio

Estado:

Supuesto
