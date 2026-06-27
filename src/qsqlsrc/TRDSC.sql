--=============================================================================
-- Nombre de la Tabla: SMEJIAR1.TRDSC
-- DESCRIPCIÓN: Descripciones Adicionales a las Transacciones (TRANS)
-- Objetivo: Almacenar textos y conceptos adicionales de las transacciones.
-- Tipo de Tabla: Detalle / Catálogo
-- Origen de los Datos: Módulo de Transacciones
-- Permanencia de Datos: Permanente
-- Uso de los datos: Normalización de conceptos en movimientos contables
-- Restricciones: Relación externa con TRANS y clave primaria compuesta.
-- Hecho por: Antigravity
-- Fecha: 2026-06-24
-- Proyecto: Taller IBM i - Conciliación
--=============================================================================
DROP TABLE IF EXISTS SMEJIAR1.TRDSC;

CREATE OR REPLACE TABLE SMEJIAR1.TRDSC (
  numero_registro_relativo FOR COLUMN NUMRRN VARCHAR(30) NOT NULL,
  secuencia FOR COLUMN SECUEN INT NOT NULL,
  tipo_movimiento FOR COLUMN TIPMOV VARCHAR(20),
  tipo_descripcion FOR COLUMN TIPDSC VARCHAR(20),
  texto_descripcion FOR COLUMN TEXDSC VARCHAR(200),
  codigo_idioma FOR COLUMN CODIDI VARCHAR(5),
  formato_salida FOR COLUMN FORSAL VARCHAR(20),
  obligatorio FOR COLUMN FLGOBL BOOLEAN,
  observaciones FOR COLUMN OBSREG VARCHAR(120),
  usuario_creacion FOR COLUMN USRCRE VARCHAR(30),
  usuario_actualizacion FOR COLUMN USRACT VARCHAR(30),
  version_registro FOR COLUMN VERREG INT,
  estado_registro FOR COLUMN ESTREG CHAR(1),
  created_at FOR COLUMN CRTAT TIMESTAMP,
  updated_at FOR COLUMN UPDAT TIMESTAMP,
  CONSTRAINT pk_trdsc PRIMARY KEY (numero_registro_relativo, secuencia)
)
RCDFMT RTRDSC;

LABEL ON TABLE SMEJIAR1.TRDSC IS
  'Descripciones Adicionales a Transacciones';

COMMENT ON TABLE SMEJIAR1.TRDSC IS
  'Textos adicionales para enriquecer las transacciones.';

COMMENT ON COLUMN SMEJIAR1.TRDSC.numero_registro_relativo IS
  'Numero de registro relativo origen (RRN)';
LABEL ON COLUMN SMEJIAR1.TRDSC.numero_registro_relativo IS
  'Num. Registro Rel';
LABEL ON COLUMN SMEJIAR1.TRDSC.numero_registro_relativo TEXT IS
  'Numero de Registro Relativo';

COMMENT ON COLUMN SMEJIAR1.TRDSC.secuencia IS
  'Secuencia de la descripcion adicional para el mismo RRN';
LABEL ON COLUMN SMEJIAR1.TRDSC.secuencia IS
  'Secuencia Desc.';
LABEL ON COLUMN SMEJIAR1.TRDSC.secuencia TEXT IS
  'Secuencia';

COMMENT ON COLUMN SMEJIAR1.TRDSC.tipo_movimiento IS
  'Tipo de movimiento asociado a la descripcion';
LABEL ON COLUMN SMEJIAR1.TRDSC.tipo_movimiento IS
  'Tipo Movimiento';
LABEL ON COLUMN SMEJIAR1.TRDSC.tipo_movimiento TEXT IS
  'Tipo de Movimiento';

COMMENT ON COLUMN SMEJIAR1.TRDSC.tipo_descripcion IS
  'Tipo de descripcion adicional (Concepto, Detalle, etc)';
LABEL ON COLUMN SMEJIAR1.TRDSC.tipo_descripcion IS
  'Tipo Descrip.';
LABEL ON COLUMN SMEJIAR1.TRDSC.tipo_descripcion TEXT IS
  'Tipo de Descripcion';

