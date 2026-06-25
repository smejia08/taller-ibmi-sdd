**free
// ============================================================
// GLBLOG - Service Program: Bitacora TXT normalizada en IFS
// Estrategia: QSYS2.IFS_WRITE_UTF8 en modo APPEND / REPLACE
// Formato de linea: timestamp|idEjecucion|etapa|severidad|codigo|mensaje
// Nota: Este fuente requiere compilacion como SQLRPGLE en IBM i
// ============================================================
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

exec sql
  set option commit = *none, closqlcsr = *endmod;

// Variables globales del modulo
dcl-s gLogPath varchar(640);
dcl-s gLogOpen ind inz(*off);

// -----------------------------------------------------------
// openLog: Inicializa el archivo de bitacora en IFS
//   Crea o reemplaza el archivo .log en modo REPLACE
// -----------------------------------------------------------
dcl-proc openLog export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombre varchar(128) const;
    id varchar(20) const;
  end-pi;

  gLogPath = joinPath(ruta: nombre);

  // Inicializar archivo: crear o reemplazar
  exec sql
    call QSYS2.IFS_WRITE_UTF8(
      PATH_NAME => :gLogPath,
      LINE => '',
      OVERWRITE => 'REPLACE',
      END_OF_LINE => 'NONE'
    );

  if sqlcode < 0;
    gLogOpen = *off;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'LOG000';
    status.mensaje = 'Error al crear bitacora en IFS '
                     + 'SQLCODE ' + %char(sqlcode);
    return;
  endif;

  gLogOpen = *on;
  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Log abierto: ' + gLogPath;
end-proc;

// -----------------------------------------------------------
// writeEvent: Registra una linea normalizada en la bitacora
//   Formato: timestamp|idEjecucion|etapa|severidad|codigo|mensaje
//   Escribe en modo APPEND con END_OF_LINE = CRLF
// -----------------------------------------------------------
dcl-proc writeEvent export;
  dcl-pi *n;
    status likeds(OpStatus);
    id varchar(20) const;
    etapa varchar(30) const;
    severidad varchar(10) const;
    codigo varchar(20) const;
    mensaje varchar(256) const;
  end-pi;
  dcl-s line varchar(512);

  if not gLogOpen;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'LOG001';
    status.mensaje = 'Log no abierto';
    return;
  endif;

  // Construir linea normalizada
  line = %char(%timestamp():*iso) + '|' + %trim(id) + '|'
       + %trim(etapa) + '|' + %trim(severidad) + '|'
       + %trim(codigo) + '|' + %trim(mensaje);

  // Grabar en IFS en modo APPEND con salto de linea CRLF
  exec sql
    call QSYS2.IFS_WRITE_UTF8(
      PATH_NAME => :gLogPath,
      LINE => :line,
      OVERWRITE => 'APPEND',
      END_OF_LINE => 'CRLF'
    );

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'ALTA';
    status.codigo = 'LOG002';
    status.mensaje = 'Error al escribir evento en bitacora '
                     + 'SQLCODE ' + %char(sqlcode);
    return;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = line;
end-proc;

// -----------------------------------------------------------
// closeLog: Cierra logicamente la bitacora
// -----------------------------------------------------------
dcl-proc closeLog export;
  dcl-pi *n;
    status likeds(OpStatus);
    id varchar(20) const;
  end-pi;

  gLogOpen = *off;
  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Log cerrado para ejecucion ' + %trim(id);
end-proc;

// -----------------------------------------------------------
// joinPath: Combina ruta base y nombre de archivo
// -----------------------------------------------------------
dcl-proc joinPath;
  dcl-pi *n varchar(640);
    ruta varchar(500) const;
    nombre varchar(128) const;
  end-pi;

  if ruta <> '' and %subst(%trimr(ruta):%len(%trimr(ruta)):1) = '/';
    return %trimr(ruta) + %trim(nombre);
  endif;
  return %trimr(ruta) + '/' + %trim(nombre);
end-proc;
