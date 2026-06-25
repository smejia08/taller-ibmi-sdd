**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *off;
  dispatchReglas(status: '1.0': result);
  assertInd(status.ok and result.estadoConciliacion = 'CONCILIADA':
            'T_RULES11');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

