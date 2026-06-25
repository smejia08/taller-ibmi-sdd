-- Limpieza idempotente de datos mock GLBLN.

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

