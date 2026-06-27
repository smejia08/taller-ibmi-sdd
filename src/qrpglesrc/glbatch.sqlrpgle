**free
ctl-opt option(*srcstmt:*nodebugio)
        bnddir('SMEJIAR1/GLBBNDDIR');

/include qrpglesrc,glbtypes

dcl-pr openLog extproc('openLog');
  status likeds(OpStatus);
  ruta varchar(500) const;
  nombre varchar(128) const;
  id varchar(20) const;
end-pr;

dcl-pr writeEvent extproc('writeEvent');
  status likeds(OpStatus);
  id varchar(20) const;
  etapa varchar(30) const;
  severidad varchar(10) const;
  codigo varchar(20) const;
  mensaje varchar(256) const;
end-pr;

dcl-pr closeLog extproc('closeLog');
  status likeds(OpStatus);
  id varchar(20) const;
end-pr;

dcl-pr openCuentaCursor extproc('openCuentaCursor');
  status likeds(OpStatus);
  parms likeds(RunParms) const;
end-pr;

dcl-pr fetchCuenta extproc('fetchCuenta');
  status likeds(OpStatus);
  cuenta likeds(CuentaFuente);
  eof ind;
end-pr;

dcl-pr closeCuentaCursor extproc('closeCuentaCursor');
  status likeds(OpStatus);
end-pr;

dcl-pr loadMovimientos extproc('loadMovimientos');
  status likeds(OpStatus);
  cuenta likeds(CuentaFuente) const;
  parms likeds(RunParms) const;
  movs likeds(Movimiento) dim(500);
  movCount int(10);
end-pr;

dcl-pr calcSaldoCuenta extproc('calcSaldoCuenta');
  status likeds(OpStatus);
  cuenta likeds(CuentaFuente) const;
  movs likeds(Movimiento) dim(500) const;
  movCount int(10) const;
  result likeds(CuentaResultado);
end-pr;

dcl-pr evalTolerancia extproc('evalTolerancia');
  status likeds(OpStatus);
  result likeds(CuentaResultado);
  tolerancia packed(18:2) const;
end-pr;

dcl-pr dispatchReglas extproc('dispatchReglas');
  status likeds(OpStatus);
  version varchar(10) const;
  result likeds(CuentaResultado);
end-pr;

dcl-pr buildJson extproc('buildJson');
  status likeds(OpStatus);
  parms likeds(RunParms) const;
  exec likeds(ExecInfo) const;
  cuentas likeds(CuentaResultado) dim(1000) const;
  cuentaCount int(10) const;
  control likeds(ControlTotales) const;
  json varchar(1048576);
end-pr;

dcl-pr validateJsonSyntax extproc('validateJsonSyntax');
  status likeds(OpStatus);
  json varchar(1048576) const;
end-pr;

dcl-pr validateUtf8 extproc('validateUtf8');
  status likeds(OpStatus);
  json varchar(1048576) const;
end-pr;

dcl-pr validateControlTotales extproc('validateControlTotales');
  status likeds(OpStatus);
  cuentas likeds(CuentaResultado) dim(1000) const;
  cuentaCount int(10) const;
  control likeds(ControlTotales) const;
end-pr;

dcl-pr validatePath extproc('validatePath');
  status likeds(OpStatus);
  ruta varchar(500) const;
end-pr;

dcl-pr writeTempFile extproc('writeTempFile');
  status likeds(OpStatus);
  ruta varchar(500) const;
  nombreTemp varchar(128) const;
  json varchar(1048576) const;
end-pr;

dcl-pr publishFile extproc('publishFile');
  status likeds(OpStatus);
  ruta varchar(500) const;
  nombreTemp varchar(128) const;
  nombreFinal varchar(128) const;
end-pr;

