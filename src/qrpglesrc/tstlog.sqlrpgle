**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc TestLog01 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);

  openLog(status: '/GLBTST/logs/': 'TI_LOG01.log': 'TST001');
  if status.ok;
    writeEvent(status: 'TST001': 'INICIO': 'BAJA': 'LOGT01': 'Inicio');
  endif;
  if status.ok;
    writeEvent(status: 'TST001': 'ETAPA_DATOS': 'BAJA': 'LOGT02':
               'Datos');
  endif;
  if status.ok;
    writeEvent(status: 'TST001': 'FIN': 'BAJA': 'LOGT03': 'Fin');
  endif;
  if status.ok;
    closeLog(status: 'TST001');
  endif;
  assertInd(status.ok: 'TI_LOG01');
end-proc;

/include qrpglesrc,t_assert
