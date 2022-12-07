**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTDATE)
  Text('Test su date');
// ___________________________________________________________________

/copy Al400mnuv2/QRpgleSrc,UMiFunc_h
// Prototipi
Dcl-Pr TESTDATE ExtPgm('TESTDATE');
End-Pr TESTDATE;

Dcl-Pi TESTDATE;
End-Pi TESTDATE;

// ____________________________________________________________________________
Dcl-S DataDec   Zoned(20) Inz(19700101);
Dcl-S Data      Date;
Dcl-S DataOra   Timestamp(9) Inz(Z'1970-01-01-00.00.00.000000000');

Dcl-S Epoch     Char(20) Inz('1649778254212775088');
Dcl-S Epoch2    Zoned(30 : 10);

Epoch2 = %Uns(Epoch) / 1000000000;

//DataOra = %Timestamp(%Date(DataDec));
DataOra = DataOra + %Seconds(Epoch2);

Dsply %Char(DataOra);

Return;