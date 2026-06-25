**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.incidenteSeveridad = 'CRITICA';
  clasificaEstado(status: result);
  assertInd(status.ok and result.estadoFinanciero = 'CRITICO' and
            result.estadoConciliacion = 'NO_PROCESADA': 'T_RULES09');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

