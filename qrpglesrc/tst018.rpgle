     H BndDir( 'QC2LE' : 'AL400MNUV2')
     H Option(*SrcStmt:*NoDebugIo)
     f*-------------------------------------------------------------------
     f* chiusura ordini MLE a fine diurna/AH inclusi multiday scaduti
     f*-------------------------------------------------------------------
     f***ORDPD5L   If   E           K DISK    RENAME(RORDPD:RORDP5)
     f**ORDPD1L   uF   E           K DISK
     f*ORDPDZL   IF   E           K Disk    Rename(ROrdPd:ROrpdz)
     fORDPP5L   If   E           K DISK    RENAME(RORDPD:RORDPD5)
     f                                     RENAME(RORDPV:RORDPV5)
     fORDPP1L   uF   E           K DISK
     fORDPPZL   IF   E           K Disk    RENAME(RORDPD:RORDPDZ)
     f                                     RENAME(RORDPV:RORDPVZ)
fg   f* File per univocità d'azione
fg   fORDLCK0F  uf   e           k disk
     fqprint    o    f  132        printer oflind(*INOF)

     d ModChiu         Pr                  ExtPgm('MODCHIU')
     d  DsChiudi                     17

       Dcl-Pr PrvChiu ExtPgm('PRVCHIU');
          ParmPrvChiu    LikeDs(DsChiuPrivate);
       End-Pr PrvChiu;
       // DS PER MODULO DI CHIUSURA PRIVATE
       Dcl-Ds DsChiuPrivate ExtName('DSCHIPRV') Qualified End-Ds;

     d*---------------------------------------------------------------*
     d Time_Stamp      pr            20a
     d* struttura time_stamp
     d w_t_stamp       ds            20
     d w_t_stamp_D                    8  0
     d w_t_stamp_T                    6  0
     d w_t_stamp_M                    3  0
     d*--------------------------------------------------------------------*
     d dschiudi      e ds
     d*---------------------------------------------------------------*
     d                 ds
     d w_seg3a                 1      3a
     d w_seg3                  1      3s 0

     d wtest           s            150a
     d wsta1           s              1a
     d wsta2           s              1a
     c*---------------------------------------------------------------*
     c                   eval      w_t_stamp = Time_Stamp()

     c                   move      'Y'           newpag            1

     c                   eval      w_seg3a = p_seg3

fg99 c     w_seg3        setll     ordpp5l

fg99 c                   do        *hival
fg99 c     w_seg3        reade     ordpp5l
     c                   if        %eof
fg99 c                   leave
     c                   endif

gra01c* se ordine immesso/in parcheggio ignora
gra01c                   if        osta1 = 'j' or osta1 = 'I'
gra01c                   iter
gra01c                   endif

     c* se spezzature manuali ignora
gra01c                   if        oflg5 = 'S'
gra01c                   iter
gra01c                   endif

     c*-> escludo gli ordini multig. non scaduti e non revocati in chius.
gra01c                   if        ofld3 > w_t_stamp_D and osta2 = ' '
gra01c                   iter
gra01c                   endif

     c*-> escludo gli ordini day ma OPA
gra01c                   if        oflg3 = 13 or oflg3 = 14
gra01c                   iter
gra01c                   endif

      *-> escludo gli ordini dei segmenti OPS e OPV
      *   vendono gestiti dal back-office. non devono essere chiusi
     c                   if        oflg3 = 420 or oflg3 = 415
     c                   iter
     c                   endif

      *-> escludo gli ordini del segmento ATF vengono gestiti dal back-office
      *   Non devono essere chiusi né revocabili impostando il flag OFL16 = 'N'
     c                   If        OFlg3 = 611
     c                   If        OFl16 = ' '
     c     OnRif         Chain     OrdPP1l
     c                   If        %Found(OrdPP1l)

     c                   Eval      OFl16 = 'N'
     c                   If        Oambi = 'D'
     c                   Exsr      LOCKORD
     c                   Update    ROrdPd
     c                   Else
     c                   Update    ROrdPv
     c                   EndIf

     c                   endif
     c                   endif

     c                   if        OAmbi ='D'
     c                   Unlock    ORDLCK0F
     c                   endif

     c                   Iter
     c                   endif

     c*-> escludo gli ordini stop-loss in attesa
     c*-> escludo gli ordini CASTA in attesa Osta1 ='P' and OFl15 <> ''
gra01c                   if        osta1 ='P' and (oflgs='S' or oflgs = 'T'
gra01c                                             or ofl15 <>' ')
gra01c                   iter
gra01c                   endif

     c* Chiudo solo gli ordini
     c* che siano  AZ/CW/MO
