**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  FltDiv(*yes)
  DftName(TESTDEC)
  Text('Test decimali');

// ________________________________________________________
//      Campi di work
Dcl-S PrezzoChar      Char(20) Inz('339800000');
Dcl-S PrezzoDec       Packed(15 :6);
Dcl-S PrezzoDec1      Packed(15 :6);
Dcl-S PrezzoDec15     Packed(30 :15);
Dcl-S PrezzoDec151    Packed(30 :15);

Dcl-Pr DspLongMsg ExtPgm('QUILNGTX');
  Text      Char(16773100) const options(*varsize);
  Length    Int(10)     Const;
  Msgid     Char(7)     Const;
  Qualmsgf  Char(20)    Const;
  ErrorCode Char(32767) options(*varsize);
End-Pr DspLongMsg;

Dcl-Ds ApiError Qualified;
  BytPrv    Int(10) Inz(%Size(ApiError));
  BytAvl    Int(10) Inz(0);
  MsgId     Char(7);
  *n        Char(1);
  MsgDta    Char(128);
End-Ds ApiError;

Dcl-Ds TextMsg;
  TextArr Char(80) Dim(24);
End-Ds TextMsg;
// ___________________________________________________________________________

Eval(h) PrezzoDec = %Dec(PrezzoChar : 15 : 6) / (10**7);
PrezzoDec1 = %Dec(PrezzoChar : 15 : 6) / (10**7);
Eval(h) PrezzoDec15 = %Dec(PrezzoChar : 30 : 15) / (10**7);
PrezzoDec151 = %Dec(PrezzoChar : 30 : 15) / (10**7);
// PrezzoFloat = %Int(PrezzoChar) / (10**7);
// PrezzoDec = %Dec(PrezzoFloat :30 :15) ;

TextArr(1) = 'Prezzo Dec     : ' + %Char(PrezzoDec);
TextArr(1) = 'Prezzo Dec     : ' + %Char(PrezzoDec);
TextArr(2) = 'Prezzo Dec1    : ' + %Char(PrezzoDec1);
TextArr(3) = 'Prezzo Dec15   : ' + %Char(PrezzoDec15);
TextArr(4) = 'Prezzo Dec151  : ' + %Char(PrezzoDec151);

DspLongMsg(TextMsg:%Len(TextMsg):'':'':ApiError);

Return;