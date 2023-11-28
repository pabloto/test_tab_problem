**free
Ctl-Opt  DftActGrp(*no)ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  Expropts(*AlwBlankNum)
  AlwNull(*UsrCtl)
  DftName(TESTFORM)
  Text('Test for format document');
// ____________________________________________________________________________

Dcl-s Ostpc Char(10);

Exec Sql
  Set Option Datfmt = *Iso, Timfmt = *Iso, Closqlcsr = *EndMod, Commit = *none;

Ostpc = 'TEST';

Exec Sql 
  update testupdate
  set ostpc = :OStPc
  where ococl = '20470' and otito  = 'FCT';



Return;