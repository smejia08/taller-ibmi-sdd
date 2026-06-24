**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

dcl-proc calcSaldoCuenta export;
  dcl-pi *n;
    status likeds(OpStatus);
    cuenta likeds(CuentaFuente) const;
    movs likeds(Movimiento) dim(500) const;
    movCount int(10) const;
    result likeds(CuentaResultado);
  end-pi;
  dcl-s i int(10);

  clear result;
  result.cuenta = cuenta;
  result.saldoCalculado = cuenta.saldoFuente;
  result.saldoConciliado = cuenta.saldoFuente;

  for i = 1 to movCount;
    select;
    when movs(i).debitoCredito = 'D';
      result.totalDebitos += movs(i).monto;
      result.saldoCalculado += movs(i).monto;
    when movs(i).debitoCredito = 'C';
      result.totalCreditos += movs(i).monto;
      result.saldoCalculado -= movs(i).monto;
    other;
      status.ok = *off;
      status.severidad = 'ALTA';
      status.codigo = 'RUL001';
      status.mensaje = 'Movimiento con debito_credito invalido';
      result.incidenteCodigo = status.codigo;
      result.incidenteSeveridad = status.severidad;
      result.incidenteMensaje = status.mensaje;
      return;
    endsl;
  endfor;

  result.cantidadMovimientos = movCount;
  result.saldoConciliado = result.saldoCalculado;
  result.diferenciaNeta = result.cuenta.saldoFuente - result.saldoConciliado;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Saldo calculado';
end-proc;

dcl-proc evalTolerancia export;
  dcl-pi *n;
    status likeds(OpStatus);
    result likeds(CuentaResultado);
    tolerancia packed(18:2) const;
  end-pi;

  if tolerancia < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'RUL010';
    status.mensaje = 'Tolerancia negativa';
    return;
  endif;

  result.excedeTolerancia = %abs(result.diferenciaNeta) > tolerancia;
  result.requiereRevision = result.excedeTolerancia or
                            result.incidenteCodigo <> '';

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Tolerancia evaluada';
end-proc;

dcl-proc dispatchReglas export;
  dcl-pi *n;
    status likeds(OpStatus);
    version varchar(10) const;
    result likeds(CuentaResultado);
  end-pi;

  if version <> '1.0';
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'RUL020';
    status.mensaje = 'Version de reglas no soportada';
    return;
  endif;

  clasificaEstado(status: result);
  if status.ok;
    buildIncidentesCuenta(status: result);
  endif;
end-proc;

dcl-proc clasificaEstado export;
  dcl-pi *n;
    status likeds(OpStatus);
    result likeds(CuentaResultado);
  end-pi;

  if result.incidenteSeveridad = 'CRITICA';
    result.estadoFinanciero = 'CRITICO';
    result.estadoConciliacion = 'NO_PROCESADA';
  elseif result.excedeTolerancia;
    result.estadoFinanciero = 'OBSERVADO';
    if result.cantidadMovimientos > 0;
      result.estadoConciliacion = 'PARCIAL';
    else;
      result.estadoConciliacion = 'NO_CONCILIADA';
    endif;
  else;
    result.estadoFinanciero = 'NORMAL';
    result.estadoConciliacion = 'CONCILIADA';
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Estado clasificado';
end-proc;

dcl-proc buildIncidentesCuenta export;
  dcl-pi *n;
    status likeds(OpStatus);
    result likeds(CuentaResultado);
  end-pi;

  if result.excedeTolerancia and result.incidenteCodigo = '';
    result.incidenteCodigo = 'DIF001';
    result.incidenteSeveridad = 'MEDIA';
    result.incidenteMensaje = 'Diferencia neta excede tolerancia';
    result.requiereRevision = *on;
  endif;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'OK';
  status.mensaje = 'Incidentes evaluados';
end-proc;
