-- Carga idempotente de mock data para pruebas GLBLN.

call qsys2.ifs_write_utf8('/GLBTST/.keep', '', 'REPLACE', 'NONE');
call qsys2.ifs_write_utf8('/GLBTST/output/.keep', '', 'REPLACE', 'NONE');
call qsys2.ifs_write_utf8('/GLBTST/logs/.keep', '', 'REPLACE', 'NONE');

delete from TRDSC
 where numero_registro_relativo in
       ('1001', '1002', '1101', '1501', '1601', '1701');

delete from TTRAN
 where codigo_banco = '001'
   and codigo_sucursal = '001'
   and codigo_moneda = 'COP'
   and cuenta_contable between '100000' and '170000';

delete from TRANS
 where codigo_banco = '001'
   and codigo_sucursal = '001'
   and codigo_moneda = 'COP'
   and cuenta_contable between '100000' and '170000';

delete from CCDSC
 where codigo_banco = '001'
   and codigo_sucursal = '001'
   and cuenta_contable between '100000' and '170000';

delete from GLMST
 where codigo_banco = '001'
   and codigo_moneda = 'COP'
   and cuenta_contable between '100000' and '170000';

delete from GLBLN
 where codigo_banco = '001'
   and codigo_sucursal = '001'
   and codigo_moneda = 'COP'
   and cuenta_contable between '100000' and '170000';

insert into GLBLN
  (codigo_banco, codigo_sucursal, codigo_moneda, cuenta_contable,
   descripcion_cuenta, naturaleza_cuenta, nivel_cuenta, saldo_actual,
   fecha_proceso_sistema, estado_registro, created_at, updated_at)
values
  ('001', '001', 'COP', '100000', 'CAJA PRINCIPAL', 'DEBITO', '1',
   1000.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '110000', 'CUENTA DIFERENCIA', 'DEBITO', '1',
   500.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '120000', 'SIN MOVIMIENTOS', 'DEBITO', '1',
   250.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '130000', 'SALDO CERO', 'DEBITO', '1',
   0.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '140000', 'MAESTRO FALTANTE', 'DEBITO', '1',
   800.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '150000', 'DESCRIPCION FALTANTE', 'DEBITO', '1',
   100.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '160000', 'CENTRO COSTO AUSENTE', 'DEBITO', '1',
   100.00, date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', '001', 'COP', '170000', 'SIGNO INVALIDO', 'DEBITO', '1',
   100.00, date('2026-06-25'), 'A', current timestamp, current timestamp);

insert into GLMST
  (codigo_banco, codigo_moneda, cuenta_contable, descripcion_cuenta,
   naturaleza_cuenta, nivel_cuenta, saldo_actual, fecha_proceso_sistema,
   estado_registro, created_at, updated_at)
values
  ('001', 'COP', '100000', 'CAJA PRINCIPAL', 'DEBITO', 1, 1000.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', 'COP', '110000', 'CUENTA DIFERENCIA', 'DEBITO', 1, 500.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', 'COP', '120000', 'SIN MOVIMIENTOS', 'DEBITO', 1, 250.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', 'COP', '130000', 'SALDO CERO', 'DEBITO', 1, 0.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', 'COP', '150000', 'DESCRIPCION FALTANTE', 'DEBITO', 1, 100.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', 'COP', '160000', 'CENTRO COSTO AUSENTE', 'DEBITO', 1, 100.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp),
  ('001', 'COP', '170000', 'SIGNO INVALIDO', 'DEBITO', 1, 100.00,
   date('2026-06-25'), 'A', current timestamp, current timestamp);

insert into CCDSC
  (codigo_banco, codigo_sucursal, cuenta_contable, centro_costo,
   estado_registro, created_at, updated_at)
values
  ('001', '001', '100000', 'CC001', 'A',
   current timestamp, current timestamp),
  ('001', '001', '110000', 'CC001', 'A',
   current timestamp, current timestamp),
  ('001', '001', '120000', 'CC001', 'A',
   current timestamp, current timestamp),
  ('001', '001', '130000', 'CC001', 'A',
   current timestamp, current timestamp),
  ('001', '001', '150000', 'CC001', 'A',
   current timestamp, current timestamp),
  ('001', '001', '170000', 'CC001', 'A',
   current timestamp, current timestamp);

insert into TRANS
  (id_transaccion, id_movimiento, numero_registro_relativo,
   codigo_banco, codigo_sucursal, codigo_moneda, cuenta_contable,
   fecha_operacion, tipo_movimiento, debito_credito, monto,
   referencia_externa, texto_descripcion, estado_transaccion,
   estado_registro, created_at, updated_at)
values
  (1001, 'TST100-D', '1001', '001', '001', 'COP', '100000',
   date('2026-06-25'), 'GL', 'D', 700.00, 'REF100D',
   'Debito conciliado', 'APLICADO', 'A',
   current timestamp, current timestamp),
  (1101, 'TST110-D', '1101', '001', '001', 'COP', '110000',
   date('2026-06-25'), 'GL', 'D', 300.00, 'REF110D',
   'Debito fuera tolerancia', 'APLICADO', 'A',
   current timestamp, current timestamp),
  (1501, 'TST150-D', '1501', '001', '001', 'COP', '150000',
   date('2026-06-25'), 'GL', 'D', 200.00, 'REF150D',
   '', 'APLICADO', 'A', current timestamp, current timestamp),
  (1601, 'TST160-D', '1601', '001', '001', 'COP', '160000',
   date('2026-06-25'), 'GL', 'D', 100.00, 'REF160D',
   'Debito sin centro costo', 'APLICADO', 'A',
   current timestamp, current timestamp),
  (1701, 'TST170-X', '1701', '001', '001', 'COP', '170000',
   date('2026-06-25'), 'GL', 'X', 50.00, 'REF170X',
   'Signo invalido', 'APLICADO', 'A',
   current timestamp, current timestamp);

insert into TTRAN
  (id_transaccion_dia, id_movimiento, numero_registro_relativo,
   codigo_banco, codigo_sucursal, codigo_moneda, cuenta_contable,
   numero_cuenta, fecha, fecha_operacion, tipo_movimiento,
   debito_credito, monto, referencia_externa, texto_descripcion,
   estado_transaccion, estado_registro, created_at, updated_at)
values
  (1002, 'TST100-C', '1002', '001', '001', 'COP', '100000',
   '100000', date('2026-06-25'), date('2026-06-25'), 'GL',
   'C', 700.00, 'REF100C', 'Credito conciliado', 'APLICADO',
   'A', current timestamp, current timestamp);

insert into TRDSC
  (numero_registro_relativo, secuencia, tipo_movimiento,
   tipo_descripcion, texto_descripcion, codigo_idioma, obligatorio,
   estado_registro, created_at, updated_at)
values
  ('1001', 1, 'GL', 'CONCEPTO', 'Debito conciliado', 'ES', true,
   'A', current timestamp, current timestamp),
  ('1002', 1, 'GL', 'CONCEPTO', 'Credito conciliado', 'ES', true,
   'A', current timestamp, current timestamp),
  ('1101', 1, 'GL', 'CONCEPTO', 'Debito fuera tolerancia', 'ES', true,
   'A', current timestamp, current timestamp),
  ('1601', 1, 'GL', 'CONCEPTO', 'Debito sin centro costo', 'ES', false,
   'A', current timestamp, current timestamp);

