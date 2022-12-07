**FREE
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTTHD1)
  Text('Check client');
// ___________________________________________________________________
/Include QSYSINC/QRPGLESRC,PTHREAD

Dcl-F Employee Keyed ExtDesc('SAMPLE/EMPLOYEE') Qualified UsrOpn;

Dcl-Pr TESTTHD1 ExtPgm('TESTTHD1');
End-Pr TESTTHD1;

Dcl-Pi TESTTHD1;
End-Pi TESTTHD1;

Dcl-Pr Sleep   Int(10) ExtProc('sleep');
  Seconds Uns(10) Value;
End-Pr Sleep;

// ____________________________________________________________________________
Dcl-Ds DsEmployee LikeRec(Employee.Employee :*ALL);

// ____________________________________________________________________________


If (Not %Open(EMPLOYEE));
  Open EMPLOYEE;
EndIf;

Chain '000010' EMPLOYEE DsEmployee;

Sleep(10);

Return;