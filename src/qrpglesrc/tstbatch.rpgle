**free
ctl-opt nomain option(*srcstmt:*nodebugio);

dcl-pr GLBATCH extpgm('GLBATCH');
  pBanco varchar(10) const;
  pSucursal varchar(10) const;
  pMoneda varchar(10) const;
  pCuentaDesde varchar(30) const;
  pCuentaHasta varchar(30) const;
  pFecha char(10) const;
  pRuta varchar(500) const;
  pModo varchar(12) const;
  pAmbiente varchar(20) const;
  pTolerancia packed(18:2) const;
end-pr;

dcl-proc TestBatch01 export;
  dcl-pi *n end-pi;

  GLBATCH('001': '001': 'COP': '100000': '170000': '2026-06-25':
          '/GLBTST/output/': 'PRUEBA': 'TST': 10.00);
  dsply 'PASS TI_BATCH01';
end-proc;
