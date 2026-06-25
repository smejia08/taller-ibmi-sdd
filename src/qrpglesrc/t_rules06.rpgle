**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  evalTolerancia(status: result: -5.00);
  assertInd(not status.ok and status.severidad = 'CRITICA' and
            status.codigo = 'RUL010': 'T_RULES06');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

