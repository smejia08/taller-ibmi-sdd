--=============================================================================
-- Nombre de la Tabla: TRANS
-- DESCRIPCIÓN: Histórico de Transacciones
-- Objetivo: Almacenar los movimientos y transacciones históricas de cuentas.
-- Tipo de Tabla: Transaccional / Histórico
-- Origen de los Datos: Módulo de Transacciones / Núcleo Bancario
-- Permanencia de Datos: Permanente
-- Uso de los datos: Cálculo de saldo conciliado, auditoría y trazabilidad
-- Restricciones: Clave primaria autogenerada / secuencial.
-- Hecho por: Antigravity
-- Fecha: 2026-06-24
-- Proyecto: Taller IBM i - Conciliación
--=============================================================================

CREATE OR REPLACE TABLE TRANS (
  id_transaccion FOR COLUMN IDTRA BIGINT NOT NULL,
  id_movimiento FOR COLUMN IDMOV VARCHAR(30) NOT NULL,
  numero_registro_relativo FOR COLUMN NUMRRN VARCHAR(30),
  codigo_banco FOR COLUMN CODBAN VARCHAR(20) NOT NULL,
  codigo_sucursal FOR COLUMN CODSUC VARCHAR(20) NOT NULL,
  codigo_moneda FOR COLUMN CODMON VARCHAR(20) NOT NULL,
  cuenta_contable FOR COLUMN CUECON VARCHAR(24) NOT NULL,
  numero_cuenta FOR COLUMN NUMCUE VARCHAR(24),
  id_cliente FOR COLUMN IDCLI VARCHAR(30),
  fecha_operacion FOR COLUMN FECOPE DATE NOT NULL,
  fecha_valor FOR COLUMN FECVAL DATE,
  hora_operacion FOR COLUMN HOROPE TIME,
  tipo_movimiento FOR COLUMN TIPMOV VARCHAR(20),
  debito_credito FOR COLUMN DEBCRE CHAR(1) NOT NULL,
  monto FOR COLUMN MONTO DECIMAL(18, 2) NOT NULL,
  saldo_anterior FOR COLUMN SALANT DECIMAL(18, 2),
  saldo_posterior FOR COLUMN SALPOS DECIMAL(18, 2),
  canal_origen FOR COLUMN CANORI VARCHAR(20),
  terminal_origen FOR COLUMN TERORI VARCHAR(30),
  referencia_externa FOR COLUMN REFEXT VARCHAR(40),
  texto_descripcion FOR COLUMN TEXDSC VARCHAR(200),
  estado_transaccion FOR COLUMN ESTTRA VARCHAR(20),
  usuario_creacion FOR COLUMN USRCRE VARCHAR(30),
  usuario_actualizacion FOR COLUMN USRACT VARCHAR(30),
  version_registro FOR COLUMN VERREG INT,
  observaciones FOR COLUMN OBSREG VARCHAR(120),
  estado_registro FOR COLUMN ESTREG CHAR(1),
  created_at FOR COLUMN CRTAT TIMESTAMP,
  updated_at FOR COLUMN UPDAT TIMESTAMP,
  CONSTRAINT pk_trans PRIMARY KEY (id_transaccion)
)
RCDFMT RTRANS;

LABEL ON TABLE TRANS IS
  'Historico de Transacciones Contables';

COMMENT ON TABLE TRANS IS
  'Almacena el historico detallado de movimientos de cuentas.';

COMMENT ON COLUMN TRANS.id_transaccion IS
  'Identificador unico de la transaccion en el historico';
LABEL ON COLUMN TRANS.id_transaccion IS
  'ID Transaccion';
LABEL ON COLUMN TRANS.id_transaccion TEXT IS
  'ID Transaccion';

COMMENT ON COLUMN TRANS.id_movimiento IS
  'Identificador unico del movimiento para trazabilidad';
LABEL ON COLUMN TRANS.id_movimiento IS
  'ID Movimiento';
LABEL ON COLUMN TRANS.id_movimiento TEXT IS
  'ID Movimiento';

COMMENT ON COLUMN TRANS.numero_registro_relativo IS
  'Numero de registro relativo origen (RRN)';
LABEL ON COLUMN TRANS.numero_registro_relativo IS
  'Num. Registro Rel';
LABEL ON COLUMN TRANS.numero_registro_relativo TEXT IS
  'Numero de Registro Relativo';

COMMENT ON COLUMN TRANS.codigo_banco IS
  'Codigo identificador de la entidad bancaria';
LABEL ON COLUMN TRANS.codigo_banco IS
  'Cod. Banco';
LABEL ON COLUMN TRANS.codigo_banco TEXT IS
  'Codigo de Banco';

COMMENT ON COLUMN TRANS.codigo_sucursal IS
  'Codigo identificador de la sucursal de origen';
LABEL ON COLUMN TRANS.codigo_sucursal IS
  'Cod. Sucursal';
LABEL ON COLUMN TRANS.codigo_sucursal TEXT IS
  'Codigo de Sucursal';

COMMENT ON COLUMN TRANS.codigo_moneda IS
  'Codigo ISO de la divisa o moneda del movimiento';
LABEL ON COLUMN TRANS.codigo_moneda IS
  'Cod. Moneda';
LABEL ON COLUMN TRANS.codigo_moneda TEXT IS
  'Codigo de Moneda';

COMMENT ON COLUMN TRANS.cuenta_contable IS
  'Cuenta contable mayor afectada por el movimiento';
LABEL ON COLUMN TRANS.cuenta_contable IS
  'Cuenta Contable';
