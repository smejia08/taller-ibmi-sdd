# DDM CCDSC

Objeto fuente: `CCDSC`

Uso: centro de costo opcional.

| Campo logico | Tipo logico | Obligatorio | Clave | Uso |
|---|---|---:|---:|---|
| codigo_banco | char/varchar | Si | Si | Relacion con GLBLN. |
| codigo_sucursal | char/varchar | No | Si | Relacion con GLBLN. |
| cuenta_contable | char/varchar | Si | Si | Relacion con GLBLN. |
| centro_costo | varchar | No | No | Centro de costo exportado. |

Observacion: la ausencia de relacion no aborta la cuenta; se exporta nulo o
cadena vacia controlada segun contrato JSON.