dcl-pi *n;
  pBanco varchar(10) const;
  pSucursal varchar(10) const;
  pMoneda varchar(10) const;
  pCuentaDesde varchar(30) const;
  pCuentaHasta varchar(30) const;
  pFecha char(10) const;
  pRuta varchar(500) const;
  pModo varchar(12) const;
  pAmbiente varchar(20) const;
  pTolerancia packed(18:2) const;
end-pi;

dcl-ds parms likeds(RunParms);
dcl-ds exec likeds(ExecInfo);
dcl-ds status likeds(OpStatus);
dcl-ds cuenta likeds(CuentaFuente);
dcl-ds movs likeds(Movimiento) dim(500);
dcl-ds result likeds(CuentaResultado);
dcl-ds cuentas likeds(CuentaResultado) dim(1000);
dcl-ds control likeds(ControlTotales);
dcl-s eof ind inz(*off);
dcl-s movCount int(10);
dcl-s cuentaCount int(10) inz(0);
dcl-s json varchar(1048576);
dcl-s tempName varchar(128);

parms.codigoBanco = %trim(pBanco);
parms.codigoSucursal = %trim(pSucursal);
parms.codigoMoneda = %trim(pMoneda);
parms.cuentaDesde = %trim(pCuentaDesde);
parms.cuentaHasta = %trim(pCuentaHasta);
parms.fechaProceso = %date(pFecha:*iso);
parms.rutaIfs = %trim(pRuta);
parms.modoEjecucion = %trim(pModo);
parms.ambiente = %trim(pAmbiente);
parms.tolerancia = pTolerancia;

exec.idEjecucion = %subst(%char(%timestamp():*iso0):1:14);
exec.usuario = '';
exec.programa = 'GLBATCH';
exec.libreria = '*LIBL';
exec.inicio = %timestamp();
exec.estado = 'ERROR';
exec.nombreJson = 'CONCILIACION_GLBLN_' +
                  %subst(exec.idEjecucion:1:8) + '_' +
                  %subst(exec.idEjecucion:9:6) + '_' +
                  exec.idEjecucion + '.json';
exec.nombreLog = 'CONCILIACION_GLBLN_' +
                 %subst(exec.idEjecucion:1:8) + '_' +
                 %subst(exec.idEjecucion:9:6) + '_' +
                 exec.idEjecucion + '.log';
tempName = exec.nombreJson + '.tmp';

openLog(status: parms.rutaIfs: exec.nombreLog: exec.idEjecucion);
writeEvent(status: exec.idEjecucion: 'INICIO': 'BAJA': 'RUN001':
           'Inicio conciliacion GLBLN');

validaParametros(status: parms);
if not status.ok;
  writeEvent(status: exec.idEjecucion: 'VALIDACION_PARAMETROS':
             'CRITICA': status.codigo: status.mensaje);
  *inlr = *on;
  return;
endif;

validatePath(status: parms.rutaIfs);
if not status.ok;
  writeEvent(status: exec.idEjecucion: 'ESCRITURA_IFS':
             'CRITICA': status.codigo: status.mensaje);
  *inlr = *on;
  return;
endif;

openCuentaCursor(status: parms);
if not status.ok;
  writeEvent(status: exec.idEjecucion: 'LECTURA_GLBLN':
             'CRITICA': status.codigo: status.mensaje);
  *inlr = *on;
  return;
endif;

dow not eof and cuentaCount < MAX_CUENTAS;
  fetchCuenta(status: cuenta: eof);
  if not status.ok;
    writeEvent(status: exec.idEjecucion: 'LECTURA_GLBLN':
               status.severidad: status.codigo: status.mensaje);
    leave;
  endif;
  if eof;
    leave;
  endif;

  clear movs;
  loadMovimientos(status: cuenta: parms: movs: movCount);
  calcSaldoCuenta(status: cuenta: movs: movCount: result);
  evalTolerancia(status: result: parms.tolerancia);
  dispatchReglas(status: '1.0': result);

  cuentaCount += 1;
  cuentas(cuentaCount) = result;
  acumulaControl(control: result);
enddo;

