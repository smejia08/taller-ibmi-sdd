**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc TestData01 export;
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
end-proc;

dcl-proc TestData02 export;
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
end-proc;

dcl-proc TestData03 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s parms likeds(RunParms);
  dcl-s cuenta likeds(CuentaFuente);
  dcl-s eof ind inz(*off);

  setParms(parms: '/GLBTST/output/');
  parms.cuentaDesde = '140000';
  parms.cuentaHasta = '140000';
  openCuentaCursor(status: parms);
  fetchCuenta(status: cuenta: eof);
  closeCuentaCursor(status);
  assertInd(status.ok and not eof and cuenta.descripcionCuenta = '':
            'TI_DATA03');
end-proc;

dcl-proc TestData04 export;
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
end-proc;

dcl-proc TestData05 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s movs likeds(Movimiento) dim(500);

  movs(1).idMovimiento = 'TST150-D';
  movs(1).numeroRegistroRelativo = 1501;
  loadDescripciones(status: movs: 1);
  assertInd(status.ok: 'TI_DATA05');
end-proc;

/include qrpglesrc,t_assert
