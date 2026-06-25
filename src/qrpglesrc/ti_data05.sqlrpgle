**free
ctl-opt main(Main) option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes
/include qrpglesrc,t_svc_pr

exec sql set option commit = *none, closqlcsr = *endmod;

dcl-proc Main;
  dcl-pi *n end-pi;
  dcl-s status likeds(OpStatus);
  dcl-s movs likeds(Movimiento) dim(500);

  movs(1).idMovimiento = 'TST150-D';
  movs(1).numeroRegistroRelativo = 1501;
  loadDescripciones(status: movs: 1);
  assertInd(status.ok: 'TI_DATA05');
  *inlr = *on;
end-proc;

/include qrpglesrc,t_assert

