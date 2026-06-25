**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s parms likeds(RunParms);
  dcl-s exec likeds(ExecInfo);
  dcl-s cuentas likeds(CuentaResultado) dim(1000);
  dcl-s control likeds(ControlTotales);
  dcl-s json varchar(1048576);

  setParms(parms: '/GLBTST/output/');
  setExec(exec: 'TIJSON02': 'PARCIAL');
  setCuenta(cuentas(1).cuenta: '110000': 500.00);
  cuentas(1).saldoCalculado = 800.00;
  cuentas(1).saldoConciliado = 800.00;
  cuentas(1).diferenciaNeta = -300.00;
  cuentas(1).excedeTolerancia = *on;
  cuentas(1).requiereRevision = *on;
  cuentas(1).estadoFinanciero = 'OBSERVADO';
  cuentas(1).estadoConciliacion = 'PARCIAL';
  cuentas(1).incidenteCodigo = 'DIF001';
  cuentas(1).incidenteSeveridad = 'MEDIA';
  cuentas(1).incidenteMensaje = 'Diferencia neta excede tolerancia';
  control.totalCuentasLeidas = 1;
  control.totalCuentasExportadas = 1;
  control.totalCuentasConDiferencia = 1;
  control.totalCuentasConRevision = 1;
  control.sumatoriaSaldoFuente = 500.00;
  control.sumatoriaSaldoCalculado = 800.00;
  control.sumatoriaSaldoConciliado = 800.00;
  control.sumatoriaDiferenciaNeta = -300.00;
  control.totalIncidentes = 1;

  buildJson(status: parms: exec: cuentas: 1: control: json);
  if status.ok;
    validateControlTotales(status: cuentas: 1: control);
  endif;
  assertInd(status.ok and %scan('"DIF001"': json) > 0: 'TI_JSON02');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

