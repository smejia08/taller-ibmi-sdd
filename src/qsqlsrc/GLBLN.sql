--=============================================================================
-- Nombre de la Tabla: GLBLN
-- DESCRIPCIÓN: Balances Generales
-- Objetivo: Almacenar saldos y balances contables de las cuentas mayores.
-- Tipo de Tabla: Transaccional / Maestro de saldos
-- Origen de los Datos: Módulo de Contabilidad General (GL)
-- Permanencia de Datos: Permanente
-- Uso de los datos: Conciliación de saldos y reportería financiera
-- Restricciones: Relación con maestro GLMST y clave primaria compuesta.
-- Hecho por: Antigravity
-- Fecha: 2026-06-24
-- Proyecto: Taller IBM i - Conciliación
--=============================================================================
DROP TABLE IF EXISTS SMEJIAR1.GLBLN;

CREATE OR REPLACE TABLE GLBLN (
  codigo_banco FOR COLUMN CODBAN VARCHAR(20) NOT NULL,
  codigo_sucursal FOR COLUMN CODSUC VARCHAR(20) NOT NULL,
  codigo_moneda FOR COLUMN CODMON VARCHAR(20) NOT NULL,
  cuenta_contable FOR COLUMN CUECON VARCHAR(24) NOT NULL,
  descripcion_cuenta FOR COLUMN DESCTA VARCHAR(120),
  naturaleza_cuenta FOR COLUMN NATCTA VARCHAR(20),
  nivel_cuenta FOR COLUMN NIVCTA VARCHAR(50),
  saldo_actual FOR COLUMN SALACT DECIMAL(18, 2),
  fecha_proceso_sistema FOR COLUMN FECPRO DATE NOT NULL,
  observaciones FOR COLUMN OBSREG VARCHAR(120),
  usuario_creacion FOR COLUMN USRCRE VARCHAR(30),
  usuario_actualizacion FOR COLUMN USRACT VARCHAR(30),
  version_registro FOR COLUMN VERREG INT,
  estado_registro FOR COLUMN ESTREG CHAR(1),
  created_at FOR COLUMN CRTAT TIMESTAMP,
  updated_at FOR COLUMN UPDAT TIMESTAMP,
  CONSTRAINT pk_glbln PRIMARY KEY (
    codigo_banco,
    codigo_sucursal,
    codigo_moneda,
    cuenta_contable,
    fecha_proceso_sistema
  )
)
RCDFMT RGLBLN;

LABEL ON TABLE GLBLN IS
  'Balances Generales de Cuentas Mayores';

COMMENT ON TABLE GLBLN IS
  'Almacena saldos contables de cuentas mayores para conciliacion.';

COMMENT ON COLUMN GLBLN.codigo_banco IS
  'Codigo identificador de la entidad bancaria';
LABEL ON COLUMN GLBLN.codigo_banco IS
  'Cod. Banco';
LABEL ON COLUMN GLBLN.codigo_banco TEXT IS
  'Codigo de Banco';

COMMENT ON COLUMN GLBLN.codigo_sucursal IS
  'Codigo identificador de la sucursal o centro de atencion';
LABEL ON COLUMN GLBLN.codigo_sucursal IS
  'Cod. Sucursal';
LABEL ON COLUMN GLBLN.codigo_sucursal TEXT IS
  'Codigo de Sucursal';

COMMENT ON COLUMN GLBLN.codigo_moneda IS
  'Codigo ISO de la divisa o moneda de la cuenta';
LABEL ON COLUMN GLBLN.codigo_moneda IS
  'Cod. Moneda';
LABEL ON COLUMN GLBLN.codigo_moneda TEXT IS
  'Codigo de Moneda';

COMMENT ON COLUMN GLBLN.cuenta_contable IS
  'Identificador unico de la cuenta contable en el catalogo';
LABEL ON COLUMN GLBLN.cuenta_contable IS
  'Cuenta Contable';
LABEL ON COLUMN GLBLN.cuenta_contable TEXT IS
  'Cuenta Contable';

COMMENT ON COLUMN GLBLN.descripcion_cuenta IS
  'Descripcion larga o nombre formal de la cuenta contable';
LABEL ON COLUMN GLBLN.descripcion_cuenta IS
  'Descrip. Cuenta';
LABEL ON COLUMN GLBLN.descripcion_cuenta TEXT IS
  'Descripcion de Cuenta';

COMMENT ON COLUMN GLBLN.naturaleza_cuenta IS
  'Naturaleza contable de la cuenta (Debito o Credito)';
LABEL ON COLUMN GLBLN.naturaleza_cuenta IS
  'Naturaleza Cta';
LABEL ON COLUMN GLBLN.naturaleza_cuenta TEXT IS
  'Naturaleza de Cuenta';

COMMENT ON COLUMN GLBLN.nivel_cuenta IS
  'Nivel o jerarquia de agrupacion de la cuenta contable';
LABEL ON COLUMN GLBLN.nivel_cuenta IS
  'Nivel Cuenta';
LABEL ON COLUMN GLBLN.nivel_cuenta TEXT IS
  'Nivel de Cuenta';

COMMENT ON COLUMN GLBLN.saldo_actual IS
  'Saldo contable actual de la cuenta a la fecha de corte';
LABEL ON COLUMN GLBLN.saldo_actual IS
  'Saldo Actual';
LABEL ON COLUMN GLBLN.saldo_actual TEXT IS
  'Saldo Actual';

COMMENT ON COLUMN GLBLN.fecha_proceso_sistema IS
  'Fecha de corte del saldo del sistema contable';
LABEL ON COLUMN GLBLN.fecha_proceso_sistema IS
  'Fec. Proceso';
LABEL ON COLUMN GLBLN.fecha_proceso_sistema TEXT IS
  'Fecha de Proceso';

COMMENT ON COLUMN GLBLN.observaciones IS
  'Comentarios u observaciones del registro contable';
LABEL ON COLUMN GLBLN.observaciones IS
  'Observaciones';
LABEL ON COLUMN GLBLN.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN GLBLN.usuario_creacion IS
  'Usuario o proceso que registro los saldos iniciales';
LABEL ON COLUMN GLBLN.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN GLBLN.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN GLBLN.usuario_actualizacion IS
  'Usuario o proceso que realizo la ultima actualizacion';
LABEL ON COLUMN GLBLN.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN GLBLN.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN GLBLN.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN GLBLN.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN GLBLN.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN GLBLN.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN GLBLN.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN GLBLN.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN GLBLN.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN GLBLN.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN GLBLN.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN GLBLN.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN GLBLN.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN GLBLN.updated_at TEXT IS
  'Actualizado el';
