**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTDATORA)
  Text('Test su date');
// ___________________________________________________________________

/copy Al400mnuv2/QRpgleSrc,UMiFunc_h
// Prototipi
Dcl-Pr TESTDATORA ExtPgm('TESTDATORA');
  
End-Pr TESTDATORA;

Dcl-Pi TESTDATORA;
End-Pi TESTDATORA;

// ____________________________________________________________________________
Dcl-S DataOra   Char(14) Inz('20220214140100');
Dcl-S DataOraF  Char(14) ;

// prova
DataOraF = %Char(%TimeStamp(%Dec(DataOra :14 :0):*iso) +%minutes(1) :*Iso0);

Dsply DataOraF;

Return;