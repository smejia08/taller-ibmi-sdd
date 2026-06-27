**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

exec sql
  set option commit = *none, closqlcsr = *endactgrp;  

dcl-s gOpen ind inz(*off);

dcl-proc openCuentaCursor export;
  dcl-pi *n;
    status likeds(OpStatus);
    parms likeds(RunParms) const;
  end-pi;

  dcl-s codigoBanco like(RunParms.codigoBanco);
  dcl-s codigoSucursal like(RunParms.codigoSucursal);
  dcl-s codigoMoneda like(RunParms.codigoMoneda);
  dcl-s cuentaDesde like(RunParms.cuentaDesde);
  dcl-s cuentaHasta like(RunParms.cuentaHasta);
  dcl-s fechaProceso like(RunParms.fechaProceso);

  exec sql
    declare C_GLBLN cursor for
      select codigo_banco,
             codigo_sucursal,
             codigo_moneda,
             cuenta_contable,
             descripcion_cuenta,
             naturaleza_cuenta,
             nivel_cuenta,
             centro_costo,
             saldo_actual,
             fecha_proceso_sistema
        from V_GLBLN_CTX
       where codigo_banco = :codigoBanco
         and (:codigoSucursal = ''
              or codigo_sucursal = :codigoSucursal)
         and (:codigoMoneda = ''
              or codigo_moneda = :codigoMoneda)
         and (:cuentaDesde = ''
              or cuenta_contable >= :cuentaDesde)
         and (:cuentaHasta = ''
              or cuenta_contable <= :cuentaHasta)
         and fecha_proceso_sistema <= :fechaProceso
       order by codigo_banco,
                codigo_sucursal,
                codigo_moneda,
                cuenta_contable;

  codigoBanco = parms.codigoBanco;
  codigoSucursal = parms.codigoSucursal;
  codigoMoneda = parms.codigoMoneda;
  cuentaDesde = parms.cuentaDesde;
  cuentaHasta = parms.cuentaHasta;
  fechaProceso = parms.fechaProceso;

  exec sql open C_GLBLN;
  setStatusSql(status: 'DAT001': 'Cursor GLBLN abierto');
  gOpen = status.ok;
end-proc;

dcl-proc fetchCuenta export;
  dcl-pi *n;
    status likeds(OpStatus);
    cuenta likeds(CuentaFuente);
    eof ind;
  end-pi;

  dcl-s codigoBanco like(CuentaFuente.codigoBanco);
  dcl-s codigoSucursal like(CuentaFuente.codigoSucursal);
  dcl-s codigoMoneda like(CuentaFuente.codigoMoneda);
  dcl-s cuentaContable like(CuentaFuente.cuentaContable);
  dcl-s descripcionCuenta like(CuentaFuente.descripcionCuenta);
  dcl-s naturalezaCuenta like(CuentaFuente.naturalezaCuenta);
  dcl-s nivelCuenta like(CuentaFuente.nivelCuenta);
  dcl-s centroCosto like(CuentaFuente.centroCosto);
  dcl-s saldoFuente like(CuentaFuente.saldoFuente);
  dcl-s fechaProcesoSistema like(CuentaFuente.fechaProcesoSistema);

  eof = *off;
  clear cuenta;

  exec sql
    fetch C_GLBLN
      into :codigoBanco,
           :codigoSucursal,
           :codigoMoneda,
           :cuentaContable,
           :descripcionCuenta,
           :naturalezaCuenta,
           :nivelCuenta,
           :centroCosto,
           :saldoFuente,
           :fechaProcesoSistema;

  if sqlcode = 100;
    eof = *on;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'EOF';
    status.mensaje = 'Fin de cuentas';
    return;
  endif;

  cuenta.codigoBanco = codigoBanco;
  cuenta.codigoSucursal = codigoSucursal;
  cuenta.codigoMoneda = codigoMoneda;
  cuenta.cuentaContable = cuentaContable;
  cuenta.descripcionCuenta = descripcionCuenta;
  cuenta.naturalezaCuenta = naturalezaCuenta;
  cuenta.nivelCuenta = nivelCuenta;
  cuenta.centroCosto = centroCosto;
  cuenta.saldoFuente = saldoFuente;
  cuenta.fechaProcesoSistema = fechaProcesoSistema;

  setStatusSql(status: 'DAT002': 'Cuenta leida');
  if status.ok and cuenta.cuentaContable = '';
    status.ok = *off;
    status.severidad = 'ALTA';
    status.codigo = 'DAT003';
    status.mensaje = 'Cuenta contable obligatoria vacia';
  endif;
end-proc;

