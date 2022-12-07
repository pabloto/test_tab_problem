**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  Expropts(*AlwBlankNum)
  AlwNull(*UsrCtl)
  DftName(euxdirese)
  Text('errori direse');

Dcl-F Eux015Er Rename(EUX015ER :AAA) ;

// ____________________________________________________________________________

Dcl-S NewDataOra Timestamp(9);

// ____________________________________________________________________________
Exec Sql
  Set Option Datfmt = *Iso, Timfmt = *Iso, Closqlcsr = *EndMod, Commit = *none;

Dow not %Shtdn();

  Read Eux015Er;
  If %Eof(Eux015Er);
    Leave;
  EndIf;

  NewDataOra = SetPrg(DnRif : Sel0004);

  Dnrif = 'L1509502114546';
  Dprg = 1;
  
  Exec Sql
    Update Direse0f
    set DataOra = :NewDataOra
    where Riferimento = :DnRif and Progressivo = :DPrg;

EndDo;

*inlr = *on;
// ____________________________________________________________________________
Dcl-Proc SetPrg;

  Dcl-Pi SetPrg Timestamp(9);
    KNRif           Char(14);
    UTime           Char(20) Options(*NullInd);
  End-Pi SetPrg;

  Dcl-S PrgChar             Char(10);
  Dcl-S DataOra             Timestamp(9) Inz(Z'1970-01-01-00.00.00.000000000');
  Dcl-S EpochNano           Zoned(22 :10);
  Dcl-S DirEseTradeMatchId  VarChar(52);
  Dcl-S First               Ind;


Dcl-Pr CEEUTCO ExtProc('CEEUTCO') opdesc;
  offset_hours  Int(10);                 //offset_hours
  offset_mins   Int(10);                 //offset_mins
  offset_secs   Float(8);                //offset_secs
  fc            Char(12)   options(*omit); //fc
End-Pr CEEUTCO;

Dcl-S junk1 Int(10);
Dcl-S junk2 Int(10);
Dcl-S offset Float(8);
  // ____________________________________________________________________________
  If (Not First);
    CEEUTCO(junk1:junk2:offset:*omit);
    First = *On;
  EndIf;

  EpochNano          = %Uns(UTime) / 1000000000;
  DataOra            = DataOra + %Seconds(EpochNano) + %Hours(junk1);

  Return DataOra;

End-Proc SetPrg;