COMMENT ON COLUMN SMEJIAR1.TRDSC.texto_descripcion IS
  'Texto descriptivo largo o concepto del movimiento';
LABEL ON COLUMN SMEJIAR1.TRDSC.texto_descripcion IS
  'Concepto Trans.';
LABEL ON COLUMN SMEJIAR1.TRDSC.texto_descripcion TEXT IS
  'Concepto';

COMMENT ON COLUMN SMEJIAR1.TRDSC.codigo_idioma IS
  'Codigo del idioma de la descripcion (ES, EN, etc)';
LABEL ON COLUMN SMEJIAR1.TRDSC.codigo_idioma IS
  'Cod. Idioma';
LABEL ON COLUMN SMEJIAR1.TRDSC.codigo_idioma TEXT IS
  'Codigo de Idioma';

COMMENT ON COLUMN SMEJIAR1.TRDSC.formato_salida IS
  'Formato de salida esperado para el texto';
LABEL ON COLUMN SMEJIAR1.TRDSC.formato_salida IS
  'Formato Salida';
LABEL ON COLUMN SMEJIAR1.TRDSC.formato_salida TEXT IS
  'Formato de Salida';

COMMENT ON COLUMN SMEJIAR1.TRDSC.obligatorio IS
  'Indicador de obligatoriedad del texto (true/false)';
LABEL ON COLUMN SMEJIAR1.TRDSC.obligatorio IS
  'Flag Obligatorio';
LABEL ON COLUMN SMEJIAR1.TRDSC.obligatorio TEXT IS
  'Es Obligatorio';

COMMENT ON COLUMN SMEJIAR1.TRDSC.observaciones IS
  'Observaciones generales sobre el texto';
LABEL ON COLUMN SMEJIAR1.TRDSC.observaciones IS
  'Observaciones';
LABEL ON COLUMN SMEJIAR1.TRDSC.observaciones TEXT IS
  'Observaciones';

COMMENT ON COLUMN SMEJIAR1.TRDSC.usuario_creacion IS
  'Usuario o proceso que registro la descripcion';
LABEL ON COLUMN SMEJIAR1.TRDSC.usuario_creacion IS
  'Usuario Creac.';
LABEL ON COLUMN SMEJIAR1.TRDSC.usuario_creacion TEXT IS
  'Usuario de Creacion';

COMMENT ON COLUMN SMEJIAR1.TRDSC.usuario_actualizacion IS
  'Usuario o proceso que realizo la ultima actualizacion';
LABEL ON COLUMN SMEJIAR1.TRDSC.usuario_actualizacion IS
  'Usuario Act.';
LABEL ON COLUMN SMEJIAR1.TRDSC.usuario_actualizacion TEXT IS
  'Usuario de Actualizacion';

COMMENT ON COLUMN SMEJIAR1.TRDSC.version_registro IS
  'Numero secuencial de version del registro para concurrencia';
LABEL ON COLUMN SMEJIAR1.TRDSC.version_registro IS
  'Ver. Registro';
LABEL ON COLUMN SMEJIAR1.TRDSC.version_registro TEXT IS
  'Version de Registro';

COMMENT ON COLUMN SMEJIAR1.TRDSC.estado_registro IS
  'Estado del registro (A Activo, I Inactivo)';
LABEL ON COLUMN SMEJIAR1.TRDSC.estado_registro IS
  'Est. Registro';
LABEL ON COLUMN SMEJIAR1.TRDSC.estado_registro TEXT IS
  'Estado de Registro';

COMMENT ON COLUMN SMEJIAR1.TRDSC.created_at IS
  'Marca de tiempo de creacion del registro en la base de datos';
LABEL ON COLUMN SMEJIAR1.TRDSC.created_at IS
  'Fecha Creacion';
LABEL ON COLUMN SMEJIAR1.TRDSC.created_at TEXT IS
  'Creado el';

COMMENT ON COLUMN SMEJIAR1.TRDSC.updated_at IS
  'Marca de tiempo de la ultima modificacion del registro';
LABEL ON COLUMN SMEJIAR1.TRDSC.updated_at IS
  'Fecha Actualiz.';
LABEL ON COLUMN SMEJIAR1.TRDSC.updated_at TEXT IS
  'Actualizado el';
