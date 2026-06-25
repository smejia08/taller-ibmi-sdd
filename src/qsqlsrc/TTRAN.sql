--=============================================================================
-- Nombre de la Tabla: TTRAN
-- DESCRIPCIÓN: Archivo Maestro de Transacciones del día
-- Objetivo: Almacenar los movimientos y transacciones diarias del banco.
-- Tipo de Tabla: Transaccional / Operativo diario
-- Origen de los Datos: Módulo de Transacciones del día
-- Permanencia de Datos: Temporal / Diaria (Cierre diario)
-- Uso de los datos: Conciliación de saldos y transacciones del día
-- Restricciones: Clave primaria compuesta por ID transaccion diaria y banco.
-- Hecho por: Antigravity
-- Fecha: 2026-06-24
-- Proyecto: Taller IBM i - Conciliación
--=============================================================================

CREATE OR REPLACE TABLE TTRAN (
  id_transaccion_dia FOR COLUMN IDTRADIA BIGINT NOT NULL,
  id_movimiento FOR COLUMN IDMOV VARCHAR(30) NOT NULL,
  numero_registro_relativo FOR COLUMN NUMRRN VARCHAR(30),
  codigo_banco FOR COLUMN CODBAN VARCHAR(20) NOT NULL,
  codigo_sucursal FOR COLUMN CODSUC VARCHAR(20) NOT NULL,
  codigo_moneda FOR COLUMN CODMON VARCHAR(20) NOT NULL,
  cuenta_contable FOR COLUMN CUECON VARCHAR(24) NOT NULL,
  numero_cuenta FOR COLUMN NUMCUE VARCHAR(24) NOT NULL,
  id_cliente FOR COLUMN IDCLI VARCHAR(30),
  fecha FOR COLUMN FECHA DATE NOT NULL,
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
  CONSTRAINT pk_ttran PRIMARY KEY (id_transaccion_dia, codigo_banco)
)
RCDFMT RTTRAN;

LABEL ON TABLE TTRAN IS
  'Transacciones Contables del Dia';

COMMENT ON TABLE TTRAN IS
  'Almacena el detalle de movimientos de cuentas del dia en curso.';

COMMENT ON COLUMN TTRAN.id_transaccion_dia IS
  'Identificador secuencial unico del movimiento del dia';
LABEL ON COLUMN TTRAN.id_transaccion_dia IS
  'ID Transac. Dia';
LABEL ON COLUMN TTRAN.id_transaccion_dia TEXT IS
  'ID Transaccion del Dia';

COMMENT ON COLUMN TTRAN.id_movimiento IS
  'Identificador unico del movimiento para trazabilidad';
LABEL ON COLUMN TTRAN.id_movimiento IS
  'ID Movimiento';
LABEL ON COLUMN TTRAN.id_movimiento TEXT IS
  'ID Movimiento';

COMMENT ON COLUMN TTRAN.numero_registro_relativo IS
  'Numero de registro relativo origen (RRN)';
LABEL ON COLUMN TTRAN.numero_registro_relativo IS
  'Num. Registro Rel';
LABEL ON COLUMN TTRAN.numero_registro_relativo TEXT IS
  'Numero de Registro Relativo';

COMMENT ON COLUMN TTRAN.codigo_banco IS
  'Codigo identificador de la entidad bancaria';
LABEL ON COLUMN TTRAN.codigo_banco IS
  'Cod. Banco';
LABEL ON COLUMN TTRAN.codigo_banco TEXT IS
  'Codigo de Banco';

COMMENT ON COLUMN TTRAN.codigo_sucursal IS
  'Codigo identificador de la sucursal de origen';
LABEL ON COLUMN TTRAN.codigo_sucursal IS
  'Cod. Sucursal';
LABEL ON COLUMN TTRAN.codigo_sucursal TEXT IS
  'Codigo de Sucursal';

COMMENT ON COLUMN TTRAN.codigo_moneda IS
  'Codigo ISO de la divisa o moneda del movimiento';
LABEL ON COLUMN TTRAN.codigo_moneda IS
  'Cod. Moneda';
LABEL ON COLUMN TTRAN.codigo_moneda TEXT IS
  'Codigo de Moneda';

COMMENT ON COLUMN TTRAN.cuenta_contable IS
  'Cuenta contable mayor afectada por el movimiento';
LABEL ON COLUMN TTRAN.cuenta_contable IS
  'Cuenta Contable';
LABEL ON COLUMN TTRAN.cuenta_contable TEXT IS
  'Cuenta Contable';

COMMENT ON COLUMN TTRAN.numero_cuenta IS
  'Numero de cuenta de detalle de cliente';
LABEL ON COLUMN TTRAN.numero_cuenta IS
  'Num. Cuenta';
LABEL ON COLUMN TTRAN.numero_cuenta TEXT IS
  'Numero de Cuenta';

COMMENT ON COLUMN TTRAN.id_cliente IS
  'Identificacion unica del cliente asociado';
LABEL ON COLUMN TTRAN.id_cliente IS
  'ID Cliente';
LABEL ON COLUMN TTRAN.id_cliente TEXT IS
  'ID Cliente';

COMMENT ON COLUMN TTRAN.fecha IS
  'Fecha de registro del movimiento contable';
