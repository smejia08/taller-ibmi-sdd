**free
ctl-opt nomain option(*srcstmt:*nodebugio);

/include qrpglesrc,glbtypes

exec sql
  set option commit = *none, closqlcsr = *endmod;

dcl-s gOpen ind inz(*off);

dcl-proc openCuentaCursor export;
  dcl-pi *n;
    status likeds(OpStatus);
    parms likeds(RunParms) const;
  end-pi;

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
       where codigo_banco = :parms.codigoBanco
         and (:parms.codigoSucursal = ''
              or codigo_sucursal = :parms.codigoSucursal)
         and (:parms.codigoMoneda = ''
              or codigo_moneda = :parms.codigoMoneda)
         and (:parms.cuentaDesde = ''
              or cuenta_contable >= :parms.cuentaDesde)
         and (:parms.cuentaHasta = ''
              or cuenta_contable <= :parms.cuentaHasta)
         and fecha_proceso_sistema <= :parms.fechaProceso
       order by codigo_banco,
                codigo_sucursal,
                codigo_moneda,
                cuenta_contable;

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

  eof = *off;
  clear cuenta;

  exec sql
    fetch C_GLBLN
      into :cuenta.codigoBanco,
           :cuenta.codigoSucursal,
           :cuenta.codigoMoneda,
           :cuenta.cuentaContable,
           :cuenta.descripcionCuenta,
           :cuenta.naturalezaCuenta,
           :cuenta.nivelCuenta,
           :cuenta.centroCosto,
           :cuenta.saldoFuente,
           :cuenta.fechaProcesoSistema;

  if sqlcode = 100;
    eof = *on;
    status.ok = *on;
    status.severidad = 'BAJA';
    status.codigo = 'EOF';
    status.mensaje = 'Fin de cuentas';
    return;
  endif;

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
       where codigo_banco = :cuenta.codigoBanco
         and codigo_sucursal = :cuenta.codigoSucursal
         and codigo_moneda = :cuenta.codigoMoneda
         and cuenta_contable = :cuenta.cuentaContable
         and fecha_operacion <= :parms.fechaProceso
       order by fecha_operacion,
                numero_registro_relativo;

  exec sql open C_MOV;
  if sqlcode < 0;
    setStatusSql(status: 'DAT010': 'No fue posible leer movimientos');
    return;
  endif;

  dow i < %elem(movs);
    i += 1;
    exec sql
      fetch C_MOV
        into :movs(i).idMovimiento,
             :movs(i).numeroRegistroRelativo,
             :movs(i).fechaOperacion,
             :movs(i).tipoMovimiento,
             :movs(i).debitoCredito,
             :movs(i).monto,
             :movs(i).referenciaExterna,
             :movs(i).textoDescripcion;
    if sqlcode = 100;
      leave;
    endif;
    if sqlcode < 0;
      leave;
    endif;
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
