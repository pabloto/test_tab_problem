**free
Ctl-Opt
  dftactgrp(*no) actgrp('QILE')
  bnddir('ROBERTO/ROBERTO')
  option(*nounref :*srcstmt :*nodebugio)
  datfmt(*iso) timfmt(*iso) DecEdit('0,')
  debug
  alwnull(*usrctl)
  DftName(RUNCGIP)
  Text('Lancio CGI interattivamente x debug');

// ________________________________________________________________
// ________________________________________________________________
// files
// ________________________________________________________________
Dcl-f RUNCGIV workstn indds(WsInd);
// ________________________________________________________________
// prototipi
// ________________________________________________________________
Dcl-Pr  RUNCGIP  extpgm('RUNCGIP');
End-Pr;
// ________________________________________________________________
Dcl-Pr QtmhPutEnv extproc('QtmhPutEnv');
  *n pointer value; // ZhbCmd
  *n Int(10) const; // ZhbRspLen
  *n Like(qusec); // QUsec
End-Pr;
// ________________________________________________________________
Dcl-Pr PgmCGI extpgm(CgiName);
End-Pr;
// ________________________________________________________________
Dcl-Pr conttest extproc('CONTTEST') likeds(ContTestDS);
  *n varchar(32) const;
  *n varchar(20) const;
  *n varchar(1) const options(*nopass);
End-Pr;

Dcl-PR QtmhRdStin Int(10) extproc('QtmhRdStin');
  buf            Pointer    value;
  inplen            Int(10)    value;
  outlen            Int(10);
  *n Like(qusec); // QUsec
End-PR;

Dcl-PR read Int(10) extproc('read');
  fd             Int(10)    value;
  buf            Pointer    value;
  len            Int(10)    value;
End-PR;
// ________________________________________________________________
// strutture/campi
// ________________________________________________________________
Dcl-Ds WsInd Qualified;
  Exit          Ind Pos(3);
End-Ds;

Dcl-ds ContTestDS len(100);
  RetCode4  char(4);
  TokenOutput char(32);
  UserOut char(5)    overlay(TokenOutput:1);
  CollOut zoned(8:0) overlay(TokenOutput:17);
  ContOut zoned(8:0) overlay(TokenOutput:25);
  HttpsOut char(3);
  ModoOut char(4);
  ParamOut  char(50);
  fill char(7);
End-ds;

// x PutEnv
Dcl-S   envBuffer    VarChar(512);
Dcl-S   dataReadStd    Char(10000) ccsid(1208);
Dcl-S   dataRead    Char(31138) ccsid(1208);
Dcl-S   outlen       Int(10);

// Struttura errori
Dcl-Ds qusec;
  qusbprv Int(10) inz(%size(qusec)); // Bytes Provided
  qusbavl Int(10) inz(0); // Bytes Available
  qusei Char(7); // Exception Id
  *n Char(1); // Reserved
  msgdata Char(500);
End-Ds;

Dcl-S   CgiName    char(10);
Dcl-S   numIP    char(15);

// ________________________________________________________________
// main
// ________________________________________________________________
WsInd.Exit = *off;

dow (not WsInd.Exit);
  ExFmt REC00R;
  VERROR = *blank;
  if (WsInd.Exit);
    return;
  endif;
  if (%len(%trim(VTOKEN)) <> 32);
    VERROR = 'Immettere il token';
    iter;
  endif;
  if (%len(%trim(VPARAM)) = 0);
    VERROR = 'Immettere i parametri';
    iter;
  endif;
  if (%len(%trim(VNAMCGI)) = 0);
    VERROR = 'Immettere il nome del CGI da richiamare';
    iter;
  endif;
  ContTestDS=conttest(VTOKEN:'RUNCGI');
  If (RetCode4<>'OKAY' and UserOut=*BLANK);
    VERROR = 'Token non valido';
    iter;
  EndIf;
  
  Exec Sql
    Select hnuip into :numIP 
      from roberto/hstcol0f 
      where huten=:UserOut and hnrco=:CollOut;

  If (SqlState = '02000');
    VERROR = 'Token non valido';
    iter;
  EndIf;
  leave;
enddo;

// wuser = UserOut;

envBuffer = 'REMOTE_ADDR=' + %trim(numIP);
Callp(e) QtmhPutEnv(%addr(envBuffer:*data):%len(envBuffer):qusec);
If (%Error or QUsbAvl > 0);
  Return;
EndIf;

envBuffer = 'REQUEST_METHOD=GET';
Callp(e) QtmhPutEnv(%addr(envBuffer:*data):%len(envBuffer):qusec);
If (%Error or QUsbAvl > 0);
  Return;
EndIf;

envBuffer = 'CGI_MODE=%%EBCDIC%%';
Callp(e) QtmhPutEnv(%addr(envBuffer:*data):%len(envBuffer):qusec);
If (%Error or QUsbAvl > 0);
  Return;
EndIf;

envBuffer = 'QUERY_STRING=' + %trim(VPARAM);
Callp(e) QtmhPutEnv(%addr(envBuffer:*data):%len(envBuffer):qusec);
If (%Error or QUsbAvl > 0);
  Return;
EndIf;

CgiName = VNAMCGI;
PgmCGI();

outlen = read(0: %addr(dataRead): %size(dataRead));
QtmhRdStin(%Addr(dataReadStd):%size(dataReadStd):outlen:qusec);


Return;