dcl-proc loadMovimientos export;
  dcl-pi *n;
    status likeds(OpStatus);
    cuenta likeds(CuentaFuente) const;
    parms likeds(RunParms) const;
    movs likeds(Movimiento) dim(500);
    movCount int(10);
  end-pi;

  dcl-s i int(10) inz(0);
  dcl-s c_codigoBanco like(CuentaFuente.codigoBanco);
  dcl-s c_codigoSucursal like(CuentaFuente.codigoSucursal);
  dcl-s c_codigoMoneda like(CuentaFuente.codigoMoneda);
  dcl-s c_cuentaContable like(CuentaFuente.cuentaContable);
  dcl-s p_fechaProceso like(RunParms.fechaProceso);

  dcl-s idMovimiento like(Movimiento.idMovimiento);
  dcl-s numeroRegistroRelativo like(Movimiento.numeroRegistroRelativo);
  dcl-s fechaOperacion like(Movimiento.fechaOperacion);
  dcl-s tipoMovimiento like(Movimiento.tipoMovimiento);
  dcl-s debitoCredito like(Movimiento.debitoCredito);
  dcl-s monto like(Movimiento.monto);
  dcl-s referenciaExterna like(Movimiento.referenciaExterna);
  dcl-s textoDescripcion like(Movimiento.textoDescripcion);

  clear movs;
  movCount = 0;

  exec sql
    declare C_MOV cursor for
      select id_movimiento,
             numero_registro_relativo,
             fecha_operacion,
             tipo_movimiento,
             debito_credito,
             monto,
             referencia_externa,
             texto_descripcion
        from V_GL_MOVS
       where codigo_banco = :c_codigoBanco
         and codigo_sucursal = :c_codigoSucursal
         and codigo_moneda = :c_codigoMoneda
         and cuenta_contable = :c_cuentaContable
         and fecha_operacion <= :p_fechaProceso
       order by fecha_operacion,
                numero_registro_relativo;

  c_codigoBanco = cuenta.codigoBanco;
  c_codigoSucursal = cuenta.codigoSucursal;
  c_codigoMoneda = cuenta.codigoMoneda;
  c_cuentaContable = cuenta.cuentaContable;
  p_fechaProceso = parms.fechaProceso;

  exec sql open C_MOV;
  if sqlcode < 0;
    setStatusSql(status: 'DAT010': 'No fue posible leer movimientos');
    return;
  endif;

  dow i < %elem(movs);
    i += 1;
    exec sql
      fetch C_MOV
        into :idMovimiento,
             :numeroRegistroRelativo,
             :fechaOperacion,
             :tipoMovimiento,
             :debitoCredito,
             :monto,
             :referenciaExterna,
             :textoDescripcion;
    if sqlcode = 100;
      leave;
    endif;
    if sqlcode < 0;
      leave;
    endif;

    movs(i).idMovimiento = idMovimiento;
    movs(i).numeroRegistroRelativo = numeroRegistroRelativo;
    movs(i).fechaOperacion = fechaOperacion;
    movs(i).tipoMovimiento = tipoMovimiento;
    movs(i).debitoCredito = debitoCredito;
    movs(i).monto = monto;
    movs(i).referenciaExterna = referenciaExterna;
    movs(i).textoDescripcion = textoDescripcion;

    movCount = i;
  enddo;

  exec sql close C_MOV;
  setStatusSql(status: 'DAT011': 'Movimientos leidos');
end-proc;

dcl-proc loadDescripciones export;
  dcl-pi *n;
    status likeds(OpStatus);
    movs likeds(Movimiento) dim(500);
    movCount int(10) const;
  end-pi;

  status.ok = *on;
  status.severidad = 'BAJA';
  status.codigo = 'DAT020';
  status.mensaje = 'Descripciones incluidas desde V_GL_MOVS';
end-proc;

dcl-proc closeCuentaCursor export;
  dcl-pi *n;
    status likeds(OpStatus);
  end-pi;

  if gOpen;
    exec sql close C_GLBLN;
    gOpen = *off;
  endif;
  setStatusSql(status: 'DAT099': 'Cursor GLBLN cerrado');
end-proc;

dcl-proc setStatusSql;
  dcl-pi *n;
    status likeds(OpStatus);
    codigo varchar(20) const;
    mensaje varchar(256) const;
  end-pi;

  if sqlcode < 0;
    status.ok = *off;
    status.severidad = 'CRITICA';
    status.codigo = codigo;
    status.mensaje = %trim(mensaje) + ' SQLCODE ' + %char(sqlcode);
  else;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'OK';
    status.mensaje = mensaje;
  endif;
end-proc;
