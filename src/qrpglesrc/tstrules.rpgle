**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc TestRules01 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s cuenta likeds(CuentaFuente);
  dcl-s movs likeds(Movimiento) dim(500);
  dcl-s result likeds(CuentaResultado);

  setCuenta(cuenta: '100000': 1000.00);
  movs(1).debitoCredito = 'D';
  movs(1).monto = 700.00;
  movs(2).debitoCredito = 'C';
  movs(2).monto = 700.00;

  calcSaldoCuenta(status: cuenta: movs: 2: result);
  assertInd(status.ok and result.totalDebitos = 700.00 and
            result.totalCreditos = 700.00 and
            result.saldoCalculado = 1000.00 and
            result.diferenciaNeta = 0.00: 'T_RULES01');
end-proc;

dcl-proc TestRules02 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s cuenta likeds(CuentaFuente);
  dcl-s movs likeds(Movimiento) dim(500);
  dcl-s result likeds(CuentaResultado);

  setCuenta(cuenta: '110000': 500.00);
  movs(1).debitoCredito = 'D';
  movs(1).monto = 300.00;

  calcSaldoCuenta(status: cuenta: movs: 1: result);
  assertInd(status.ok and result.saldoCalculado = 800.00 and
            result.diferenciaNeta = -300.00: 'T_RULES02');
end-proc;

dcl-proc TestRules03 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s cuenta likeds(CuentaFuente);
  dcl-s movs likeds(Movimiento) dim(500);
  dcl-s result likeds(CuentaResultado);

  setCuenta(cuenta: '120000': 250.00);
  calcSaldoCuenta(status: cuenta: movs: 0: result);
  assertInd(status.ok and result.cantidadMovimientos = 0 and
            result.saldoCalculado = 250.00 and
            result.diferenciaNeta = 0.00: 'T_RULES03');
end-proc;

dcl-proc TestRules04 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s cuenta likeds(CuentaFuente);
  dcl-s movs likeds(Movimiento) dim(500);
  dcl-s result likeds(CuentaResultado);

  setCuenta(cuenta: '170000': 100.00);
  movs(1).debitoCredito = 'X';
  movs(1).monto = 50.00;

  calcSaldoCuenta(status: cuenta: movs: 1: result);
  assertInd(not status.ok and status.severidad = 'ALTA' and
            status.codigo = 'RUL001' and
            result.incidenteCodigo = 'RUL001': 'T_RULES04');
end-proc;

dcl-proc TestRules05 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.diferenciaNeta = 0.00;
  evalTolerancia(status: result: 0.00);
  assertInd(status.ok and not result.excedeTolerancia and
            not result.requiereRevision: 'T_RULES05');
end-proc;

dcl-proc TestRules06 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  evalTolerancia(status: result: -5.00);
  assertInd(not status.ok and status.severidad = 'CRITICA' and
            status.codigo = 'RUL010': 'T_RULES06');
end-proc;

dcl-proc TestRules07 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *off;
  result.cantidadMovimientos = 2;
  clasificaEstado(status: result);
  assertInd(status.ok and result.estadoFinanciero = 'NORMAL' and
            result.estadoConciliacion = 'CONCILIADA': 'T_RULES07');
end-proc;

dcl-proc TestRules08 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *on;
  result.incidenteSeveridad = 'MEDIA';
  result.cantidadMovimientos = 1;
  clasificaEstado(status: result);
  assertInd(status.ok and result.estadoFinanciero = 'OBSERVADO' and
            result.estadoConciliacion = 'PARCIAL': 'T_RULES08');
end-proc;

dcl-proc TestRules09 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.incidenteSeveridad = 'CRITICA';
  clasificaEstado(status: result);
  assertInd(status.ok and result.estadoFinanciero = 'CRITICO' and
            result.estadoConciliacion = 'NO_PROCESADA': 'T_RULES09');
end-proc;

dcl-proc TestRules10 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *on;
  buildIncidentesCuenta(status: result);
  assertInd(status.ok and result.incidenteCodigo = 'DIF001' and
            result.incidenteSeveridad = 'MEDIA' and
            result.requiereRevision: 'T_RULES10');
end-proc;

dcl-proc TestRules11 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *off;
  dispatchReglas(status: '1.0': result);
  assertInd(status.ok and result.estadoConciliacion = 'CONCILIADA':
            'T_RULES11');
end-proc;

dcl-proc TestRules12 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  dispatchReglas(status: '2.0': result);
  assertInd(not status.ok and status.severidad = 'CRITICA' and
            status.codigo = 'RUL020': 'T_RULES12');
end-proc;

/include qrpglesrc,t_assert