closeCuentaCursor(status);
control.totalCuentasLeidas = cuentaCount;
control.totalCuentasExportadas = cuentaCount;

exec.fin = %timestamp();
determinaEstadoFinal(status: control: cuentas: cuentaCount: exec.estado);

buildJson(status: parms: exec: cuentas: cuentaCount: control: json);
if status.ok;
  validateJsonSyntax(status: json);
endif;
if status.ok;
  validateUtf8(status: json);
endif;
if status.ok;
  validateControlTotales(status: cuentas: cuentaCount: control);
endif;
if not status.ok;
  writeEvent(status: exec.idEjecucion: 'VALIDACION_JSON':
             'CRITICA': status.codigo: status.mensaje);
  *inlr = *on;
  return;
endif;

writeTempFile(status: parms.rutaIfs: tempName: json);
if status.ok;
  publishFile(status: parms.rutaIfs: tempName: exec.nombreJson);
endif;

if not status.ok;
  exec.estado = 'ERROR';
  writeEvent(status: exec.idEjecucion: 'ESCRITURA_IFS':
             'CRITICA': status.codigo: status.mensaje);
else;
  writeEvent(status: exec.idEjecucion: 'FIN': 'BAJA': 'RUN999':
             'Fin conciliacion GLBLN estado ' + exec.estado);
endif;

closeLog(status: exec.idEjecucion);
*inlr = *on;
return;

dcl-proc validaParametros;
  dcl-pi *n;
    status likeds(OpStatus);
    parms likeds(RunParms) const;
  end-pi;

  status.ok = *off;
  status.severidad = 'CRITICA';
  status.codigo = 'PAR001';
  status.mensaje = 'Parametro obligatorio invalido';

  if parms.codigoBanco = '' or parms.rutaIfs = '' or
     parms.ambiente = '' or parms.modoEjecucion = '';
    return;
  endif;
  if parms.modoEjecucion <> 'PRUEBA' and
     parms.modoEjecucion <> 'PRODUCTIVO';
    status.codigo = 'PAR002';
    status.mensaje = 'Modo de ejecucion no soportado';
    return;
  endif;
  if parms.tolerancia < 0;
    status.codigo = 'PAR003';
    status.mensaje = 'Tolerancia negativa';
    return;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Parametros validos';
end-proc;

dcl-proc acumulaControl;
  dcl-pi *n;
    control likeds(ControlTotales);
    result likeds(CuentaResultado) const;
  end-pi;

  if result.excedeTolerancia;
    control.totalCuentasConDiferencia += 1;
  endif;
  if result.requiereRevision;
    control.totalCuentasConRevision += 1;
  endif;
  if result.incidenteCodigo <> '';
    control.totalIncidentes += 1;
  endif;

  control.sumatoriaSaldoFuente += result.cuenta.saldoFuente;
  control.sumatoriaSaldoCalculado += result.saldoCalculado;
  control.sumatoriaSaldoConciliado += result.saldoConciliado;
  control.sumatoriaDiferenciaNeta += result.diferenciaNeta;
end-proc;

dcl-proc determinaEstadoFinal;
  dcl-pi *n;
    status likeds(OpStatus);
    control likeds(ControlTotales) const;
    cuentas likeds(CuentaResultado) dim(1000) const;
    cuentaCount int(10) const;
    estado varchar(12);
  end-pi;
  dcl-s i int(10);

  estado = 'FINALIZADO';
  for i = 1 to cuentaCount;
    if cuentas(i).incidenteSeveridad = 'CRITICA';
      estado = 'ERROR';
      leave;
    endif;
    if cuentas(i).incidenteSeveridad = 'ALTA' or
       cuentas(i).requiereRevision;
      estado = 'PARCIAL';
    endif;
  endfor;

  if control.totalCuentasConDiferencia > 0 and estado = 'FINALIZADO';
    estado = 'PARCIAL';
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Estado final determinado';
end-proc;
