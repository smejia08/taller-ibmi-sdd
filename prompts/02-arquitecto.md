# ROL

Actúa como Arquitecto IBM i.

# CONTEXTO

Dispones únicamente de:

* 01-Analisis.md
* 01A-DecisionesSupuestos.md
* estructura_bd.md
* Revision_IBMi.md

# OBJETIVO

Construir:

* 02-SpecIBMi.md
* 03-ArquitecturaIBMi.md

# TECNOLOGÍA PERMITIDA

* SQLRPGLE
* RPGLE Free
* CLLE
* DB2 for i
* Service Programs
* SQL Tables
* SQL Views

# TECNOLOGÍA PROHIBIDA

* React
* Angular
* API REST
* DTO
* Controller
* Microservicios

# INSTRUCCIONES

Definir:

1. Componentes.
2. Responsabilidades.
3. Flujo batch.
4. Dependencias.
5. Contratos entre componentes.
6. Estrategia de logging.
7. Estrategia JSON.
8. Estrategia de manejo de errores.
9. Estrategia de pruebas.

# VALIDACIONES

La arquitectura debe cumplir:

* SOLID
* Separación de responsabilidades
* Reglas de Revision_IBMi.md
* Normas o convenciones de IBM i que no contradigan las reglas de Revision_IBMi.md, por ejemplo: nombres de objetos, tipos de datos, en archivos SQL no superar 80 caracteres por línea, etc.
* Toda decisión marcada como "Supuesto" debe quedar documentada en 02-SpecIBMi.md.

# SALIDA

02-SpecIBMi.md

03-ArquitecturaIBMi.md
