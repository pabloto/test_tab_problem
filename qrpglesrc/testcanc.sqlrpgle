**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTCANC)
  Text('Test insert from xmltable fulcanc');
// ____________________________________________________________________________


// ___________________________________________________________________________

*Inlr = *On;

Exec Sql
  Set Option Datfmt = *Iso,
             Timfmt = *Iso,
             Closqlcsr = *EndActGrp,
             Commit = *none;

Exec Sql
Insert into Testfirds/delisin
Select E.*
  From Testfirds.Testxml A,
       Xmltable(Xmlnamespaces (Default 'urn:iso:std:iso:20022:tech:xsd:head.003.001.01',
       'urn:iso:std:iso:20022:tech:xsd:auth.102.001.01' As "del"),
       '$a/BizData/Pyld/del:Document/del:FinInstrmRptgCxlRpt/del:CxlData' Passing Firdsxml As "a"
       Columns Isin Char(12)    Path 'del:FinInstrmGnlAttrbts/del:Id',
       Venue Char(4)            Path 'del:TradgVnRltdAttrbts/del:Id') As E
  Where Filename = 'FULCAN_20230422_01of02.xml';


Return;