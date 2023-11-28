**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTXML)
  Text('Test insert from xmltable');
// ____________________________________________________________________________

dcl-s aaa char(10) ccsid(*utf8) template;
dcl-s bbb like(aaa);
// ___________________________________________________________________________

bbb = 'a';
*Inlr = *On;

Exec Sql
  Set Option Datfmt = *Iso,
             Timfmt = *Iso,
             Closqlcsr = *EndActGrp,
             Commit = *none;

Exec Sql
Insert into Testfirds/Firdsxml
      (Select e.*
          From Testfirds/Testxml A,
               Xmltable(Xmlnamespaces (Default 'urn:iso:std:iso:20022:tech:xsd:head.003.001.01', 'urn:iso:std:iso:20022:tech:xsd:auth.017.001.02' As "doc"),
                  '$a/BizData/Pyld/doc:Document/doc:FinInstrmRptgRefDataRpt/doc:RefData' Passing Firdsxml As "a"
                    Columns
            isin                                    char(12)           path 'doc:FinInstrmGnlAttrbts/doc:Id',
            FullName                                varchar(100)       path 'doc:FinInstrmGnlAttrbts/doc:FullNm',
            ShortName                               varchar(100)       path 'doc:FinInstrmGnlAttrbts/doc:ShrtNm',
            Cfi                                     char(6)            path 'doc:FinInstrmGnlAttrbts/doc:ClssfctnTp',
            Notionalcurrency                        varchar(100)       path 'doc:FinInstrmGnlAttrbts/doc:NtnlCcy',
            commodderivateind                       char(5)            path 'doc:FinInstrmGnlAttrbts/doc:CmmdtyDerivInd',
            Issuer                                  Char(20)           path 'doc:Issr',
            mic                                     Char(4)            path 'doc:TradgVnRltdAttrbts/doc:Id',
            admissiontotrading                      char(5)            path 'doc:TradgVnRltdAttrbts/doc:IssrReq',
            approvaladmission                       char(20)           path 'doc:TradgVnRltdAttrbts/doc:AdmssnApprvlDtByIssr',
            DateofFirstTrade                        char(20)           path 'doc:TradgVnRltdAttrbts/doc:FrstTradDt',
            TerminationDate                         Char(20)           path 'doc:TradgVnRltdAttrbts/doc:TermntnDt',
            Underlyngisin                           Char(12)           path 'doc:DerivInstrmAttrbts/doc:UndrlygInstrm/doc:Sngl/doc:ISIN'
       ) As E
          Where Filename = 'FULINS_D_20230408_01of03.xml');


Return;