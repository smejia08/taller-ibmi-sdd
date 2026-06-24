-- Vista de contexto GLBLN para conciliacion.
-- Campos logicos definidos por el contrato IBM i del taller.

create or replace view V_GLBLN_CTX
  for system name VGLBLNCTX
as
select
       b.codigo_banco,
       b.codigo_sucursal,
       b.codigo_moneda,
       b.cuenta_contable,
       coalesce(m.descripcion_cuenta, '') as descripcion_cuenta,
       coalesce(m.naturaleza_cuenta, '') as naturaleza_cuenta,
       coalesce(m.nivel_cuenta, 0) as nivel_cuenta,
       coalesce(c.centro_costo, '') as centro_costo,
       b.saldo_actual,
       b.fecha_proceso_sistema
  from GLBLN b
  left join GLMST m
    on m.codigo_banco = b.codigo_banco
   and m.codigo_moneda = b.codigo_moneda
   and m.cuenta_contable = b.cuenta_contable
  left join CCDSC c
    on c.codigo_banco = b.codigo_banco
   and c.codigo_sucursal = b.codigo_sucursal
   and c.cuenta_contable = b.cuenta_contable;

label on table V_GLBLN_CTX is
  'Vista de balances GLBLN enriquecidos para conciliacion';

comment on table V_GLBLN_CTX is
  'Normaliza GLBLN con GLMST y CCDSC sin modificar tablas fuente.';