LABEL ON COLUMN TRANS.cuenta_contable TEXT IS
  'Cuenta Contable';

COMMENT ON COLUMN TRANS.numero_cuenta IS
  'Numero de cuenta de detalle de cliente si aplica';
LABEL ON COLUMN TRANS.numero_cuenta IS
  'Num. Cuenta';
LABEL ON COLUMN TRANS.numero_cuenta TEXT IS
  'Numero de Cuenta';

COMMENT ON COLUMN TRANS.id_cliente IS
  'Identificacion unica del cliente asociado';
LABEL ON COLUMN TRANS.id_cliente IS
  'ID Cliente';
LABEL ON COLUMN TRANS.id_cliente TEXT IS
  'ID Cliente';

COMMENT ON COLUMN TRANS.fecha_operacion IS
  'Fecha en que se ejecuto la operacion contable';
LABEL ON COLUMN TRANS.fecha_operacion IS
  'Fec. Operacion';
LABEL ON COLUMN TRANS.fecha_operacion TEXT IS
  'Fecha de Operacion';

COMMENT ON COLUMN TRANS.fecha_valor IS
  'Fecha valor o de efectividad contable';
LABEL ON COLUMN TRANS.fecha_valor IS
  'Fec. Valor';
LABEL ON COLUMN TRANS.fecha_valor TEXT IS
  'Fecha Valor';

COMMENT ON COLUMN TRANS.hora_operacion IS
  'Hora exacta de la operacion contable';
LABEL ON COLUMN TRANS.hora_operacion IS
  'Hora Operacion';
LABEL ON COLUMN TRANS.hora_operacion TEXT IS
  'Hora de Operacion';

COMMENT ON COLUMN TRANS.tipo_movimiento IS
  'Tipo de movimiento contable (deposito, retiro, etc.)';
LABEL ON COLUMN TRANS.tipo_movimiento IS
  'Tipo Movimiento';
LABEL ON COLUMN TRANS.tipo_movimiento TEXT IS
  'Tipo de Movimiento';

COMMENT ON COLUMN TRANS.debito_credito IS
  'Indicador de afectacion (D Debito, C Credito)';
LABEL ON COLUMN TRANS.debito_credito IS
  'Deb. / Cred.';
LABEL ON COLUMN TRANS.debito_credito TEXT IS
  'Debito o Credito';

COMMENT ON COLUMN TRANS.monto IS
  'Monto o valor monetario de la transaccion';
LABEL ON COLUMN TRANS.monto IS
  'Monto Transac.';
LABEL ON COLUMN TRANS.monto TEXT IS
  'Monto de Transaccion';

COMMENT ON COLUMN TRANS.saldo_anterior IS
  'Saldo contable de la cuenta antes del movimiento';
LABEL ON COLUMN TRANS.saldo_anterior IS
  'Saldo Anterior';
LABEL ON COLUMN TRANS.saldo_anterior TEXT IS
  'Saldo Anterior';

COMMENT ON COLUMN TRANS.saldo_posterior IS
  'Saldo contable de la cuenta posterior al movimiento';
LABEL ON COLUMN TRANS.saldo_posterior IS
  'Saldo Posterior';
LABEL ON COLUMN TRANS.saldo_posterior TEXT IS
  'Saldo Posterior';

COMMENT ON COLUMN TRANS.canal_origen IS
  'Canal transaccional de origen (ATM, WEB, etc.)';
LABEL ON COLUMN TRANS.canal_origen IS
  'Canal Origen';
LABEL ON COLUMN TRANS.canal_origen TEXT IS
  'Canal de Origen';

COMMENT ON COLUMN TRANS.terminal_origen IS
  'Identificador de la terminal o servidor de origen';
LABEL ON COLUMN TRANS.terminal_origen IS
  'Terminal Origen';
LABEL ON COLUMN TRANS.terminal_origen TEXT IS
  'Terminal de Origen';

COMMENT ON COLUMN TRANS.referencia_externa IS
  'Referencia o identificador del sistema externo';
LABEL ON COLUMN TRANS.referencia_externa IS
  'Ref. Externa';
LABEL ON COLUMN TRANS.referencia_externa TEXT IS
  'Referencia Externa';

COMMENT ON COLUMN TRANS.texto_descripcion IS
  'Texto descriptivo o concepto de la transaccion';
LABEL ON COLUMN TRANS.texto_descripcion IS
  'Concepto Trans.';
LABEL ON COLUMN TRANS.texto_descripcion TEXT IS
  'Concepto de Transaccion';

COMMENT ON COLUMN TRANS.estado_transaccion IS
  'Estado de la transaccion (Aplicado, Reverso, etc)';
LABEL ON COLUMN TRANS.estado_transaccion IS
  'Est. Transac.';
LABEL ON COLUMN TRANS.estado_transaccion TEXT IS
  'Estado de Transaccion';

COMMENT ON COLUMN TRANS.usuario_creacion IS
  'Usuario o proceso que registro la transaccion';
LABEL ON COLUMN TRANS.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN TRANS.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN TRANS.usuario_actualizacion IS
  'Usuario o proceso que modifico la transaccion';
LABEL ON COLUMN TRANS.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN TRANS.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN TRANS.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN TRANS.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN TRANS.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN TRANS.observaciones IS
  'Comentarios u observaciones de la transaccion';
LABEL ON COLUMN TRANS.observaciones IS
  'Observaciones';
LABEL ON COLUMN TRANS.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN TRANS.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN TRANS.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN TRANS.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN TRANS.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN TRANS.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN TRANS.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN TRANS.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN TRANS.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN TRANS.updated_at TEXT IS
  'Actualizado el';
