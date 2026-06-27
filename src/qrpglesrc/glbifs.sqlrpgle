**free
// ============================================================
// GLBIFS - Service Program: Escritura atomica en IFS
// Estrategia: QSYS2.IFS_WRITE_UTF8 + APIs C (access/rename/unlink)
// Nota: Este fuente requiere compilacion como SQLRPGLE en IBM i
// ============================================================
ctl-opt nomain option(*srcstmt:*nodebugio) bnddir('QC2LE');

/include qrpglesrc,glbtypes

exec sql
  set option commit = *none, closqlcsr = *endmod;

// -----------------------------------------------------------
// APIs del sistema de archivos IFS (de QC2LE)
// -----------------------------------------------------------
dcl-pr access int(10) extproc('access');
  path pointer value options(*string);
  mode int(10) value;
end-pr;

dcl-pr rename int(10) extproc('Qp0lRenameKeep');
  old pointer value options(*string);
  new pointer value options(*string);
end-pr;

dcl-pr unlink int(10) extproc('unlink');
  path pointer value options(*string);
end-pr;

// Devuelve un puntero al errno del hilo actual
dcl-pr getErrnoPtr pointer extproc('__errno');
end-pr;

// Devuelve el texto asociado a un errno
dcl-pr strerror pointer extproc('strerror');
   err int(10) value;
end-pr;

// Constantes POSIX para access()
dcl-c F_OK 0;   // Existe
dcl-c W_OK 2;   // Tiene permiso de escritura

// -----------------------------------------------------------
// validatePath: Valida existencia y permiso de escritura en ruta
// -----------------------------------------------------------
dcl-proc validatePath export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
  end-pi;

  if ruta = '';
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'IFS001';
    status.mensaje = 'Ruta IFS obligatoria vacia';
    return;
  endif;

  if access(%trim(ruta): F_OK) < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'IFS002';
    status.mensaje = 'Ruta IFS no existe: ' + %trim(ruta);
    return;
  endif;

  if access(%trim(ruta): W_OK) < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'IFS003';
    status.mensaje = 'Sin permisos de escritura en ruta IFS';
    return;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Ruta IFS validada: ' + %trim(ruta);
end-proc;

// -----------------------------------------------------------
// writeTempFile: Escribe JSON en archivo temporal con IFS_WRITE_UTF8
//   1. Crea/reemplaza con linea vacia (OVERWRITE=REPLACE)
//   2. Escribe el CLOB JSON completo
// -----------------------------------------------------------
dcl-proc writeTempFile export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombreTemp varchar(128) const;
    json varchar(1048576);
  end-pi;
  dcl-s path varchar(640);
  dcl-s jsonClob sqltype(clob:100000);

  jsonClob = json;

  path = joinPath(ruta: nombreTemp);

  // Paso 1: Inicializar archivo (crea o reemplaza)
  exec sql
    call QSYS2.IFS_WRITE_UTF8(
      PATH_NAME => :path,
      LINE => '',
      OVERWRITE => 'REPLACE',
      END_OF_LINE => 'NONE'
    );

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'IFS010';
    status.mensaje = 'Error inicializando archivo temporal '
                     + 'SQLCODE ' + %char(sqlcode);
    return;
  endif;

  // Paso 2: Escribir contenido JSON
  exec sql
    call QSYS2.IFS_WRITE_UTF8(
      PATH_NAME => :path,
      LINE => CAST(:jsonClob AS CLOB(1M))
    );

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'IFS011';
    status.mensaje = 'Error escribiendo JSON en IFS '
                     + 'SQLCODE ' + %char(sqlcode);
    return;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Archivo temporal escrito: ' + path;
end-proc;

// -----------------------------------------------------------
// publishFile: Renombra archivo temporal a nombre final
//   Si el destino ya existe, se elimina primero (atomicidad)
// -----------------------------------------------------------
dcl-proc publishFile export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombreTemp varchar(128) const;
    nombreFinal varchar(128) const;
  end-pi;
  dcl-s pathTemp varchar(640);
  dcl-s pathFinal varchar(640);
  dcl-s pErrno pointer;
  dcl-s errnoValue int(10) based(pErrno);

  dcl-s pErrMsg pointer;
  dcl-s errMsg varchar(256);

  pathTemp  = joinPath(ruta: nombreTemp);
  pathFinal = joinPath(ruta: nombreFinal);

  // Eliminar destino si ya existe (evita error de rename)
  if access(pathFinal: F_OK) = 0;
    unlink(pathFinal);
  endif;

  if rename(pathTemp: pathFinal) < 0;
    pErrno = getErrnoPtr();
    pErrMsg = strerror(errnoValue);

    errMsg = %str(pErrMsg);

    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'IFS020';
    status.mensaje = 'Error al publicar archivo final en IFS' +
                     'errno=' + %char(errnoValue) +
                     ' - ' + %trim(errMsg);
    return;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Archivo publicado: ' + pathFinal;
end-proc;

// -----------------------------------------------------------
// cleanupTempFile: Elimina archivo temporal si todavia existe
// -----------------------------------------------------------
dcl-proc cleanupTempFile export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombreTemp varchar(128) const;
  end-pi;
  dcl-s pathTemp varchar(640);

  pathTemp = joinPath(ruta: nombreTemp);

  if access(pathTemp: F_OK) = 0;
    if unlink(pathTemp) < 0;
      status.ok = *off;
      status.severidad = 'MEDIA';
      status.codigo = 'IFS030';
      status.mensaje = 'No se pudo eliminar temporal: ' + pathTemp;
      return;
    endif;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Archivo temporal limpiado';
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
