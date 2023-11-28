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
  DftName(MLE018)
  Text('MLE/Optiq - chiusura ordini MLE a fine diurna/AH');
// ____________________________________________________________________________
//  chiusura ordini MLE a fine diurna/AH inclusi multiday scaduti

Dcl-F ORDPP1L Usage(*Input) Keyed;
Dcl-F ORDPPZL Usage(*Input) Keyed RENAME(RORDPD:RORDPDZ) RENAME(RORDPV:RORDPVZ);
//  File per univocità d'azione
Dcl-F ORDLCK0F Usage(*Update:*Delete:*Output) Keyed;
Dcl-F qprint PRINTER(132);

Dcl-Pr MLE018 ExtPgm('MLE018');
  Segmento         Char(3);
End-Pr MLE018;

Dcl-Pi MLE018;
  Segmento         Char(3);
End-Pi MLE018;


Dcl-Pr ModChiu  ExtPgm('MODCHIU');
  DsChiudi       Char(17);
End-PR;

Dcl-Pr PrvChiu ExtPgm('PRVCHIU');
  ParmPrvChiu    LikeDs(DsChiuPrivate);
End-Pr PrvChiu;

Dcl-Pr UTSpocApi ExtPgm('UTSPOCAPI');
  Text      Char(400) Const;
  Proc      Char(20)  Const;
  Group     Char(10)  Const;
  Type      Char(4)   Const;
  Alert     Char(1)   Const;
  Inquiry   Char(1)   Const;
  PMsgCode   Char(10)  Const;
  PgmSosp   Char(1)   Const;
  WaitMax   packed(5) Const;
  TextHidd  Char(500) Const;
  PRemSys    Char(5)   Const;
  MsgResp   Char(60);
  PSpocKey   Char(23)  Const;
End-Pr UTSpocApi;

Dcl-C PROCEDURA   'MLE018';
Dcl-C INOLTRO     'INOLTRO';
Dcl-C INFO        'INFO';
Dcl-C NOTI        'NOTI';
Dcl-C MEMO        'MEMO';
Dcl-C ALERTNO     'N';
Dcl-C ALERTSI     'Y';
Dcl-C INQUIRYSI   'Y';
Dcl-C INQUIRYNO   'N';
Dcl-C PGMSOSPNO   'N';
Dcl-C PGMSOSPSI   'Y';
Dcl-C MSGCODE     ' ';
Dcl-C WAITMAX300  300;
Dcl-C TEXTHIDDEN  ' ';
Dcl-C REMSYS      ' ';
Dcl-C SPOCKEY     ' ';

Dcl-S TextMsg     Char(400);
Dcl-S TextMsgR    Char(60);

// ____________________________________________________________________________

Dcl-DS DsChiudi Ext Qualified End-Ds;

Dcl-Ds DsOrdini Qualified;
  OAmbi           Char(1);
  ONRif           Char(14);
  OTito           Char(6);
  OCocl           Char(5);
  OSta1           Char(1);
  OSta2           Char(1);
  OTpOp           Char(1);
  OFlg3           Char(3);
  OFld3           Packed(8);
  OFlg8           Char(1);
End-Ds DsOrdini;

// DS PER MODULO DI CHIUSURA PRIVATE
Dcl-Ds DsChiuPrivate ExtName('DSCHIPRV') Qualified End-Ds;

Dcl-Ds Line Len(132) Qualified;
  *n              Char(1);
  ONRif           Char(14);
  *n              Char(5);
  OTito           Char(6);
  *n              Char(5);
  OTpOp           Char(1);
  *n              Char(5);
  DataScadenza    Date;
  *n              Char(5);
  OSta1Pre        Char(1);
  *n              Char(5);
  OSta2Pre        Char(1);
  *n              Char(5);
  OSta1           Char(1);
  *n              Char(5);
  OSta2           Char(1);
End-Ds Line;

Dcl-Ds Head Qualified;
  Titolo           Char(132);
End-Ds Head;
// ____________________________________________________________________________

Dcl-S OSta1Previous         Like(OSta1);
Dcl-S Osta2Previuos         Like(Osta2);
Dcl-S First                 Ind;
// ____________________________________________________________________________

Exec Sql Set Option DatFmt = *Iso, TimFmt = *Iso, CloSqlCsr = *EndMod, Commit = *none;

If (Segmento in %List('013' : '014' :'420' :'415' :'611'));
  Return;
EndIf;

