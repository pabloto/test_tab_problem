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
  DftName(TESTUSRQ)
  Text('Test decimali');

// ________________________________________________________
//      Campi di work
/INCLUDE Al400mnuv2/Qrpglesrc,umifunc_h


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

Dcl-S CurrentMessages     Int(10);
Dcl-S QueuePointer        Pointer(*Proc);
Dcl-ds OpqAtr             LikeDs(QueAtr);

// ___________________________________________________________________________

QueuePointer = Mi_GetSysPtr('OPQUSRQLOG' :'GESTSIMDAT' :'*USRQ');

CurrentMessages = Mi_GetUsrQMsgNum(OpqAtr :QueuePointer);

TextArr(1) = 'Numero Messaggi     : ' + %Char(CurrentMessages);


DspLongMsg(TextMsg:%Len(TextMsg):'':'':ApiError);

Return;