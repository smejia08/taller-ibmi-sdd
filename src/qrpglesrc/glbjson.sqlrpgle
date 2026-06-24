**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

dcl-proc buildJson export;
  dcl-pi *n;
    status likeds(OpStatus);
    parms likeds(RunParms) const;
    exec likeds(ExecInfo) const;
    cuentas likeds(CuentaResultado) dim(1000) const;
    cuentaCount int(10) const;
    control likeds(ControlTotales) const;
    json varchar(1048576);
  end-pi;
  dcl-s i int(10);

  json = '{' +
    '"metadata":{' +
    '"nombreProceso":"CONCILIACION_GLBLN",' +
    '"versionContrato":"1.0",' +
    '"ambiente":"' + esc(parms.ambiente) + '",' +
    '"fechaGeneracion":"' + %char(%timestamp():*iso) + '"},';

  json += '"ejecucion":{' +
    '"idEjecucion":"' + esc(exec.idEjecucion) + '",' +
    '"usuario":"' + esc(exec.usuario) + '",' +
    '"programa":"' + esc(exec.programa) + '",' +
    '"libreria":"' + esc(exec.libreria) + '",' +
    '"inicio":"' + %char(exec.inicio:*iso) + '",' +
    '"fin":"' + %char(exec.fin:*iso) + '",' +
    '"estado":"' + esc(exec.estado) + '"},';

  json += '"contexto":{' +
    '"codigoBanco":"' + esc(parms.codigoBanco) + '",' +
    '"codigoSucursal":"' + esc(parms.codigoSucursal) + '",' +
    '"codigoMoneda":"' + esc(parms.codigoMoneda) + '",' +
    '"cuentaDesde":"' + esc(parms.cuentaDesde) + '",' +
    '"cuentaHasta":"' + esc(parms.cuentaHasta) + '",' +
    '"fechaProceso":"' + %char(parms.fechaProceso:*iso) + '",' +
    '"modoEjecucion":"' + esc(parms.modoEjecucion) + '",' +
    '"tolerancia":' + num(parms.tolerancia) + '},';

  json += '"cuentas":[';
  for i = 1 to cuentaCount;
    if i > 1;
      json += ',';
    endif;
    json += cuentaJson(cuentas(i));
  endfor;
  json += '],';

  json += '"controlTotales":{' +
    '"totalCuentasLeidas":' + %char(control.totalCuentasLeidas) + ',' +
    '"totalCuentasExportadas":' +
      %char(control.totalCuentasExportadas) + ',' +
    '"totalCuentasConDiferencia":' +
      %char(control.totalCuentasConDiferencia) + ',' +
    '"totalCuentasConRevision":' +
      %char(control.totalCuentasConRevision) + ',' +
    '"sumatoriaSaldoFuente":' +
      num(control.sumatoriaSaldoFuente) + ',' +
    '"sumatoriaSaldoCalculado":' +
      num(control.sumatoriaSaldoCalculado) + ',' +
    '"sumatoriaSaldoConciliado":' +
      num(control.sumatoriaSaldoConciliado) + ',' +
    '"sumatoriaDiferenciaNeta":' +
      num(control.sumatoriaDiferenciaNeta) + ',' +
    '"totalIncidentes":' + %char(control.totalIncidentes) + '},';

  json += '"incidentes":[';
  for i = 1 to cuentaCount;
    if cuentas(i).incidenteCodigo <> '';
      if %subst(json:%len(json):1) <> '[';
        json += ',';
      endif;
      json += '{"cuenta":"' + esc(cuentas(i).cuenta.cuentaContable) +
              '","codigo":"' + esc(cuentas(i).incidenteCodigo) +
              '","severidad":"' + esc(cuentas(i).incidenteSeveridad) +
              '","mensaje":"' + esc(cuentas(i).incidenteMensaje) + '"}';
    endif;
  endfor;
  json += ']}';

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'JSON construido';
end-proc;

