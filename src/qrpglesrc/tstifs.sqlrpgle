**free
ctl-opt nomain option(*srcstmt:*nodebugio) bnddir('QC2LE');

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc TestIfs01 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s json varchar(1048576) inz('{"test":"TI_IFS01"}');

  validatePath(status: '/GLBTST/output/');
  if status.ok;
    writeTempFile(status: '/GLBTST/output/': 'TI_IFS01.json.tmp': json);
  endif;
  assertInd(status.ok: 'TI_IFS01');
end-proc;

dcl-proc TestIfs02 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s json varchar(1048576) inz('{"test":"TI_IFS02"}');

  writeTempFile(status: '/GLBTST/output/': 'TI_IFS02.json.tmp': json);
  if status.ok;
    publishFile(status: '/GLBTST/output/': 'TI_IFS02.json.tmp':
                'TI_IFS02.json');
  endif;
  assertInd(status.ok: 'TI_IFS02');
end-proc;

dcl-proc TestIfs03 export;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);

  validatePath(status: '/GLBTST/invalid/');
  assertInd(not status.ok: 'TI_IFS03');
end-proc;

/include qrpglesrc,t_assert
