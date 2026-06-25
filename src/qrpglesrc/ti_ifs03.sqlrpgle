**free
ctl-opt main(Main) option(*srcstmt:*nodebugio) bnddir('QC2LE');

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);

  validatePath(status: '/GLBTST/invalid/');
  assertInd(not status.ok: 'TI_IFS03');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

