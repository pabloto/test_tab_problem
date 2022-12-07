**FREE
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTTHREAD)
  Text('Test multithread');
// ___________________________________________________________________
/Include QSYSINC/QRPGLESRC,PTHREAD

Dcl-Pr TESTTHREAD ExtPgm('TESTTHREAD');
End-Pr TESTTHREAD;

Dcl-Pi TESTTHREAD;
End-Pi TESTTHREAD;

Dcl-Pr TESTTHD1 ExtPgm('TESTTHD1');
End-Pr TESTTHD1;

Dcl-Pr USleep   Int(10) ExtProc('usleep');
  MilliSeconds Uns(10) Value;
End-Pr USleep;

Dcl-Pr Sleep   Int(10) ExtProc('sleep');
  Seconds Uns(10) Value;
End-Pr Sleep;
// ____________________________________________________________________________
Dcl-Ds thread LikeDs(pthread_t) Dim(MAX) Static(*allthread);

Dcl-S Rc                  Int(10);
Dcl-S IdxMain             Int(10) ;
Dcl-S IdxTemp             Int(10) Static(*allThread);

Dcl-C MAX                 1500;

// ____________________________________________________________________________

IdxMain = 1;

For IdxMain = 1 to MAX;
  // Open a new thread (simulate a client connection
  Rc = pthread_create(thread(IdxMain) : *Omit : %PAddr(TestOpenFile) : %Addr(IdxMain));
  // Immediately after I detach this thread (so when the thread end every varialble
  //   defined in this will be reclaimed in the procedure/external program
  Rc = pthread_detach(thread(IdxMain));
  // Set a name to the thread
  Rc = pthread_setname_np(thread(IdxMain) :'TEST-' + %Char(IdxMain));
EndFor;


// Wait until all thread are finished
Dow (IdxTemp < 500);
  USleep(100000);
EndDo;

// Now if you check you will see every thread are finished, the memory is reclamed,
//  but there are 1501 open data path to the same file
Sleep(20);

Return;
// ____________________________________________________________________________
Dcl-Proc TestOpenFile;
  Dcl-Pi TestOpenFile;
    PtrIdx Pointer value;
  End-Pi TestOpenFile;

  Dcl-S TestVar Char(16000000);
  Dcl-S IdxThread1      Int(10) Based(PtrIdx);
  Dcl-S IdxThread       Int(10);
  // ____________________________________________________________________________

  *inlr = *On;

  IdxThread = IdxThread1;

  // Call an external program that open a file
  TESTTHD1();

  IdxTemp +=1;

  Return;

End-Proc TestOpenFile;
