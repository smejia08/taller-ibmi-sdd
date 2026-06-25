**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

exec sql
  set option commit = *none, closqlcsr = *endmod;

dcl-proc buildJson export;
  dcl-pi *n;
    status likeds(OpStatus);
    parms likeds(RunParms) const;
    exec likeds(ExecInfo) const;
    cuentas likeds(CuentaResultado) dim(1000) const;
    cuentaCount int(10) const;
    control likeds(ControlTotales) const;
    json varchar(1048576);
  end-pi;

  dcl-s i int(10);
  dcl-s accountsJson varchar(1048576) inz('');
  dcl-s accountsJsonArray varchar(1048576) inz('[]');
  dcl-s itemJson varchar(8192);
  dcl-s incsJson varchar(1048576) inz('');
  dcl-s incidentesJsonArray varchar(1048576) inz('[]');
  dcl-s incJson varchar(1024);
  dcl-s timestampStr varchar(26);
  dcl-s inicioStr varchar(26);
  dcl-s finStr varchar(26);
  dcl-s fechaProcesoStr varchar(10);

  timestampStr = %char(%timestamp():*iso);
  inicioStr = %char(exec.inicio:*iso);
  finStr = %char(exec.fin:*iso);
  fechaProcesoStr = %char(parms.fechaProceso:*iso);

  // Construir arreglo de cuentas
  for i = 1 to cuentaCount;
    itemJson = cuentaJson(cuentas(i));
    if itemJson <> '';
      if accountsJson <> '';
        accountsJson += ',';
      endif;
      accountsJson += itemJson;
    endif;
  endfor;
  accountsJsonArray = '[' + accountsJson + ']';

  // Construir arreglo de incidentes
  for i = 1 to cuentaCount;
    if cuentas(i).incidenteCodigo <> '';
      exec sql
        values json_object(
          key 'cuenta' value :cuentas(i).cuenta.cuentaContable,
          key 'codigo' value :cuentas(i).incidenteCodigo,
          key 'severidad' value :cuentas(i).incidenteSeveridad,
          key 'mensaje' value :cuentas(i).incidenteMensaje
        ) into :incJson;

      if sqlcode = 0;
        if incsJson <> '';
          incsJson += ',';
        endif;
        incsJson += incJson;
      endif;
    endif;
  endfor;
  incidentesJsonArray = '[' + incsJson + ']';

  // Ensamblar JSON completo
  exec sql
    values json_object(
      key 'metadata' value json_object(
        key 'nombreProceso' value 'CONCILIACION_GLBLN',
        key 'versionContrato' value '1.0',
        key 'ambiente' value :parms.ambiente,
        key 'fechaGeneracion' value :timestampStr
      ) format json,
      key 'ejecucion' value json_object(
        key 'idEjecucion' value :exec.idEjecucion,
        key 'usuario' value :exec.usuario,
        key 'programa' value :exec.programa,
        key 'libreria' value :exec.libreria,
        key 'inicio' value :inicioStr,
        key 'fin' value :finStr,
        key 'estado' value :exec.estado
      ) format json,
      key 'contexto' value json_object(
        key 'codigoBanco' value :parms.codigoBanco,
        key 'codigoSucursal' value :parms.codigoSucursal,
        key 'codigoMoneda' value :parms.codigoMoneda,
        key 'cuentaDesde' value :parms.cuentaDesde,
        key 'cuentaHasta' value :parms.cuentaHasta,
        key 'fechaProceso' value :fechaProcesoStr,
        key 'modoEjecucion' value :parms.modoEjecucion,
        key 'tolerancia' value :parms.tolerancia
      ) format json,
      key 'cuentas' value :accountsJsonArray format json,
      key 'controlTotales' value json_object(
        key 'totalCuentasLeidas' value :control.totalCuentasLeidas,
        key 'totalCuentasExportadas' value :control.totalCuentasExportadas,
        key 'totalCuentasConDiferencia' value :control.totalCuentasConDiferencia,
        key 'totalCuentasConRevision' value :control.totalCuentasConRevision,
        key 'sumatoriaSaldoFuente' value :control.sumatoriaSaldoFuente,
        key 'sumatoriaSaldoCalculado' value :control.sumatoriaSaldoCalculado,
        key 'sumatoriaSaldoConciliado' value :control.sumatoriaSaldoConciliado,
        key 'sumatoriaDiferenciaNeta' value :control.sumatoriaDiferenciaNeta,
        key 'totalIncidentes' value :control.totalIncidentes
      ) format json,
      key 'incidentes' value :incidentesJsonArray format json
    ) into :json;

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN005';
    status.mensaje = 'Error al generar JSON final: SQLCODE ' + %char(sqlcode);
  else;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'OK';
    status.mensaje = 'JSON construido';
  endif;
