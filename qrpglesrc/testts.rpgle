**FREE

TESTTS(%Timestamp());
Return;
// ____________________________________________________________________________
Dcl-Proc TESTTS;
  Dcl-Pi TESTTS;
    InputTimestamp  Timestamp Const;
  End-Pi TESTTS;


  // ____________________________________________________________________________
  If (%Date(InputTimestamp) = %Date());
    Dsply 'Uguale';
  Else;
    Dsply 'Diverso';
  EndIf;

  Return;
End-Proc TESTTS;