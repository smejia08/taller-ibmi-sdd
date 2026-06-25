**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *on;
  buildIncidentesCuenta(status: result);
  assertInd(status.ok and result.incidenteCodigo = 'DIF001' and
            result.incidenteSeveridad = 'MEDIA' and
            result.requiereRevision: 'T_RULES10');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

