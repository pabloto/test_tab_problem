**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTCANCR)
  Text('Test insert from xmltable fulcanc');
// ____________________________________________________________________________

Dcl-Ds Firds Qualified;
  count_CxlData     Int(10);
  Dcl-Ds CxlData dim(1000000);
    Dcl-DS FinInstrmGnlAttrbts ;
      Id        Char(12);
    End-Ds FinInstrmGnlAttrbts;
    Dcl-DS TradgVnRltdAttrbts ;
      Id        Char(4);
    End-DS TradgVnRltdAttrbts;
  End-Ds CxlData;
End-Ds Firds;

dcl-s   XmlDocument      varchar(200);
Dcl-s   XmlOptions          varchar(200);
Dcl-s   Ini              Timestamp;
Dcl-s   Fine             Timestamp;
// ___________________________________________________________________________

*Inlr = *On;

Ini = %timestamp();
snd-msg 'Inizio:  ' + %Char(Ini);

XmlDocument = '/home/paolos/FULCAN_20230422_02of02.xml';

XmlOptions = 'case=any allowextra=yes allowmissing=yes doc=file ns=merge +
               path=BizData/Pyld/Document/FinInstrmRptgCxlRpt +
               countprefix=count_';

Monitor;
  Xml-Into Firds %Xml(XmlDocument :XmlOptions);
On-Error *all;
  snd-msg 'Errore';
EndMon;

Fine = %timestamp();
snd-msg 'Fine:    ' + %Char(Fine);
snd-msg 'Delta:   ' + %Char(%diff( Fine : Ini :*MSECONDS ));
Return;