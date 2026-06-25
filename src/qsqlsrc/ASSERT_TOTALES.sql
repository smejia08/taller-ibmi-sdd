-- Cuadre automatico de controlTotales contra detalle JSON.

with doc(json_doc) as (
  values get_clob_from_file('/GLBTST/output/CONCILIACION_GLBLN_TST.json')
),
control as (
  select c.*
    from doc,
         json_table(
           json_doc,
           'strict $.controlTotales'
           columns (
             total_cuentas integer path '$.totalCuentasLeidas',
             suma_fuente decimal(18, 2) path '$.sumatoriaSaldoFuente',
             suma_diferencia decimal(18, 2)
               path '$.sumatoriaDiferenciaNeta'
           )
         ) as c
),
detalle as (
  select count(*) as total_cuentas,
         coalesce(sum(saldo_fuente), 0) as suma_fuente,
         coalesce(sum(diferencia), 0) as suma_diferencia
    from doc,
         json_table(
           json_doc,
           'strict $.cuentas[*]'
           columns (
             saldo_fuente decimal(18, 2) path '$.saldos.saldoFuente',
             diferencia decimal(18, 2) path '$.saldos.diferenciaNeta'
           )
         ) as d
)
select control.total_cuentas - detalle.total_cuentas as diff_cuentas,
       control.suma_fuente - detalle.suma_fuente as diff_saldo_fuente,
       control.suma_diferencia - detalle.suma_diferencia as diff_diferencia
  from control, detalle;

