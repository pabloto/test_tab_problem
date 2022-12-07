**free
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTDATOR2)
  Text('Test su date');
// ___________________________________________________________________

// Prototipi
  Dcl-Pr GetNextYear LikeDs(NextYear_Template) Dim(365) ExtProc('TESTSRVPGM');
    StartDate       Packed(8 :0) Const;    // Data di Partenza
  End-Pr GetNextYear;
  Dcl-S Idx        Int(5);
  // ____________________________________________________________________________
  Dcl-Ds NextYear_Template Qualified Template Dim(365);
    Data           Packed(8);
  End-Ds NextYear_Template;

  // ____________________________________________________________________________
  Dcl-Ds NextYear LikeDs(NextYear_template) dim(365);

  NextYear = GetNextYear(%Dec(%Date()));

  Return;