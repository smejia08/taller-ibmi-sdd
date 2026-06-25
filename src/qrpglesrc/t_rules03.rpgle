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

  setCuenta(cuenta: '120000': 250.00);
  calcSaldoCuenta(status: cuenta: movs: 0: result);
  assertInd(status.ok and result.cantidadMovimientos = 0 and
            result.saldoCalculado = 250.00 and
            result.diferenciaNeta = 0.00: 'T_RULES03');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

