# DDM GLMST

Objeto fuente: `GLMST`

Uso: maestro contable preferente.

| Campo logico | Tipo logico | Obligatorio | Clave | Uso |
|---|---|---:|---:|---|
| codigo_banco | char/varchar | Si | Si | Relacion con GLBLN. |
| codigo_moneda | char/varchar | No | Si | Relacion con GLBLN. |
| cuenta_contable | char/varchar | Si | Si | Relacion con GLBLN. |
| descripcion_cuenta | varchar | No | No | Descripcion exportada. |
| naturaleza_cuenta | varchar | No | No | Clasificacion contable. |
| nivel_cuenta | integer | No | No | Nivel jerarquico. |

Observacion: nombres fisicos sujetos a homologacion del diccionario real.
