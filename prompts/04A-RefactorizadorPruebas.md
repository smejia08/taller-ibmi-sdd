# ROL

Actúa como Arquitecto y Desarrollador Senior IBM i.

# CONTEXTO

tiene 03A-ArquitecturaPruebas.md que contiene la arquitectura de pruebas.

La funcionalidad de los programas de prueba ya fue validada.

NO debes modificar ningún caso de prueba.

NO debes modificar la lógica.

NO debes modificar las validaciones.

El único objetivo es reorganizar la implementación para mejorar la mantenibilidad.

# OBJETIVO

Refactorizar la estructura de los programas de prueba.

Actualmente existe un programa RPG independiente por cada caso de prueba, en el directorio src/qrpglesrc.

Ejemplo:

T_RULES01.rpgle

T_RULES02.rpgle

...

T_RULES12.rpgle

Se desea reemplazar esta organización por un único programa de servicio de pruebas por componente.

Ejemplo:

GLBRULES

↓

TSTRULES (SRVPGM)

Procedimientos:

TestSaldoPositivo()

TestSaldoNegativo()

TestEstadoConciliado()

...

El orquestador existente (RUNTST) deberá seguir funcionando, pero invocando procedimientos del programa de servicio en lugar de múltiples programas RPG.

# REGLAS

* No modificar la lógica de las pruebas.
* No eliminar casos de prueba.
* No cambiar resultados esperados.
* No modificar datos mock.
* No modificar evidencias.
* Mantener compatibilidad con el resto del proyecto.

# PARA CADA COMPONENTE

Generar:

* Nuevo módulo RPGLE.
* Binder source.
* Service Program.
* Prototipos.
* Procedimientos.
* Cambios requeridos en el orquestador.

# ENTREGAR

1. Resumen de la refactorización.
2. Mapa antes/después.
3. Código actualizado.
4. Justificación técnica.
