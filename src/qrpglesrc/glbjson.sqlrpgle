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
  dcl-s accountsJson varchar(32740) inz('');
  dcl-s accountsJsonArray sqltype(clob:100000) inz('[]');
  dcl-s itemJson varchar(8192);
  dcl-s incsJson varchar(32740) inz('');
  dcl-s incidentesJsonArray sqltype(clob:100000) inz('[]');
  dcl-s incJson varchar(1024);
  dcl-s timestampStr varchar(26);
  dcl-s inicioStr varchar(26);
  dcl-s finStr varchar(26);
  dcl-s fechaProcesoStr varchar(10);
  dcl-s jsonClob sqltype(clob: 100000);

  dcl-s l_cuentaContable like(CuentaFuente.cuentaContable);
  dcl-s l_incidenteCodigo like(CuentaResultado.incidenteCodigo);
  dcl-s l_incidenteSeveridad like(CuentaResultado.incidenteSeveridad);
  dcl-s l_incidenteMensaje like(CuentaResultado.incidenteMensaje);

  dcl-s l_ambiente like(RunParms.ambiente);
  dcl-s l_idEjecucion like(ExecInfo.idEjecucion);
  dcl-s l_usuario like(ExecInfo.usuario);
  dcl-s l_programa like(ExecInfo.programa);
  dcl-s l_libreria like(ExecInfo.libreria);
  dcl-s l_estado like(ExecInfo.estado);
  dcl-s l_codigoBanco like(RunParms.codigoBanco);
  dcl-s l_codigoSucursal like(RunParms.codigoSucursal);
  dcl-s l_codigoMoneda like(RunParms.codigoMoneda);
  dcl-s l_cuentaDesde like(RunParms.cuentaDesde);
  dcl-s l_cuentaHasta like(RunParms.cuentaHasta);
  dcl-s l_modoEjecucion like(RunParms.modoEjecucion);
  dcl-s l_tolerancia like(RunParms.tolerancia);

  dcl-s l_totalCuentasLeidas like(ControlTotales.totalCuentasLeidas);
  dcl-s l_totalCuentasExportadas like(ControlTotales.totalCuentasExportadas);
  dcl-s l_totalCuentasConDiferencia like(ControlTotales.totalCuentasConDiferencia);
  dcl-s l_totalCuentasConRevision like(ControlTotales.totalCuentasConRevision);
  dcl-s l_sumatoriaSaldoFuente like(ControlTotales.sumatoriaSaldoFuente);
  dcl-s l_sumatoriaSaldoCalculado like(ControlTotales.sumatoriaSaldoCalculado);
  dcl-s l_sumatoriaSaldoConciliado like(ControlTotales.sumatoriaSaldoConciliado);
  dcl-s l_sumatoriaDiferenciaNeta like(ControlTotales.sumatoriaDiferenciaNeta);
  dcl-s l_totalIncidentes like(ControlTotales.totalIncidentes);

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
      accountsJson += %trim(itemJson);
    endif;
  endfor;

  exec sql
   values cast('[' concat :accountsJson concat ']'
          as clob(100000))
   into :accountsJsonArray;

  // Construir arreglo de incidentes
  for i = 1 to cuentaCount;
    if cuentas(i).incidenteCodigo <> '';
      l_cuentaContable = cuentas(i).cuenta.cuentaContable;
      l_incidenteCodigo = cuentas(i).incidenteCodigo;
      l_incidenteSeveridad = cuentas(i).incidenteSeveridad;
      l_incidenteMensaje = cuentas(i).incidenteMensaje;

      exec sql
        values json_object(
          key 'cuenta' value :l_cuentaContable,
          key 'codigo' value :l_incidenteCodigo,
          key 'severidad' value :l_incidenteSeveridad,
          key 'mensaje' value :l_incidenteMensaje
        ) into :incJson;

      if sqlcode = 0;
        if incsJson <> '';
          incsJson += ',';
        endif;
        incsJson += %trim(incJson);
      endif;
    endif;
  endfor;

  exec sql
   values cast('[' concat :incsJson concat ']'
          as clob(100000))
   into :incidentesJsonArray;

  // Ensamblar JSON completo
  l_ambiente = parms.ambiente;
  l_idEjecucion = exec.idEjecucion;
  l_usuario = exec.usuario;
  l_programa = exec.programa;
  l_libreria = exec.libreria;
  l_estado = exec.estado;
  l_codigoBanco = parms.codigoBanco;
  l_codigoSucursal = parms.codigoSucursal;
  l_codigoMoneda = parms.codigoMoneda;
  l_cuentaDesde = parms.cuentaDesde;
  l_cuentaHasta = parms.cuentaHasta;
  l_modoEjecucion = parms.modoEjecucion;
  l_tolerancia = parms.tolerancia;

  l_totalCuentasLeidas = control.totalCuentasLeidas;
  l_totalCuentasExportadas = control.totalCuentasExportadas;
  l_totalCuentasConDiferencia = control.totalCuentasConDiferencia;
  l_totalCuentasConRevision = control.totalCuentasConRevision;
  l_sumatoriaSaldoFuente = control.sumatoriaSaldoFuente;
  l_sumatoriaSaldoCalculado = control.sumatoriaSaldoCalculado;
  l_sumatoriaSaldoConciliado = control.sumatoriaSaldoConciliado;
  l_sumatoriaDiferenciaNeta = control.sumatoriaDiferenciaNeta;
  l_totalIncidentes = control.totalIncidentes;

  exec sql
    values json_object(
      key 'metadata' value json_object(
        key 'nombreProceso' value 'CONCILIACION_GLBLN',
        key 'versionContrato' value '1.0',
        key 'ambiente' value :l_ambiente,
        key 'fechaGeneracion' value :timestampStr
      ) format json,
      key 'ejecucion' value json_object(
        key 'idEjecucion' value :l_idEjecucion,
        key 'usuario' value :l_usuario,
        key 'programa' value :l_programa,
        key 'libreria' value :l_libreria,
        key 'inicio' value :inicioStr,
        key 'fin' value :finStr,
        key 'estado' value :l_estado
      ) format json,
      key 'contexto' value json_object(
        key 'codigoBanco' value :l_codigoBanco,
        key 'codigoSucursal' value :l_codigoSucursal,
        key 'codigoMoneda' value :l_codigoMoneda,
        key 'cuentaDesde' value :l_cuentaDesde,
        key 'cuentaHasta' value :l_cuentaHasta,
        key 'fechaProceso' value :fechaProcesoStr,
        key 'modoEjecucion' value :l_modoEjecucion,
        key 'tolerancia' value :l_tolerancia
      ) format json,
      key 'cuentas' value :accountsJsonArray format json,
      key 'controlTotales' value json_object(
        key 'totalCuentasLeidas' value :l_totalCuentasLeidas,
        key 'totalCuentasExportadas' value :l_totalCuentasExportadas,
        key 'totalCuentasConDiferencia' value :l_totalCuentasConDiferencia,
        key 'totalCuentasConRevision' value :l_totalCuentasConRevision,
        key 'sumatoriaSaldoFuente' value :l_sumatoriaSaldoFuente,
        key 'sumatoriaSaldoCalculado' value :l_sumatoriaSaldoCalculado,
        key 'sumatoriaSaldoConciliado' value :l_sumatoriaSaldoConciliado,
        key 'sumatoriaDiferenciaNeta' value :l_sumatoriaDiferenciaNeta,
        key 'totalIncidentes' value :l_totalIncidentes
      ) format json,
      key 'incidentes' value :incidentesJsonArray format json
    ) into :jsonClob;

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = 'JSN005';
    status.mensaje = 'Error al generar JSON final: SQLCODE ' + %char(sqlcode);
  else;
    json = %trim(jsonClob);
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
  dcl-s jsonClob sqltype(clob:100000);

  jsonClob = json;

  exec sql
    select 1 into :dummy
      from sysibm.sysdummy1
     where json_exists(:jsonClob, '$.metadata' error on error)
       and json_exists(:jsonClob, '$.ejecucion' error on error)
       and json_exists(:jsonClob, '$.contexto' error on error)
       and json_exists(:jsonClob, '$.cuentas' error on error)
       and json_exists(:jsonClob, '$.controlTotales' error on error)
       and json_exists(:jsonClob, '$.incidentes' error on error);

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
  dcl-s dummy sqltype(clob:100000) ccsid(1208);
  dcl-s jsonClob sqltype(clob:100000);

  jsonClob = json;

  exec sql
    values cast(:jsonClob as CLOB(100000) ccsid 1208) into :dummy;

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

  dcl-s l_codigoBanco like(CuentaFuente.codigoBanco);
  dcl-s l_codigoSucursal like(CuentaFuente.codigoSucursal);
  dcl-s l_codigoMoneda like(CuentaFuente.codigoMoneda);
  dcl-s l_cuentaContable like(CuentaFuente.cuentaContable);
  dcl-s l_descripcionCuenta like(CuentaFuente.descripcionCuenta);
  dcl-s l_naturalezaCuenta like(CuentaFuente.naturalezaCuenta);
  dcl-s l_nivelCuenta like(CuentaFuente.nivelCuenta);
  dcl-s l_centroCosto like(CuentaFuente.centroCosto);
  dcl-s l_saldoFuente like(CuentaFuente.saldoFuente);
  dcl-s l_saldoCalculado like(CuentaResultado.saldoCalculado);
  dcl-s l_saldoConciliado like(CuentaResultado.saldoConciliado);
  dcl-s l_diferenciaNeta like(CuentaResultado.diferenciaNeta);
  dcl-s l_totalDebitos like(CuentaResultado.totalDebitos);
  dcl-s l_totalCreditos like(CuentaResultado.totalCreditos);
  dcl-s l_cantidadMovimientos like(CuentaResultado.cantidadMovimientos);
  dcl-s l_estadoFinanciero like(CuentaResultado.estadoFinanciero);
  dcl-s l_estadoConciliacion like(CuentaResultado.estadoConciliacion);

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

  l_codigoBanco = c.cuenta.codigoBanco;
  l_codigoSucursal = c.cuenta.codigoSucursal;
  l_codigoMoneda = c.cuenta.codigoMoneda;
  l_cuentaContable = c.cuenta.cuentaContable;
  l_descripcionCuenta = c.cuenta.descripcionCuenta;
  l_naturalezaCuenta = c.cuenta.naturalezaCuenta;
  l_nivelCuenta = c.cuenta.nivelCuenta;
  l_centroCosto = c.cuenta.centroCosto;
  l_saldoFuente = c.cuenta.saldoFuente;
  l_saldoCalculado = c.saldoCalculado;
  l_saldoConciliado = c.saldoConciliado;
  l_diferenciaNeta = c.diferenciaNeta;
  l_totalDebitos = c.totalDebitos;
  l_totalCreditos = c.totalCreditos;
  l_cantidadMovimientos = c.cantidadMovimientos;
  l_estadoFinanciero = c.estadoFinanciero;
  l_estadoConciliacion = c.estadoConciliacion;

  exec sql
    values json_object(
      key 'identificacion' value json_object(
        key 'codigoBanco' value :l_codigoBanco,
        key 'codigoSucursal' value :l_codigoSucursal,
        key 'codigoMoneda' value :l_codigoMoneda,
        key 'cuentaContable' value :l_cuentaContable
      ) format json,
      key 'datosMaestros' value json_object(
        key 'descripcion' value :l_descripcionCuenta,
        key 'naturaleza' value :l_naturalezaCuenta,
        key 'nivel' value :l_nivelCuenta,
        key 'centroCosto' value :l_centroCosto
      ) format json,
      key 'saldos' value json_object(
        key 'saldoFuente' value :l_saldoFuente,
        key 'saldoCalculado' value :l_saldoCalculado,
        key 'saldoConciliado' value :l_saldoConciliado,
        key 'diferenciaNeta' value :l_diferenciaNeta
      ) format json,
      key 'resumenMovimientos' value json_object(
        key 'debitos' value :l_totalDebitos,
        key 'creditos' value :l_totalCreditos,
        key 'cantidad' value :l_cantidadMovimientos
      ) format json,
      key 'partidasConciliatorias' value json_array() format json,
      key 'estadoFinanciero' value :l_estadoFinanciero,
      key 'estadoConciliacion' value :l_estadoConciliacion,
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
    pIn varchar(4096) const;
  end-pi;
  dcl-s vOut varchar(4096);

  vOut = %scanrpl('\':'\\':%trim(pIn));
  vOut = %scanrpl('"':'\"':vOut);
  vOut = %scanrpl(x'25':' ':vOut);
  return vOut;
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
