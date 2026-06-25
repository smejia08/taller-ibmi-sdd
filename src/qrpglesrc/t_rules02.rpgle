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

  setCuenta(cuenta: '110000': 500.00);
  movs(1).debitoCredito = 'D';
  movs(1).monto = 300.00;

  calcSaldoCuenta(status: cuenta: movs: 1: result);
  assertInd(status.ok and result.saldoCalculado = 800.00 and
            result.diferenciaNeta = -300.00: 'T_RULES02');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

