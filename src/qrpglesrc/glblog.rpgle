**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

dcl-s gLogPath varchar(640);
dcl-s gLogOpen ind inz(*off);

dcl-proc openLog export;
  dcl-pi *n;
    status likeds(OpStatus);
    ruta varchar(500) const;
    nombre varchar(128) const;
    id varchar(20) const;
  end-pi;

  gLogPath = joinPath(ruta: nombre);
  gLogOpen = *on;
  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Log abierto ' + gLogPath;
end-proc;

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

  line = %char(%timestamp():*iso) + '|' + id + '|' + etapa + '|' +
         severidad + '|' + codigo + '|' + mensaje;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = line;
end-proc;

dcl-proc closeLog export;
  dcl-pi *n;
    status likeds(OpStatus);
    id varchar(20) const;
  end-pi;

  gLogOpen = *off;
  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Log cerrado para ' + id;
end-proc;

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
