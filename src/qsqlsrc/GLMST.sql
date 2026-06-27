--=============================================================================
-- Nombre de la Tabla: SMEJIAR1.GLMST
-- DESCRIPCIÓN: Maestro de Cuentas Contables
-- Objetivo: Almacenar la definición y catálogo de cuentas contables.
-- Tipo de Tabla: Maestro / Catálogo
-- Origen de los Datos: Módulo de Contabilidad General (GL)
-- Permanencia de Datos: Permanente
-- Uso de los datos: Validación de cuentas contables y obtención de catálogo
-- Restricciones: Clave primaria compuesta por banco, moneda y cuenta.
-- Hecho por: Antigravity
-- Fecha: 2026-06-24
-- Proyecto: Taller IBM i - Conciliación
--=============================================================================
DROP TABLE IF EXISTS SMEJIAR1.GLMST;

CREATE OR REPLACE TABLE SMEJIAR1.GLMST (
  codigo_banco FOR COLUMN CODBAN VARCHAR(20) NOT NULL,
  codigo_moneda FOR COLUMN CODMON VARCHAR(20) NOT NULL,
  cuenta_contable FOR COLUMN CUECON VARCHAR(24) NOT NULL,
  descripcion_cuenta FOR COLUMN DESCTA VARCHAR(120),
  naturaleza_cuenta FOR COLUMN NATCTA VARCHAR(20),
  nivel_cuenta FOR COLUMN NIVCTA INTEGER,
  saldo_actual FOR COLUMN SALACT DECIMAL(18, 2),
  fecha_proceso_sistema FOR COLUMN FECPRO DATE NOT NULL,
  observaciones FOR COLUMN OBSREG VARCHAR(120),
  usuario_creacion FOR COLUMN USRCRE VARCHAR(30),
  usuario_actualizacion FOR COLUMN USRACT VARCHAR(30),
  version_registro FOR COLUMN VERREG INT,
  estado_registro FOR COLUMN ESTREG CHAR(1),
  created_at FOR COLUMN CRTAT TIMESTAMP,
  updated_at FOR COLUMN UPDAT TIMESTAMP,
  CONSTRAINT pk_glmst PRIMARY KEY (
    codigo_banco,
    codigo_moneda,
    cuenta_contable
  )
)
RCDFMT RGLMST;

LABEL ON TABLE SMEJIAR1.GLMST IS
  'Maestro de Cuentas Contables';

COMMENT ON TABLE SMEJIAR1.GLMST IS
  'Definicion del catalogo de cuentas contables y su naturaleza.';

COMMENT ON COLUMN SMEJIAR1.GLMST.codigo_banco IS
  'Codigo identificador de la entidad bancaria';
LABEL ON COLUMN SMEJIAR1.GLMST.codigo_banco IS
  'Cod. Banco';
LABEL ON COLUMN SMEJIAR1.GLMST.codigo_banco TEXT IS
  'Codigo de Banco';

COMMENT ON COLUMN SMEJIAR1.GLMST.codigo_moneda IS
  'Codigo ISO de la divisa o moneda de la cuenta';
LABEL ON COLUMN SMEJIAR1.GLMST.codigo_moneda IS
  'Cod. Moneda';
LABEL ON COLUMN SMEJIAR1.GLMST.codigo_moneda TEXT IS
  'Codigo de Moneda';

COMMENT ON COLUMN SMEJIAR1.GLMST.cuenta_contable IS
  'Identificador unico de la cuenta contable en el catalogo';
LABEL ON COLUMN SMEJIAR1.GLMST.cuenta_contable IS
  'Cuenta Contable';
LABEL ON COLUMN SMEJIAR1.GLMST.cuenta_contable TEXT IS
  'Cuenta Contable';

COMMENT ON COLUMN SMEJIAR1.GLMST.descripcion_cuenta IS
  'Descripcion larga o nombre formal de la cuenta contable';
LABEL ON COLUMN SMEJIAR1.GLMST.descripcion_cuenta IS
  'Descrip. Cuenta';
LABEL ON COLUMN SMEJIAR1.GLMST.descripcion_cuenta TEXT IS
  'Descripcion de Cuenta';

COMMENT ON COLUMN SMEJIAR1.GLMST.naturaleza_cuenta IS
  'Naturaleza contable de la cuenta (Debito o Credito)';
LABEL ON COLUMN SMEJIAR1.GLMST.naturaleza_cuenta IS
  'Naturaleza Cta';
LABEL ON COLUMN SMEJIAR1.GLMST.naturaleza_cuenta TEXT IS
  'Naturaleza de Cuenta';

COMMENT ON COLUMN SMEJIAR1.GLMST.nivel_cuenta IS
  'Nivel o jerarquia de agrupacion de la cuenta contable';
LABEL ON COLUMN SMEJIAR1.GLMST.nivel_cuenta IS
  'Nivel Cuenta';
LABEL ON COLUMN SMEJIAR1.GLMST.nivel_cuenta TEXT IS
  'Nivel de Cuenta';

COMMENT ON COLUMN SMEJIAR1.GLMST.saldo_actual IS
  'Saldo contable actual de la cuenta a la fecha de corte';
LABEL ON COLUMN SMEJIAR1.GLMST.saldo_actual IS
  'Saldo Actual';
LABEL ON COLUMN SMEJIAR1.GLMST.saldo_actual TEXT IS
  'Saldo Actual';

COMMENT ON COLUMN SMEJIAR1.GLMST.fecha_proceso_sistema IS
  'Fecha de corte del catalogo del sistema contable';
LABEL ON COLUMN SMEJIAR1.GLMST.fecha_proceso_sistema IS
  'Fec. Proceso';
LABEL ON COLUMN SMEJIAR1.GLMST.fecha_proceso_sistema TEXT IS
  'Fecha de Proceso';

COMMENT ON COLUMN SMEJIAR1.GLMST.observaciones IS
  'Comentarios u observaciones del registro del maestro';
LABEL ON COLUMN SMEJIAR1.GLMST.observaciones IS
  'Observaciones';
LABEL ON COLUMN SMEJIAR1.GLMST.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN SMEJIAR1.GLMST.usuario_creacion IS
  'Usuario o proceso que registro la cuenta en el maestro';
LABEL ON COLUMN SMEJIAR1.GLMST.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN SMEJIAR1.GLMST.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN SMEJIAR1.GLMST.usuario_actualizacion IS
  'Usuario o proceso que realizo la ultima actualizacion';
LABEL ON COLUMN SMEJIAR1.GLMST.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN SMEJIAR1.GLMST.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN SMEJIAR1.GLMST.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN SMEJIAR1.GLMST.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN SMEJIAR1.GLMST.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN SMEJIAR1.GLMST.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN SMEJIAR1.GLMST.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN SMEJIAR1.GLMST.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN SMEJIAR1.GLMST.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN SMEJIAR1.GLMST.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN SMEJIAR1.GLMST.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN SMEJIAR1.GLMST.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN SMEJIAR1.GLMST.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN SMEJIAR1.GLMST.updated_at TEXT IS
  'Actualizado el';
