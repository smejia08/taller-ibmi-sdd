-- Vista de movimientos normalizados desde TRANS y TTRAN.
-- Campos logicos definidos por el contrato IBM i del taller.

create or replace view V_GL_MOVS
  for system name VGLMOVS
as
select
       codigo_banco,
       codigo_sucursal,
       codigo_moneda,
       cuenta_contable,
       id_movimiento,
       numero_registro_relativo,
       fecha_operacion,
       tipo_movimiento,
       debito_credito,
       monto,
       referencia_externa,
       texto_descripcion
  from TRANS
union all
select
       codigo_banco,
       codigo_sucursal,
       codigo_moneda,
       cuenta_contable,
       id_movimiento,
       numero_registro_relativo,
       fecha_operacion,
       tipo_movimiento,
       debito_credito,
       monto,
       referencia_externa,
       texto_descripcion
  from TTRAN;

label on table V_GL_MOVS is
  'Vista de movimientos contables normalizados TRANS y TTRAN';

comment on table V_GL_MOVS is
  'Unifica movimientos historicos y del dia para calcular saldos.';
