**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s parms likeds(RunParms);
  dcl-s cuenta likeds(CuentaFuente);
  dcl-s movs likeds(Movimiento) dim(500);
  dcl-s movCount int(10);

  setParms(parms: '/GLBTST/output/');
  setCuenta(cuenta: '100000': 1000.00);
  loadMovimientos(status: cuenta: parms: movs: movCount);
  assertInd(status.ok and movCount = 2 and
            movs(1).debitoCredito = 'D' and
            movs(2).debitoCredito = 'C': 'TI_DATA04');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

