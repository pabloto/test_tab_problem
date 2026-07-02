**free
ctl-opt
  dftactgrp(*no)
  actgrp(*stgmdl)
  stgmdl(*snglvl)
  option(*nounref :*srcstmt :*nodebugio)
  datfmt(*iso) timfmt(*iso)
  debug(*constants)
  expropts(*alwblanknum)
  alwnull(*usrctl)
  dftname(testerr01)
  text('Test for compilation error');
// ____________________________________________________________________________

dcl-s dataorachar		VarChar(21)	 Inz('20260701150005123456');

// Here's I remove the semicolon
dcl-s dataora       Timestamp

dataora	= %timestamp(%Dec(dataorachar :21 :0));

return;

