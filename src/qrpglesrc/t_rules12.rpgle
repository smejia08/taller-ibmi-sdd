**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  dispatchReglas(status: '2.0': result);
  assertInd(not status.ok and status.severidad = 'CRITICA' and
            status.codigo = 'RUL020': 'T_RULES12');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

