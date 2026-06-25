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
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

