**free
ctl-opt nomain option(*srcstmt:*nodebugio) bnddir('QC2LE');

/include qrpglesrc,glbtypes

dcl-pr access int(10) extproc('access');
  path pointer value options(*string);
  mode int(10) value;
end-pr;

dcl-pr rename int(10) extproc('rename');
  old pointer value options(*string);
  new pointer value options(*string);
end-pr;

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

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Ruta IFS informada';
end-proc;

dcl-proc writeTempFile export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombreTemp varchar(128) const;
    json varchar(1048576) const;
  end-pi;
  dcl-s path varchar(640);

  path = joinPath(ruta: nombreTemp);
  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Archivo temporal escrito ' + path;
end-proc;

dcl-proc publishFile export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombreTemp varchar(128) const;
    nombreFinal varchar(128) const;
  end-pi;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Archivo publicado ' + joinPath(ruta: nombreFinal);
end-proc;

dcl-proc cleanupTempFile export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombreTemp varchar(128) const;
  end-pi;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Archivo temporal limpiado ' + joinPath(ruta: nombreTemp);
end-proc;

dcl-proc joinPath;
  dcl-pi *n varchar(640);
    ruta varchar(500) const;
    nombre varchar(128) const;
  end-pi;

  if %subst(%trimr(ruta):%len(%trimr(ruta)):1) = '/';
    return %trimr(ruta) + %trim(nombre);
  endif;
  return %trimr(ruta) + '/' + %trim(nombre);
end-proc;
