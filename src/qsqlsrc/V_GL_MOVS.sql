-- Vista de movimientos normalizados desde TRANS y TTRAN.
-- Campos logicos definidos por el contrato IBM i del taller.

create or replace view SMEJIAR1.V_GL_MOVS
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

label on table SMEJIAR1.V_GL_MOVS is
  'Movimientos normalizados TRANS y TTRAN';

comment on table SMEJIAR1.V_GL_MOVS is
  'Unifica movimientos para calcular saldos.';
