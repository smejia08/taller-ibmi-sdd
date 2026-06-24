# DDM TRDSC

Objeto fuente: `TRDSC`

Uso: descripciones adicionales de movimientos.

| Campo logico | Tipo logico | Obligatorio | Clave | Uso |
|---|---|---:|---:|---|
| tipo_movimiento | varchar | No | Si | Relacion con movimiento. |
| tipo_descripcion | varchar | No | Si | Clasificacion descripcion. |
| texto_descripcion | varchar | No | No | Texto exportable. |

Observacion: `V_GL_MOVS` expone `texto_descripcion`; la homologacion fisica
de TRDSC debe confirmar si se resuelve por join o por origen normalizado.