LABEL ON COLUMN TTRAN.fecha IS
  'Fecha Registro';
LABEL ON COLUMN TTRAN.fecha TEXT IS
  'Fecha de Registro';

COMMENT ON COLUMN TTRAN.fecha_operacion IS
  'Fecha en que se ejecuto la operacion contable';
LABEL ON COLUMN TTRAN.fecha_operacion IS
  'Fec. Operacion';
LABEL ON COLUMN TTRAN.fecha_operacion TEXT IS
  'Fecha de Operacion';

COMMENT ON COLUMN TTRAN.fecha_valor IS
  'Fecha valor o de efectividad contable';
LABEL ON COLUMN TTRAN.fecha_valor IS
  'Fec. Valor';
LABEL ON COLUMN TTRAN.fecha_valor TEXT IS
  'Fecha Valor';

COMMENT ON COLUMN TTRAN.hora_operacion IS
  'Hora exacta de la operacion contable';
LABEL ON COLUMN TTRAN.hora_operacion IS
  'Hora Operacion';
LABEL ON COLUMN TTRAN.hora_operacion TEXT IS
  'Hora de Operacion';

COMMENT ON COLUMN TTRAN.tipo_movimiento IS
  'Tipo de movimiento contable (deposito, retiro, etc.)';
LABEL ON COLUMN TTRAN.tipo_movimiento IS
  'Tipo Movimiento';
LABEL ON COLUMN TTRAN.tipo_movimiento TEXT IS
  'Tipo de Movimiento';

COMMENT ON COLUMN TTRAN.debito_credito IS
  'Indicador de afectacion (D Debito, C Credito)';
LABEL ON COLUMN TTRAN.debito_credito IS
  'Deb. / Cred.';
LABEL ON COLUMN TTRAN.debito_credito TEXT IS
  'Debito o Credito';

COMMENT ON COLUMN TTRAN.monto IS
  'Monto o valor monetario de la transaccion';
LABEL ON COLUMN TTRAN.monto IS
  'Monto Transac.';
LABEL ON COLUMN TTRAN.monto TEXT IS
  'Monto de Transaccion';

COMMENT ON COLUMN TTRAN.saldo_anterior IS
  'Saldo contable de la cuenta antes del movimiento';
LABEL ON COLUMN TTRAN.saldo_anterior IS
  'Saldo Anterior';
LABEL ON COLUMN TTRAN.saldo_anterior TEXT IS
  'Saldo Anterior';

COMMENT ON COLUMN TTRAN.saldo_posterior IS
  'Saldo contable de la cuenta posterior al movimiento';
LABEL ON COLUMN TTRAN.saldo_posterior IS
  'Saldo Posterior';
LABEL ON COLUMN TTRAN.saldo_posterior TEXT IS
  'Saldo Posterior';

COMMENT ON COLUMN TTRAN.canal_origen IS
  'Canal transaccional de origen (ATM, WEB, etc.)';
LABEL ON COLUMN TTRAN.canal_origen IS
  'Canal Origen';
LABEL ON COLUMN TTRAN.canal_origen TEXT IS
  'Canal de Origen';

COMMENT ON COLUMN TTRAN.terminal_origen IS
  'Identificador de la terminal o servidor de origen';
LABEL ON COLUMN TTRAN.terminal_origen IS
  'Terminal Origen';
LABEL ON COLUMN TTRAN.terminal_origen TEXT IS
  'Terminal de Origen';

COMMENT ON COLUMN TTRAN.referencia_externa IS
  'Referencia o identificador del sistema externo';
LABEL ON COLUMN TTRAN.referencia_externa IS
  'Ref. Externa';
LABEL ON COLUMN TTRAN.referencia_externa TEXT IS
  'Referencia Externa';

COMMENT ON COLUMN TTRAN.texto_descripcion IS
  'Texto descriptivo o concepto de la transaccion';
LABEL ON COLUMN TTRAN.texto_descripcion IS
  'Concepto Trans.';
LABEL ON COLUMN TTRAN.texto_descripcion TEXT IS
  'Concepto de Transaccion';

COMMENT ON COLUMN TTRAN.estado_transaccion IS
  'Estado de la transaccion (Aplicado, Reverso, etc)';
LABEL ON COLUMN TTRAN.estado_transaccion IS
  'Est. Transac.';
LABEL ON COLUMN TTRAN.estado_transaccion TEXT IS
  'Estado de Transaccion';

COMMENT ON COLUMN TTRAN.usuario_creacion IS
  'Usuario o proceso que registro la transaccion';
LABEL ON COLUMN TTRAN.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN TTRAN.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN TTRAN.usuario_actualizacion IS
  'Usuario o proceso que modifico la transaccion';
LABEL ON COLUMN TTRAN.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN TTRAN.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN TTRAN.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN TTRAN.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN TTRAN.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN TTRAN.observaciones IS
  'Comentarios u observaciones de la transaccion';
LABEL ON COLUMN TTRAN.observaciones IS
  'Observaciones';
LABEL ON COLUMN TTRAN.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN TTRAN.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN TTRAN.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN TTRAN.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN TTRAN.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN TTRAN.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN TTRAN.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN TTRAN.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN TTRAN.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN TTRAN.updated_at TEXT IS
  'Actualizado el';
