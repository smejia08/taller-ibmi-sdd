**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.diferenciaNeta = 0.00;
  evalTolerancia(status: result: 0.00);
  assertInd(status.ok and not result.excedeTolerancia and
            not result.requiereRevision: 'T_RULES05');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