Exec Sql
  Declare OrdinidaChiudere cursor for
    Select 'D', ONRif, Otito, OCocl, OSta1, OSta2, OtpOp, OFlg3, OFld3, OFlg8
      From OrdPd0f
      where Digits(OFlg3) = :Segmento                                   // solo il segmento da parametro
        And Oflg2 In ('M', 'S', 'R', 'B', 'N')                          // Precauzione solo gli oflg2 di Borsa Italiana
        And Osta1 In ('i', 'b', 'n', 'P')                               // Solo questi Osta1
        And Oflg5 <> 'S'                                                // Non le spezzature
        And Not (Ofld3 > Dec(Current Date) And Osta2 = '')              // Non i multiday non revocati
        and Not (OFl15 = 'C')                                           // Non i PAC
        and Not (OSta1 = 'P' and (OFlgS in('S', 'T') or OFl15 <> ' ')) // Non gli ordini parcheggiati se stop o CASTA
    Union
    Select 'P', ONRif, Otito, OCocl, OSta1, OSta2, OtpOp, OFlg3, OFld3, OFlg8
      From OrdPv0f
      where Digits(OFlg3) = :Segmento                                   // solo il segmento da parametro
        And Oflg2 In ('M', 'S', 'R', 'B', 'N')                          // Precauzione solo gli oflg2 di Borsa Italiana
        And Osta1 In ('i', 'b', 'n', 'P')                               // Solo questi Osta1
        And Oflg5 <> 'S'                                                // Non le spezzature
        And Not (Ofld3 > Dec(Current Date) And Osta2 = '')              // Non i multiday non revocati
        and Not (OFl15 = 'C')                                           // Non i PAC
        and Not (OSta1 = 'P' and (OFlgS in('S', 'T') or OFl15 <> ' '));

Exec Sql
  Open OrdinidaChiudere;

Dow (SqlState <> '02000');

  Exec Sql Fetch next from OrdinidaChiudere into :DsOrdini;
  If (SqlState = '02000');
    Leave;
  EndIf;

  //  CHIUSURA
  //  ========
  Reset DsChiudi.p§err;
  DsChiudi.P§nrf = DsOrdini.ONRif;

  If (DsOrdini.OAmbi = 'D');
    LockOrd();
    ModChiu(DsChiudi);
  Else;
    Eval-Corr DsChiuPrivate = DsChiudi;
    DsChiuPrivate.P§ERR = 'ANN';
    DsChiuPrivate.P§TSDT = %Timestamp();
    // DsChiuPrivate.P§PDN  = ;
    // DsChiuPrivate.P§EXID = ;
    PrvChiu(DsChiuPrivate);
  EndIf;
  //
  // Se l'ordine scaduto aveva un ordine in attesa chiudo anche questo
  If (DsOrdini.OFlg8 = '*');

    Chain(N) DsOrdini.ONRif ORDPPZL;

    DsChiudi.P§Nrf = ONRif;
    DsChiudi.P§Err = 'ANN';

    If (DsOrdini.OAmbi ='D');
      ModChiu(DsChiudi);
    Else;
      Eval-Corr DsChiuPrivate = DsChiudi;
      DsChiuPrivate.P§TSDT = %Timestamp();
      // DsChiuPrivate.P§PDN  = ;
      // DsChiuPrivate.P§EXID = ;
      PrvChiu(DsChiuPrivate);
    EndIf;

  EndIf;

  If (DsOrdini.OAmbi = 'D');
    Unlock ORDLCK0F;
  EndIf;

  //  salvo valori attuali x lista
  OSta1Previous = DsOrdini.OSta1;
  Osta2Previuos = DsOrdini.osta2;

  //  Riaggancio l'ordine per avere la nuova situazione
  Chain(n) DsOrdini.ONRif ORDPP1L ;
  If (%Found(ORDPP1L));
    //  Stampa ordini revocati
    PrintLine();
  EndIf;

EndDo;

Exec Sql
  Close OrdinidaChiudere;

*Inlr = *On;
// ____________________________________________________________________________
///
// LockOrd
// Loop infinito per verificare se il cliente è allocato
///
Dcl-Proc LockOrd;
  Dcl-Pi LockOrd;
  End-Pi LockOrd;
  Dcl-S Lock   Ind;
  // ____________________________________________________________________________

  If (OAmbi = 'P'); // per ora no gestiamo ordlck per il private
    Return;
  EndIf;

  Lock = *On;
  Dow (Lock);

    Chain(E) OCoCl RORDLCK;

    If (%Error);
      TextMsg ='MLE018 -  LOCK SU CLIENTE ' + OCoCl;
      UTSpocApi(TextMsg: PROCEDURA :INOLTRO :NOTI :ALERTNO :INQUIRYNO
                :MSGCODE :PGMSOSPNO :WAITMAX300
                :TEXTHIDDEN :REMSYS :TextMsgR :SPOCKEY);
    Else;
      Lock = *Off;
    EndIf;

  EndDo;

  Return;

End-Proc LockOrd;
// ____________________________________________________________________________
///
// PrintLine
// Description
///
Dcl-Proc PrintLine;
  Dcl-Pi PrintLine;
  End-Pi PrintLine;
  // ____________________________________________________________________________

  If (Not First);
    Head.Titolo = ' MLE018 - Elenco Ordini Revocati in Chiusura al ' + %Char(%Date()) + ' ' + %Char(%Time()) + ' Segmento: ' + Segmento;
    Write qprint Head;
    Head.Titolo = ' __________________________________________________________________________________________________________________________________';
    Write qprint Line;
    Head.Titolo = ' Riferimento        Titolo     TpOp  DataScadenza   St1P  St2P  St1   St2';
    Write qprint Line;
    First = *On;
  EndIf;

  Eval-Corr Line = DsOrdini;

  Line.DataScadenza = %Date(OFld3);
  Line.OSta1Pre     = OSta1Previous;
  Line.Osta2Pre     = Osta2Previuos;
  Write qprint Line;

  Return;

End-Proc PrintLine;
