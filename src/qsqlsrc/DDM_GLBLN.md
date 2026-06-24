# DDM GLBLN

Objeto fuente: `GLBLN`

Uso: fuente principal de balances generales.

| Campo logico | Tipo logico | Obligatorio | Clave | Uso |
|---|---|---:|---:|---|
| codigo_banco | char/varchar | Si | Si | Filtro y trazabilidad. |
| codigo_sucursal | char/varchar | No | Si | Filtro opcional. |
| codigo_moneda | char/varchar | No | Si | Filtro opcional. |
| cuenta_contable | char/varchar | Si | Si | Cuenta procesada. |
| saldo_actual | decimal(18,2) | Si | No | Saldo fuente. |
| fecha_proceso_sistema | date | Si | Si | Fecha de corte. |

Observacion: nombres fisicos sujetos a homologacion del diccionario real.
