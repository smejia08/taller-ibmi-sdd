# DDM TRANS

Objeto fuente: `TRANS`

Uso: movimientos historicos.

| Campo logico | Tipo logico | Obligatorio | Clave | Uso |
|---|---|---:|---:|---|
| codigo_banco | char/varchar | Si | Si | Relacion con cuenta. |
| codigo_sucursal | char/varchar | No | Si | Relacion con cuenta. |
| codigo_moneda | char/varchar | No | Si | Relacion con cuenta. |
| cuenta_contable | char/varchar | Si | Si | Relacion con cuenta. |
| id_movimiento | varchar | Si | Si | Identificador trazable. |
| numero_registro_relativo | integer | No | No | Trazabilidad fuente. |
| fecha_operacion | date | Si | Si | Corte de movimientos. |
| tipo_movimiento | varchar | No | No | Clasificacion. |
| debito_credito | char(1) | Si | No | D debito, C credito. |
| monto | decimal(18,2) | Si | No | Valor movimiento. |
| referencia_externa | varchar | No | No | Referencia operativa. |
| texto_descripcion | varchar | No | No | Texto normalizado. |

Observacion: nombres fisicos sujetos a homologacion del diccionario real.
