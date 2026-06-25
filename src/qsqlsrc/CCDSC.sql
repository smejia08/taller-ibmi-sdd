--=============================================================================
-- Nombre de la Tabla: CCDSC
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

CREATE OR REPLACE TABLE CCDSC (
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

LABEL ON TABLE CCDSC IS
  'Maestros de Centros de Costos';

COMMENT ON TABLE CCDSC IS
  'Almacena los centros de costos asociados a las cuentas contables.';

COMMENT ON COLUMN CCDSC.codigo_banco IS
  'Codigo identificador de la entidad bancaria';
LABEL ON COLUMN CCDSC.codigo_banco IS
  'Cod. Banco';
LABEL ON COLUMN CCDSC.codigo_banco TEXT IS
  'Codigo de Banco';

COMMENT ON COLUMN CCDSC.codigo_sucursal IS
  'Codigo identificador de la sucursal contable';
LABEL ON COLUMN CCDSC.codigo_sucursal IS
  'Cod. Sucursal';
LABEL ON COLUMN CCDSC.codigo_sucursal TEXT IS
  'Codigo de Sucursal';

COMMENT ON COLUMN CCDSC.cuenta_contable IS
  'Identificador de la cuenta contable mayor asociada';
LABEL ON COLUMN CCDSC.cuenta_contable IS
  'Cuenta Contable';
LABEL ON COLUMN CCDSC.cuenta_contable TEXT IS
  'Cuenta Contable';

COMMENT ON COLUMN CCDSC.centro_costo IS
  'Codigo o identificador del centro de costo';
LABEL ON COLUMN CCDSC.centro_costo IS
  'Centro Costo';
LABEL ON COLUMN CCDSC.centro_costo TEXT IS
  'Centro de Costo';

COMMENT ON COLUMN CCDSC.observaciones IS
  'Observaciones o comentarios del centro de costo';
LABEL ON COLUMN CCDSC.observaciones IS
  'Observaciones';
LABEL ON COLUMN CCDSC.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN CCDSC.usuario_creacion IS
  'Usuario o proceso que registro la relacion del centro de costo';
LABEL ON COLUMN CCDSC.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN CCDSC.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN CCDSC.usuario_actualizacion IS
  'Usuario o proceso que realizo la ultima actualizacion';
LABEL ON COLUMN CCDSC.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN CCDSC.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN CCDSC.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN CCDSC.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN CCDSC.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN CCDSC.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN CCDSC.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN CCDSC.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN CCDSC.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN CCDSC.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN CCDSC.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN CCDSC.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN CCDSC.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN CCDSC.updated_at TEXT IS
  'Actualizado el';