gra01c                   if        oflg2 <> 'M' and oflg2 <> 'S'
gra01c                             and oflg2 <> 'B'
gra01c                   iter
gra01c                   endif

     c* CHIUSURA
     c* ========
     c                   move      *blank        p§err
     c                   move      *blank        p§nrf
     c                   move      onrif         p§nrf
     c                   if        Oambi = 'D'
     c                   exsr      LOCKORD
     c                   CallP     ModChiu(DsChiudi)
                         Else;
                          Eval-Corr DsChiuPrivate = DsChiudi;
                          DsChiuPrivate.P§ERR = 'ANN';
                          DsChiuPrivate.P§TSDT = %Timestamp();
                          //DsChiuPrivate.P§PDN  = ;
                          //DsChiuPrivate.P§EXID = ;
                          PrvChiu(DsChiuPrivate);
                         EndIf;
      *
      *Se l'ordine scaduto aveva un ordine in attesa chiudo anche questo
     c                   If        OFlg8 = '*'
     c     OnRif         Chain(n)  ordppzl

     c                   Eval      P§Nrf = OnRif
     c                   Eval      P§Err = 'ANN'

                         If Oambi ='D';
     c                   CallP     ModChiu(DsChiudi)
                         Else;
                          Eval-Corr DsChiuPrivate = DsChiudi;
                          DsChiuPrivate.P§TSDT = %Timestamp();
                          //DsChiuPrivate.P§PDN  = ;
                          //DsChiuPrivate.P§EXID = ;
                          PrvChiu(DsChiuPrivate);
                         EndIf;

     c                   EndIf

     c                   If        Oambi = 'D'
     c                   unlock    ORDLCK0F                             65
     c                   EndIf

     c* salvo valori attuali x lista
     c                   eval      wsta1 = osta1
     c                   eval      wsta2 = osta2

     c* Riaggancio l'ordine per avere la nuova situazione
     c     onrif         chain(n)  OrdPP1l                            15

     c* Stampa ordini revocati
     c                   if        newpag='Y'
     c                   move      'N'           newpag
     c                   except    xint
     c                   endif
     c                   except    xdet
     c   of              move      'Y'           newpag

     c                   enddo

     c                   seton                                        lr
     c*----------------------------------------------------------------
     c     *INZSR        begsr
     c*    ------
     c     *entry        plist
     c                   parm                    p_seg3            3

     c                   endsr
fg   c*---------------------------------------------------------------*
fg   c     lockord       begsr
fg   c*    -------
fg   c     CICLO         tag
fg   c     OCOCL         chain     RORDLCK                              99
fg   c                   if        *in99=*on
fg   c                   eval      wtest='LOCK SU CLIENTE ' + OCOCL
fg   c                   exsr      Alarm
fg   c                   goto      CICLO
fg   c                   endif

     c                   endsr
fg   c*---------------------------------------------------------------*
fg   c     Alarm         begsr
     c*    -----
fg   c* Messaggi operatori di sistema
     c*    -----
     c                   eval      uomsg='MLE018: ' + %trim(wtest) +
     c                               '/' + ONRIF + '/' + OFLG2 + '/' +
     c                               '/' + OTITO

     c                   call      'UOPEMGCAPI'
     c                   parm      ' '           uomode            1
     c                   parm                    uomsg           250
     c                   parm      'C'           uomsgt            1
     c                   parm      '         '   uomsgr           10
     c                   parm      'INOLTRO'     uoclas           10
     c                   parm      '          '  uobase           10

     c                   endsr
     o*--------------------------------------------------------------------*
     oqprint    e            xint            001
     o          e            xint      001
     o                                              'MLE018 - Elenco Ordini'
     o                                              ' Revocati in Chiusura '
     o                                              'al '
     o                       w_t_stamp_D            '    /  /  '
     o                                              ' '
     o                       w_t_stamp_T            '  :  :  '
     o                                              ' Segm.:'
     o                       p_seg3

     o          e            xint      002
     o                                              'Riferimento--- Titolo '
     o                                              'O Data Scad. 1 2 1 2'

     o          e            xdet      001
     o                       onrif
     o                                              ' '
     o                       otito
     o                                              ' '
     o                       otpop
     o                                              ' '
     o                       ofld3                  '    /  /  '
     o                                              ' '
     o                       wsta1
     o                                              ' '
     o                       wsta2
     o                                              ' '
     o                       osta1
     o                                              ' '
     o                       osta2