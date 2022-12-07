**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(RECAPTCHA1)
  Text('Verifica validità Recaptcha');
// __________________________________________________________________
//   Verifica validità Recaptcha
Dcl-Pr RECAPTCHA1 Extpgm('RECAPTCHA1');
  Rc          Int(10);
  RcMessage   VarChar(100);
  Token       VarChar(1000);
End-Pr RECAPTCHA1;

Dcl-Pi RECAPTCHA1;
  Rc          Int(10);
  RcMessage   VarChar(100);
  Token       VarChar(1000);
End-Pi RECAPTCHA1;

Dcl-Pr UHttpB11r Extpgm('UHTTPB11R');
  Url                 VarChar(1024) Const;
  InputType           Char(10) Const;
  HttpParm            LikeDs(HttpParm) Const;
  PostParm            VarChar(5000) Const;
  HeaderParm_P        LikeDs(HeaderParm) Const;
  DsBasicAuth         LikeDs(DsBasicAuth) Const;
  HttpMethod          Char(10) Const;
  OutputType          Char(10) Const;
  OutputStmf          VarChar(640) Const;
  OutputPgm           Char(10);
  ConnectionTimeout   Int(5) Const;
  Verbose             Char(1) Const;
  FastSlow            Char(1) Const;
  ReturnCode          Char(10);
  ReturnMsg           VarChar(10000);
  OutputSequence      Int(10);
End-Pr UHttpB11r;

Dcl-Ds HeaderParm Qualified Len(20762) Inz;
  NumList      Int(5);
  ElemPosition Int(5) Dim(20);
End-Ds HeaderParm;

Dcl-Ds HttpHeader Qualified Inz;
  NumElem Int(5);
  Nome    VarChar(30);
  Valore  VarChar(1000);
End-Ds HttpHeader;

Dcl-Ds DsBasicAuth Qualified Inz;
  NumElem      Int(5);
  UserId       VarChar(100);
  Password     VarChar(1000);
End-Ds DsBasicAuth;

Dcl-Ds HttpParm Qualified Len(100722) Inz;
  NumList      Int(5);
  ElemPosition Int(5) Dim(20);
End-Ds HttpParm;

Dcl-Ds HttpPostParm Qualified Inz;
  NumElem Int(5);
  Nome    VarChar(30);
  Valore  VarChar(5000);
End-Ds HttpPostParm;

Dcl-S  HttpCmd         VarChar(1024) ;
Dcl-S  PostParm        VarChar(5000);
Dcl-S  InputType       Char(10);
Dcl-S  HttpMethod      Char(10);
Dcl-S  OutputPgm       Char(10);
Dcl-S  OutputType      Char(10);
Dcl-S  MaxCicli        Int(5);
Dcl-S  ReturnCode      Char(10);
Dcl-S  ReturnMsg       VarChar(10000);
Dcl-S  OutputSequence  Int(10);
Dcl-S  OutputStmf      VarChar(640);

Dcl-Ds ApiError Qualified;
  BytPrv            Int(10) Inz(%Size(ApiError));
  BytAvl            Int(10) Inz(0);
  MsgId             Char(7);
  *n                Char(1);
  MsgDta            Char(128);
End-Ds ApiError;

Dcl-Pr USleep int(10) extproc('usleep');
  seconds uns(10) value;
End-Pr USleep;

// ______________________________________________________________________
// Variabili di work
Dcl-Ds RECAPTCHAD  Len(1000) DtaAra('RECAPTCHAD') Qualified;
  Url           Char(100) Pos(11);
  SecretParm    Char(100) Pos(211);
End-Ds RECAPTCHAD;

Dcl-Ds DsRecaptcha Qualified;
  Success       VarChar(5);
  Challenge_Ts  VarChar(26);
  HostName      VarChar(100);
  EccorCodes    VarChar(200);
End-Ds DsRecaptcha;

Dcl-S NullFields Int(5) Dim(4);

Dcl-C SQLOK             '00000';
Dcl-C RCOK              '0';
Dcl-C URLENCODE         'URLENCODE';
Dcl-C VERBOSENO     'N';
Dcl-C FAST          'F';
Dcl-C TIMEOUT       5;
// ______________________________________________________________________
//  Main

*Inlr = *On;

Exec Sql Set Option DatFmt = *Iso, TimFmt = *Iso, CloSqlCsr = *EndMod,
             DecMpt = *Period, Commit = *None;

Clear Rc;
Clear RcMessage;

//  Reperisco Input
In RECAPTCHAD;

HttpCmd       = %Trim(RECAPTCHAD.Url);
InputType     = URLENCODE;
Clear HttpParm;
HttpParm.Numlist          = 2;

HttpPostParm.NumElem      = 1;
HttpPostParm.Nome         = 'secret';
HttpPostParm.Valore       = %Trim(RECAPTCHAD.SecretParm);
HttpParm.ElemPosition(1)  = %Len(HttpParm.Numlist) + %Len(HttpParm.ElemPosition(1));
%Subst(HttpParm : HttpParm.ElemPosition(1) + 1 :%Len(HttpPostParm)) = HttpPostParm;

Clear HttpPostParm;
HttpPostParm.NumElem      = 1;
HttpPostParm.Nome         = 'response';
HttpPostParm.Valore       = Token;
HttpParm.ElemPosition(2)  = %Len(HttpParm.Numlist) +%Len(HttpParm.ElemPosition(1)) *2 + %Len(HttpPostParm);
%Subst(HttpParm : HttpParm.ElemPosition(2) + 1 :%Len(HttpPostParm)) = HttpPostParm;

Clear PostParm;

HeaderParm.Numlist    = 1;
HttpHeader.NumElem    = 1;
HttpHeader.Nome       = 'Accept';
HttpHeader.Valore     = 'application/json';
HeaderParm.ElemPosition(1) = %Len(HeaderParm.Numlist) + %Len(HeaderParm.ElemPosition(1));
%Subst(HeaderParm : HeaderParm.ElemPosition(1) + 1 :%Len(HttpHeader)) =  HttpHeader;

HttpMethod = 'GET';
OutputType = 'CLOB';
MaxCicli   = 200;

//  Chiamata Attraverso UHTTPBCH
UHttpB11r(HttpCmd :InputType :HttpParm :PostParm :HeaderParm :DsBasicAuth
        :HttpMethod :OutputType :OutputStmf :OutputPgm :TIMEOUT
        :VERBOSENO :FAST :ReturnCode :ReturnMsg :OutputSequence);
If (ReturnCode <> RCOK);
  Rc = %Int(ReturnCode);
  RcMessage = ReturnMsg;
EndIf;

Exec Sql
  Select Recaptcha.* Into :DsRecaptcha :NullFields
    From Uhttpbch1f, Json_Table(
          Outputclob,
          'lax $'
          Columns(
            success       Varchar(5)    Path 'lax $.success',
            Challenge_Ts  Varchar(26)   Path 'lax $.challenge_ts',
            hostname      Varchar(100)  Path 'lax $hostname',
            Errorcodes    Varchar(200)  Path 'lax $.error-codes'
          )
        ) As Recaptcha
    where RowId = :OutputSequence;

//  In caso di errore mando messaggio ed esco
If (SqlState <> SQLOK and SqlState <> '01545');
  Rc = -1;
  RcMessage = 'Errore sql: ' + SqlState;
EndIf;



Return;