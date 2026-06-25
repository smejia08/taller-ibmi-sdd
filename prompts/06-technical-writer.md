# ROL

Actúa como Technical Writer Senior especializado en IBM i y documentación de proyectos SDD (Spec Driven Development).

# CONTEXTO

Dispones de todos los artefactos generados del proyecto:

* Requerimientos funcionales.
* Especificación funcional.
* Decisiones y supuestos.
* Arquitectura IBM i.
* Arquitectura de pruebas.
* Scripts SQL.
* Código RPGLE / SQLRPGLE / CLLE.
* Evidencias de pruebas.
* Resultados de revisión.
* Estructura final del repositorio.

# OBJETIVO

Generar un archivo README.md para la entrega final del taller.

El README debe permitir que un evaluador:

1. Comprenda rápidamente el objetivo del proyecto.
2. Entienda la arquitectura propuesta.
3. Navegue fácilmente por el repositorio.
4. Identifique los artefactos principales.
5. Ejecute la solución en PUB400.
6. Ejecute las pruebas.
7. Verifique las evidencias.
8. Entienda las decisiones de diseño más importantes.

# AUDIENCIA

El lector puede ser:

* Instructor del taller.
* Arquitecto IBM i.
* Desarrollador IBM i.
* Revisor técnico.

No asumir conocimiento previo del proyecto.

# ESTILO

* Profesional.
* Claro.
* Conciso.
* Orientado a navegación.
* Usar tablas cuando aporten claridad.
* Incluir diagramas Mermaid cuando sea útil.
* Evitar párrafos extensos.

# ESTRUCTURA OBLIGATORIA

Generar las siguientes secciones:

# Título del Proyecto

## Resumen Ejecutivo

* Problema resuelto.
* Objetivo del proyecto.
* Resultado esperado.

## Alcance Funcional

* Qué hace.
* Qué no hace.

## Arquitectura General

Explicar:

* Programa principal.
* Módulos de negocio.
* Acceso a datos.
* Generación JSON.
* Utilidades.
* Componentes de pruebas.

Incluir diagrama Mermaid.

## Tecnologías Utilizadas

Tabla con:

| Tecnología | Uso |
| ---------- | --- |

## Estructura del Repositorio

Mostrar árbol completo del proyecto.

Explicar brevemente cada directorio.

## Artefactos Generados durante SDD

Tabla:

| Artefacto | Objetivo |
| --------- | -------- |

Incluir:

* 01-Analisis.md
* 01A-DecisionesSupuestos.md
* 02-SpecIBMi.md
* 03-ArquitecturaIBMi.md
* 03A-ArquitecturaPruebas.md
* Revisiones
* Evidencias

## Modelo de Datos

Resumen de tablas y vistas utilizadas.

## Instrucciones de Despliegue en PUB400

Explicar paso a paso:

1. Crear biblioteca.
2. Ejecutar scripts SQL.
3. Crear objetos necesarios.
4. Compilar módulos.
5. Crear Service Programs.
6. Crear Programas.
7. Validar compilación.

Indicar orden exacto de despliegue.

## Ejecución del Proceso Principal

Indicar:

* Comando.
* Parámetros.
* Resultado esperado.

## Ejecución de Pruebas

Separar:

### Pruebas Unitarias

### Pruebas de Integración

### Validación JSON

Para cada una indicar:

* Objeto ejecutado.
* Datos requeridos.
* Resultado esperado.

## Evidencias Incluidas

Tabla:

| Evidencia | Ubicación |
| --------- | --------- |

## Decisiones de Diseño Relevantes

Resumir los principales supuestos y decisiones arquitectónicas.

## Cumplimiento de Revision_IBMi.md

Tabla:

| Criterio | Estado |
| -------- | ------ |

## Limitaciones y Trabajo Futuro

## Autor

## Fecha

# REGLAS IMPORTANTES

* No inventar información inexistente.
* Si algún dato no está disponible, marcarlo como "Pendiente de completar".
* Basar el README únicamente en los artefactos disponibles.
* Priorizar navegabilidad sobre detalle excesivo.

# SALIDA

Generar únicamente el contenido completo de README.md listo para copiar al repositorio.
