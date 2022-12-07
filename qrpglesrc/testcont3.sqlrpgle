**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Bnddir('AL400MNUV2': 'WEBSCKDIR' : 'TESTBND')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTCONT3)
  Text('Test contattone');
// ___________________________________________________________________
/Include QSYSINC/QRPGLESRC,PTHREAD
/Include Roberto/qrpglesrc,copy_pr
/Include Roberto/qrpglesrc,copy_ds

/copy Al400mnuv2/QRpgleSrc,UMiFunc_h
// Prototipi
Dcl-Pr TESTCONT3 ExtPgm('TESTCONT3');
End-Pr TESTCONT3;

Dcl-Pi TESTCONT3;
End-Pi TESTCONT3;

Dcl-Pr UChkCont1r Char(100) extproc('UCHKCONT1R');
  Contattone      Char(32) Const;
  CallerPgm       Char(10) Const;
  Debug           Char(1) Options(*NoPass) Const;
End-Pr UChkCont1r;


Dcl-Pr USleep   Int(10) ExtProc('usleep');
  MilliSeconds Uns(10) Value;
End-Pr USleep;

Dcl-Pr Cmd   Int(10) ExtProc('system');
  CmdString Pointer Value Options(*String);
End-Pr Cmd;

Dcl-s Command  VarChar(1000);
Dcl-S ErrMsgId Char(7) Import('_EXCP_MSGID');
//  @remark CHKLKVAL and CLRLKVAL are available since V5R3
dcl-pr CheckLockValue int(10) extproc('_CHKLKVAL');
  *n int(20); // lock
  *n int(20) value; // old_val
  *n int(20) value; // new_val
end-pr;

//  @BIF _CLRKLVAL (Clear Lock Value (CLRLKVAL))
dcl-pr ClearLockValue extproc('_CLRLKVAL');
  *n int(20); // lock
  *n int(20) value; // new_val
end-pr;

// ____________________________________________________________________________
Dcl-Ds thread LikeDs(pthread_t) Dim(1659) Static(*allthread);

Dcl-Ds a Static(*allthread);
  ThreadReadyArr       Char(1) Dim(1659) ;
  ThreadReady          Char(1659) Pos(1) ;
End-Ds;

Dcl-S Rc                 Int(10);
Dcl-S IdxMain            Int(10) ;
Dcl-S Status             Int(10) ;
Dcl-S PtrStatus          Pointer inz(%Addr(Status));

Dcl-S TextMsg       VarChar(100);
Dcl-C MAX           1500;
Dcl-C AP             '''';
dcl-s Old_Value int(20);
dcl-s New_Value int(20);
dcl-s Lock      int(20) Static(*allThread);

// ____________________________________________________________________________

ContTestDS = UChkCont1r('84943907373806311759108859071759' :'TESTCONT3');

Return;