end-proc;

dcl-proc validateJsonSyntax export;
  dcl-pi *n;
    status likeds(OpStatus);
    json varchar(1048576) const;
  end-pi;
  dcl-s dummy int(10) inz(0);

  exec sql
    select 1 into :dummy
      from sysibm.sysdummy1
     where json_exists(:json, '$.metadata' error on error)
       and json_exists(:json, '$.ejecucion' error on error)
       and json_exists(:json, '$.contexto' error on error)
       and json_exists(:json, '$.cuentas' error on error)
       and json_exists(:json, '$.controlTotales' error on error)
       and json_exists(:json, '$.incidentes' error on error);

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN001';
    status.mensaje = 'JSON invalido: error de sintaxis SQLCODE ' + %char(sqlcode);
  elseif sqlcode = 100;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN002';
    status.mensaje = 'JSON invalido: faltan secciones obligatorias';
  else;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'OK';
    status.mensaje = 'Sintaxis JSON validada con JSON_EXISTS';
  endif;
end-proc;

dcl-proc validateUtf8 export;
  dcl-pi *n;
    status likeds(OpStatus);
    json varchar(1048576) const;
  end-pi;
  dcl-s dummy varchar(1048576) ccsid(1208);

  exec sql
    values cast(:json as varchar(1048576) ccsid 1208) into :dummy;

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN003';
    status.mensaje = 'Error de conversion a UTF-8 SQLCODE ' + %char(sqlcode);
  else;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'OK';
    status.mensaje = 'Codificacion UTF-8 validada';
  endif;
end-proc;

dcl-proc validateControlTotales export;
  dcl-pi *n;
    status likeds(OpStatus);
    cuentas likeds(CuentaResultado) dim(1000) const;
    cuentaCount int(10) const;
    control likeds(ControlTotales) const;
  end-pi;

  dcl-s i int(10);
  dcl-s calcLeidas int(10) inz(0);
  dcl-s calcExportadas int(10) inz(0);
  dcl-s calcConDiferencia int(10) inz(0);
  dcl-s calcConRevision int(10) inz(0);
  dcl-s calcSaldoFuente packed(18:2) inz(0);
  dcl-s calcSaldoCalculado packed(18:2) inz(0);
  dcl-s calcSaldoConciliado packed(18:2) inz(0);
  dcl-s calcDiferenciaNeta packed(18:2) inz(0);
  dcl-s calcIncidentes int(10) inz(0);

  for i = 1 to cuentaCount;
    calcExportadas += 1;
    if cuentas(i).excedeTolerancia;
      calcConDiferencia += 1;
    endif;
    if cuentas(i).requiereRevision;
      calcConRevision += 1;
    endif;
    if cuentas(i).incidenteCodigo <> '';
      calcIncidentes += 1;
    endif;
    calcSaldoFuente += cuentas(i).cuenta.saldoFuente;
    calcSaldoCalculado += cuentas(i).saldoCalculado;
    calcSaldoConciliado += cuentas(i).saldoConciliado;
    calcDiferenciaNeta += cuentas(i).diferenciaNeta;
  endfor;

  calcLeidas = cuentaCount;

  if control.totalCuentasLeidas <> calcLeidas or
     control.totalCuentasExportadas <> calcExportadas or
     control.totalCuentasConDiferencia <> calcConDiferencia or
     control.totalCuentasConRevision <> calcConRevision or
     control.sumatoriaSaldoFuente <> calcSaldoFuente or
     control.sumatoriaSaldoCalculado <> calcSaldoCalculado or
     control.sumatoriaSaldoConciliado <> calcSaldoConciliado or
     control.sumatoriaDiferenciaNeta <> calcDiferenciaNeta or
     control.totalIncidentes <> calcIncidentes;

    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN010';
    status.mensaje = 'Control de totales recalculado no coincide con controlTotales';
  else;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'OK';
    status.mensaje = 'Control de totales validado exitosamente';
  endif;
