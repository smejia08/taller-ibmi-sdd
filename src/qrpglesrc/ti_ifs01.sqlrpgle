**free
ctl-opt main(Main) option(*srcstmt:*nodebugio) bnddir('QC2LE');

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s json varchar(1048576) inz('{"test":"TI_IFS01"}');

  validatePath(status: '/GLBTST/output/');
  if status.ok;
    writeTempFile(status: '/GLBTST/output/': 'TI_IFS01.json.tmp': json);
  endif;
  assertInd(status.ok: 'TI_IFS01');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

