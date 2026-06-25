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
  dcl-s count int(10) inz(0);

  setParms(parms: '/GLBTST/output/');
  openCuentaCursor(status: parms);
  dow status.ok and not eof;
    fetchCuenta(status: cuenta: eof);
    if status.ok and not eof;
      count += 1;
    endif;
  enddo;
  closeCuentaCursor(status);
  assertInd(status.ok and count = 8: 'TI_DATA01');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