end-proc;

dcl-proc cuentaJson;
  dcl-pi *n varchar(8192);
    c likeds(CuentaResultado) const;
  end-pi;
  dcl-s outJson varchar(8192);
  dcl-s flagExcede int(5);
  dcl-s flagRevision int(5);

  if c.excedeTolerancia;
    flagExcede = 1;
  else;
    flagExcede = 0;
  endif;

  if c.requiereRevision;
    flagRevision = 1;
  else;
    flagRevision = 0;
  endif;

  exec sql
    values json_object(
      key 'identificacion' value json_object(
        key 'codigoBanco' value :c.cuenta.codigoBanco,
        key 'codigoSucursal' value :c.cuenta.codigoSucursal,
        key 'codigoMoneda' value :c.cuenta.codigoMoneda,
        key 'cuentaContable' value :c.cuenta.cuentaContable
      ) format json,
      key 'datosMaestros' value json_object(
        key 'descripcion' value :c.cuenta.descripcionCuenta,
        key 'naturaleza' value :c.cuenta.naturalezaCuenta,
        key 'nivel' value :c.cuenta.nivelCuenta,
        key 'centroCosto' value :c.cuenta.centroCosto
      ) format json,
      key 'saldos' value json_object(
        key 'saldoFuente' value :c.cuenta.saldoFuente,
        key 'saldoCalculado' value :c.saldoCalculado,
        key 'saldoConciliado' value :c.saldoConciliado,
        key 'diferenciaNeta' value :c.diferenciaNeta
      ) format json,
      key 'resumenMovimientos' value json_object(
        key 'debitos' value :c.totalDebitos,
        key 'creditos' value :c.totalCreditos,
        key 'cantidad' value :c.cantidadMovimientos
      ) format json,
      key 'partidasConciliatorias' value json_array() format json,
      key 'estadoFinanciero' value :c.estadoFinanciero,
      key 'estadoConciliacion' value :c.estadoConciliacion,
      key 'excedeTolerancia' value case when :flagExcede = 1 then true else false end,
      key 'requiereRevision' value case when :flagRevision = 1 then true else false end,
      key 'trazabilidad' value json_object(
        key 'fuente' value 'GLBLN'
      ) format json
    ) into :outJson;

  if sqlcode < 0;
    return '';
  endif;

  return outJson;
end-proc;

dcl-proc esc;
  dcl-pi *n varchar(4096);
    in varchar(4096) const;
  end-pi;
  dcl-s out varchar(4096);

  out = %scanrpl('\':'\\':%trim(in));
  out = %scanrpl('"':'\"':out);
  out = %scanrpl(x'25':' ':out);
  return out;
end-proc;

dcl-proc num;
  dcl-pi *n varchar(40);
    n packed(18:2) const;
  end-pi;
  return %trim(%char(n));
end-proc;

dcl-proc bool;
  dcl-pi *n varchar(5);
    b ind const;
  end-pi;
  if b;
    return 'true';
  endif;
  return 'false';
end-proc;
