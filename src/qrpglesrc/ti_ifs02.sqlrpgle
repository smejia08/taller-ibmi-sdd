**free
ctl-opt main(Main) option(*srcstmt:*nodebugio) bnddir('QC2LE');

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s json varchar(1048576) inz('{"test":"TI_IFS02"}');

  writeTempFile(status: '/GLBTST/output/': 'TI_IFS02.json.tmp': json);
  if status.ok;
    publishFile(status: '/GLBTST/output/': 'TI_IFS02.json.tmp':
                'TI_IFS02.json');
  endif;
  assertInd(status.ok: 'TI_IFS02');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

