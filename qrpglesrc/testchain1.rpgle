**free
Ctl-opt  datfmt(*iso) timfmt(*iso) alwnull(*usrctl) debug;

Dcl-F TESTFILE3     Keyed Usage(*Update :*Delete);

Dcl-Pr TESTCHAIN1 ExtPgm('TESTCHAIN1');
  Parm1 Char(1);
End-Pr TESTCHAIN1;

Dcl-Pi TESTCHAIN1;
  Parm1 Char(1);
End-Pi TESTCHAIN1;

Dcl-DS AAA;
  a Char(10);
  Dcl-ds a;
  End-ds a;
End-Ds AAA;

If (Parm1 = 'N');
  Chain ('CHIAVE' :1) TESTFILE3;
Else;
  Chain ('CHIAVE' :1) TESTFILE3;
EndIf;

job_name  = 'TESTFILE1';

Update TESTREC;


Return;

// ____________________________________________________________________________
Dcl-Proc aaa;

  Dcl-Pi aaa;
  End-Pi aaa;
  // ____________________________________________________________________________


End-Proc aaa;