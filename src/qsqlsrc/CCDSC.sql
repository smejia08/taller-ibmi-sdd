--=============================================================================
-- Nombre de la Tabla: SMEJIAR1.CCDSC
-- DESCRIPCIÓN: Maestro de Centros de Costos
-- Objetivo: Almacenar la relación de centros de costos por cuenta y sucursal.
-- Tipo de Tabla: Maestro / Relación
-- Origen de los Datos: Módulo de Contabilidad General (GL)
-- Permanencia de Datos: Permanente
-- Uso de los datos: Enriquecimiento opcional de cuentas con centro de costo
-- Restricciones: Clave primaria compuesta por banco, sucursal y cuenta.
-- Hecho por: Antigravity
-- Fecha: 2026-06-24
-- Proyecto: Taller IBM i - Conciliación
--=============================================================================
DROP TABLE IF EXISTS SMEJIAR1.CCDSC;

CREATE OR REPLACE TABLE SMEJIAR1.CCDSC (
  codigo_banco FOR COLUMN CODBAN VARCHAR(20) NOT NULL,
  codigo_sucursal FOR COLUMN CODSUC VARCHAR(20) NOT NULL,
  cuenta_contable FOR COLUMN CUECON VARCHAR(24) NOT NULL,
  centro_costo FOR COLUMN CENCOS VARCHAR(30) NOT NULL,
  observaciones FOR COLUMN OBSREG VARCHAR(120),
  usuario_creacion FOR COLUMN USRCRE VARCHAR(30),
  usuario_actualizacion FOR COLUMN USRACT VARCHAR(30),
  version_registro FOR COLUMN VERREG INT,
  estado_registro FOR COLUMN ESTREG CHAR(1),
  created_at FOR COLUMN CRTAT TIMESTAMP,
  updated_at FOR COLUMN UPDAT TIMESTAMP,
  CONSTRAINT pk_ccdsc PRIMARY KEY (
    codigo_banco, codigo_sucursal, cuenta_contable
  )
)
RCDFMT RCCDSC;

LABEL ON TABLE SMEJIAR1.CCDSC IS
  'Maestros de Centros de Costos';

COMMENT ON TABLE SMEJIAR1.CCDSC IS
  'Almacena los centros de costos asociados a las cuentas contables.';

COMMENT ON COLUMN SMEJIAR1.CCDSC.codigo_banco IS
  'Codigo identificador de la entidad bancaria';
LABEL ON COLUMN SMEJIAR1.CCDSC.codigo_banco IS
  'Cod. Banco';
LABEL ON COLUMN SMEJIAR1.CCDSC.codigo_banco TEXT IS
  'Codigo de Banco';

COMMENT ON COLUMN SMEJIAR1.CCDSC.codigo_sucursal IS
  'Codigo identificador de la sucursal contable';
LABEL ON COLUMN SMEJIAR1.CCDSC.codigo_sucursal IS
  'Cod. Sucursal';
LABEL ON COLUMN SMEJIAR1.CCDSC.codigo_sucursal TEXT IS
  'Codigo de Sucursal';

COMMENT ON COLUMN SMEJIAR1.CCDSC.cuenta_contable IS
  'Identificador de la cuenta contable mayor asociada';
LABEL ON COLUMN SMEJIAR1.CCDSC.cuenta_contable IS
  'Cuenta Contable';
LABEL ON COLUMN SMEJIAR1.CCDSC.cuenta_contable TEXT IS
  'Cuenta Contable';

COMMENT ON COLUMN SMEJIAR1.CCDSC.centro_costo IS
  'Codigo o identificador del centro de costo';
LABEL ON COLUMN SMEJIAR1.CCDSC.centro_costo IS
  'Centro Costo';
LABEL ON COLUMN SMEJIAR1.CCDSC.centro_costo TEXT IS
  'Centro de Costo';

COMMENT ON COLUMN SMEJIAR1.CCDSC.observaciones IS
  'Observaciones o comentarios del centro de costo';
LABEL ON COLUMN SMEJIAR1.CCDSC.observaciones IS
  'Observaciones';
LABEL ON COLUMN SMEJIAR1.CCDSC.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN SMEJIAR1.CCDSC.usuario_creacion IS
  'Usuario o proceso que registro la relacion del centro de costo';
LABEL ON COLUMN SMEJIAR1.CCDSC.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN SMEJIAR1.CCDSC.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN SMEJIAR1.CCDSC.usuario_actualizacion IS
  'Usuario o proceso que realizo la ultima actualizacion';
LABEL ON COLUMN SMEJIAR1.CCDSC.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN SMEJIAR1.CCDSC.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN SMEJIAR1.CCDSC.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN SMEJIAR1.CCDSC.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN SMEJIAR1.CCDSC.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN SMEJIAR1.CCDSC.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN SMEJIAR1.CCDSC.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN SMEJIAR1.CCDSC.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN SMEJIAR1.CCDSC.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN SMEJIAR1.CCDSC.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN SMEJIAR1.CCDSC.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN SMEJIAR1.CCDSC.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN SMEJIAR1.CCDSC.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN SMEJIAR1.CCDSC.updated_at TEXT IS
  'Actualizado el';
