**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTUCNNR)
  Text('Test su date');
// ___________________________________________________________________

/copy Al400mnuv2/QRpgleSrc,UMiFunc_h
dcl-f CMEMOD0F keyed usage(*update);

// Prototipi
Dcl-Pr TESTUCNNR ExtPgm('TESTUCNNR');
End-Pr TESTUCNNR;

Dcl-Pi TESTUCNNR;
End-Pi TESTUCNNR;
dcl-pr UCnnGtr extpgm('UCNNGTR');
  *n char(256); // P_Cnn
end-pr;

Dcl-Pr DspLongMsg ExtPgm('QUILNGTX');
  Text      Char(16773100) const options(*varsize);
  Length    Int(10)     const;
  Msgid     Char(7)     const;
  Qualmsgf  Char(20)    const;
  ErrorCode Char(32767) options(*varsize);
End-Pr DspLongMsg;

Dcl-Ds ApiError Qualified;
  BytPrv            Int(10) Inz(%Size(ApiError));
  BytAvl            Int(10) Inz(0);
  MsgId             Char(7);
  *n                Char(1);
  MsgDta            Char(128);
End-Ds ApiError;

// ____________________________________________________________________________
//  ds per get parametri connessione
dcl-ds p_cnn len(256);
  p_cnnIconn char(3);
  p_cnnIserv char(3);
  p_cnnItipo char(1);
  p_cnnIsott char(1);
  p_cnnIista char(3);
  p_cnnOesit char(1);
  p_cnnOacti char(1);
  p_cnnOloip char(20);
  p_cnnOlopn char(20);
  p_cnnOreip char(20);
  p_cnnOrepn char(20);
  p_cnnOuser char(20);
  p_cnnOpass char(20);
  p_cnnOsubi char(20);
  p_cnnOaccn char(20);
  p_cnnOsend char(20);
  p_cnnOtarg char(20);
  p_cnnOflg1 char(1);
  p_cnnOflg2 char(1);
  p_cnnOflg3 char(1);
  p_cnnOwrk1 char(10);
  p_cnnOwrk2 char(10);
  p_cnnOwrk3 char(10);
end-ds;

Dcl-S TestMsg		VarChar(800);
// ____________________________________________________________________________



Chain(n) ('U' : 'A') cmemod0f;
If (not %found);
  TestMsg = 'GetParm-Mod non trovato';
  DspLongMsg(TestMsg:%len(TestMsg):'':'':ApiError);
  Return;
EndIf;

If (mact <> 'A');
  TestMsg = 'GetParm-Act <> "A"';
  DspLongMsg(TestMsg:%len(TestMsg):'':'':ApiError);
  Return;
EndIf;

p_cnn = mloip;

UCnnGtr(P_Cnn);


TestMsg = p_cnnOaccn;
DspLongMsg(TestMsg:%len(TestMsg):'':'':ApiError);


Return;