**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_rules_pr

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s result likeds(CuentaResultado);

  result.excedeTolerancia = *on;
  result.incidenteSeveridad = 'MEDIA';
  result.cantidadMovimientos = 1;
  clasificaEstado(status: result);
  assertInd(status.ok and result.estadoFinanciero = 'OBSERVADO' and
            result.estadoConciliacion = 'PARCIAL': 'T_RULES08');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

