**free
// 
//  Scrittura della usrq per l'invio degli ordini
//   sostituisce la DTAQ
// 
Ctl-Opt
         dftactgrp(*no) actgrp('QILE')
         bnddir('QC2LE' :'AL400MNUV2')
         Thread(*concurrent)
         option(*nounref :*srcstmt :*nodebugio)
         datfmt(*iso) timfmt(*iso)
         debug
         alwnull(*usrctl);
//                               

//  Copy per le funzioni MI
/COPY Al400mnuv2/Qrpglesrc,UMiFunc_h
//                               
dcl-pr OPQUSQEQST ExtPgm('OPQUSQEQST') End-pr;
dcl-pi OPQUSQEQST End-pi;

//                               
dcl-s QueuePointer10    Pointer(*proc) Inz(*null);
dcl-s QueuePointer11    Pointer(*proc) Inz(*null);
dcl-s QueuePointer12    Pointer(*proc) Inz(*null);
dcl-s QueuePointer13    Pointer(*proc) Inz(*null);
dcl-s QueuePointer140   Pointer(*proc) Inz(*null);

dcl-s Signal          Char(20) ;
dcl-c REPLACENO       '*NO';
dcl-c FIFO            'F';
dcl-c KEYLEN0         0;
dcl-c WAIT5SEC        5;
dcl-c MESSAGELEN20    20;
dcl-s USRQNAME        Char(10);
dcl-s Idx int(10) ;
//                                                                 

For idx = 1 to 1000000;
  // PatiotionID 140 Block
  If (QueuePointer140 = *Null);
    USRQNAME = 'OPQUSQ140';
    QueuePointer140 = Mi_GetSysPtr(USRQNAME:'GESTSIMDAT' :'*USRQ');
  EndIf;

  Mi_sndUsrq(QueuePointer140 :MESSAGELEN20 :Signal);

EndFor;

Return;