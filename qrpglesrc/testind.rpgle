**free
Ctl-Opt  DftActGrp(*no)ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  Expropts(*AlwBlankNum)
  AlwNull(*UsrCtl)
  DftName(TESTIND)
  Text('Test indicatori');

dcl-s a ind;
dcl-s b ind;
dcl-s c ind;


If (Not %List(a :b :c));
  snd-msg 'Un indicatore è acceso';
EndIf;

Return;