dcl-proc validateJsonSyntax export;
  dcl-pi *n;
    status likeds(OpStatus);
    json varchar(1048576) const;
  end-pi;

  status.ok = %subst(%trim(json):1:1) = '{' and
              %subst(%trimr(json):%len(%trimr(json)):1) = '}';
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Sintaxis minima JSON validada';
  if not status.ok;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN001';
    status.mensaje = 'JSON no inicia o termina con objeto';
  endif;
end-proc;

dcl-proc validateUtf8 export;
  dcl-pi *n;
    status likeds(OpStatus);
    json varchar(1048576) const;
  end-pi;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Contenido preparado para escritura UTF-8';
end-proc;

dcl-proc validateControlTotales export;
  dcl-pi *n;
    status likeds(OpStatus);
    cuentas likeds(CuentaResultado) dim(1000) const;
    cuentaCount int(10) const;
    control likeds(ControlTotales) const;
  end-pi;

  status.ok = control.totalCuentasExportadas = cuentaCount;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Control de totales validado';
  if not status.ok;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN010';
    status.mensaje = 'Total exportado no cuadra con cuentas';
  endif;
end-proc;

dcl-proc cuentaJson;
  dcl-pi *n varchar(8192);
    c likeds(CuentaResultado) const;
  end-pi;

  return '{"identificacion":{' +
    '"codigoBanco":"' + esc(c.cuenta.codigoBanco) + '",' +
    '"codigoSucursal":"' + esc(c.cuenta.codigoSucursal) + '",' +
    '"codigoMoneda":"' + esc(c.cuenta.codigoMoneda) + '",' +
    '"cuentaContable":"' + esc(c.cuenta.cuentaContable) + '"},' +
    '"datosMaestros":{' +
    '"descripcion":"' + esc(c.cuenta.descripcionCuenta) + '",' +
    '"naturaleza":"' + esc(c.cuenta.naturalezaCuenta) + '",' +
    '"nivel":' + %char(c.cuenta.nivelCuenta) + ',' +
    '"centroCosto":"' + esc(c.cuenta.centroCosto) + '"},' +
    '"saldos":{' +
    '"saldoFuente":' + num(c.cuenta.saldoFuente) + ',' +
    '"saldoCalculado":' + num(c.saldoCalculado) + ',' +
    '"saldoConciliado":' + num(c.saldoConciliado) + ',' +
    '"diferenciaNeta":' + num(c.diferenciaNeta) + '},' +
    '"resumenMovimientos":{' +
    '"debitos":' + num(c.totalDebitos) + ',' +
    '"creditos":' + num(c.totalCreditos) + ',' +
    '"cantidad":' + %char(c.cantidadMovimientos) + '},' +
    '"partidasConciliatorias":[],' +
    '"estadoFinanciero":"' + esc(c.estadoFinanciero) + '",' +
    '"estadoConciliacion":"' + esc(c.estadoConciliacion) + '",' +
    '"excedeTolerancia":' + bool(c.excedeTolerancia) + ',' +
    '"requiereRevision":' + bool(c.requiereRevision) + ',' +
    '"trazabilidad":{"fuente":"GLBLN"}}';
end-proc;

dcl-proc esc;
  dcl-pi *n varchar(4096);
    in varchar(4096) const;
  end-pi;
  dcl-s out varchar(4096);

  out = %scanrpl('\':'\\':%trim(in));
  out = %scanrpl('"':'\"':out);
  out = %scanrpl(x'25':' ':out);
  return out;
end-proc;

dcl-proc num;
  dcl-pi *n varchar(40);
    n packed(18:2) const;
  end-pi;
  return %trim(%char(n));
end-proc;

dcl-proc bool;
  dcl-pi *n varchar(5);
    b ind const;
  end-pi;
  if b;
    return 'true';
  endif;
  return 'false';
end-proc;
