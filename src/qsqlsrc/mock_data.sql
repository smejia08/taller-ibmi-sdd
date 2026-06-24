-- Dataset documental de prueba.
-- Ajustar nombres fisicos antes de ejecutar en un ambiente IBM i real.

-- Escenarios cubiertos:
-- 1. Cuenta conciliada.
-- 2. Diferencia fuera de tolerancia.
-- 3. Cuenta sin movimientos.
-- 4. Saldo cero.
-- 5. Maestro faltante.
-- 6. Descripcion faltante.
-- 7. Centro costo opcional ausente.

values
  ('GLBLN', '001', '001', 'COP', '100000', decimal(1000, 18, 2)),
  ('GLBLN', '001', '001', 'COP', '110000', decimal(500, 18, 2)),
  ('GLBLN', '001', '001', 'COP', '120000', decimal(0, 18, 2));
