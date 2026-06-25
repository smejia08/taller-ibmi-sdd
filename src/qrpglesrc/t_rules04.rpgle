**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
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
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

