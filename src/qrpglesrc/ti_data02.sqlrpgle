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
  dcl-s eof ind inz(*off);
  dcl-s found ind inz(*off);

  setParms(parms: '/GLBTST/output/');
  parms.cuentaDesde = '100000';
  parms.cuentaHasta = '100000';
  openCuentaCursor(status: parms);
  fetchCuenta(status: cuenta: eof);
  if status.ok and not eof and cuenta.descripcionCuenta <> '';
    found = *on;
  endif;
  closeCuentaCursor(status);
  assertInd(found: 'TI_DATA02');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

