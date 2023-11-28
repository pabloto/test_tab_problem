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
  FltDiv(*yes)
  DftName(TESTPWD)
  Text('Test decimali');

// ________________________________________________________
//      Campi di work
/INCLUDE Al400mnuv2/Qrpglesrc,umifunc_h


Dcl-Pr DspLongMsg ExtPgm('QUILNGTX');
  Text      Char(16773100) const options(*varsize);
  Length    Int(10)     Const;
  Msgid     Char(7)     Const;
  Qualmsgf  Char(20)    Const;
  ErrorCode Char(32767) options(*varsize);
End-Pr DspLongMsg;

Dcl-Ds ApiError Qualified;
  BytPrv    Int(10) Inz(%Size(ApiError));
  BytAvl    Int(10) Inz(0);
  MsgId     Char(7);
  *n        Char(1);
  MsgDta    Char(128);
End-Ds ApiError;

Dcl-Ds TextMsg Qualified;
  ArrMsg Char(80) Dim(24);
End-Ds TextMsg;

Dcl-Pr RtvEncUsrPwd ExtPgm('QSYRUPWD');
  RcvVar          Char(3018);
  RcvVarLen       Int(10) Const;
  Format          Char(8) Const;
  Profile         Char(10) Const;
  ApiError        LikeDs(ApiError);
End-Pr RtvEncUsrPwd;

// Record structure for UPWD0100 format
Dcl-Ds QSyd0100 Qualified;    // Qsy RUPWD UPWD0100
  QSYBRTN04 Int(10)   Pos(1); // Bytes Returned
  QSYBAVL04 Int(10)   Pos(5); // Bytes Available
  QSYPN06   Char(10)  Pos(9); // Profile Name
  QSYEP     Char(3000);       // Passwod Cryptata
End-Ds QSyd0100;

Dcl-C APIRTVENCUSRPWDFORMAT     'UPWD0100';
Dcl-C APICALCULATEHASHFORMAT    'ALGD0500';

Dcl-Pr Qc3CalculateHash ExtProc('Qc3CalculateHash');
  InData                 Pointer Value;  // InData
  IndataL                Int(10) Const;  // IndataL
  InDataF                Char(8) Const;  // InDataF
  AlgoDes                Char(16) Const; // AlgoDes
  AlgoFmt                Char(8) Const;  // AlgoFmt
  CryptoSP               Char(1) Const;  // CryptoSP
  CryptoDev              Char(1) Const options( *omit);      // CryptoDev
  Hash                   Char(64) options(*varsize: *omit);  // Hash
  ErrorCode              Char(32767) options(*varsize);      // ErrorCode
End-Pr Qc3CalculateHash;


Dcl-C HASH_MD5      1;
Dcl-C HASH_SHA1     2;
Dcl-C HASH_SHA256   3;
Dcl-C HASH_SHA384   4;

Dcl-S ShaHash           Char(20);
Dcl-S Password          Char(128) ccsid(1208) Inz('PaoloInma2003*');
Dcl-S KeyLength         Uns(20);
Dcl-Ds Alg              LikeDs(algd0500_t);
Dcl-Ds ALGD0500_t Qualified Based(Template);
  HashAlg Int(10);
End-Ds ALGD0500_t;

Dcl-S User                Char(10) Inz('PAOLOS');
Dcl-S WorkString2         VarChar(1000);
Dcl-S WorkString          VarChar(1000);
Dcl-S TextLength          Int(10);

// ___________________________________________________________________________
Exec Sql
  Set Option Datfmt = *Iso,
             Timfmt = *Iso,
             Closqlcsr = *EndActGrp,
             Commit = *none;


RtvEncUsrPwd(QSyd0100 :%Size(QSyd0100) :APIRTVENCUSRPWDFORMAT :User :ApiError);
If (ApiError.BytAvl > 0);
  Return;
EndIf;

Alg.HashAlg = HASH_SHA1;

Qc3CalculateHash( %addr(Password) :%Len(Password) :'DATA0100' :Alg
                  :APICALCULATEHASHFORMAT  :'0' :*OMIT :ShaHash :ApiError);

Exec Sql
    Set :WorkString = Base64_Encode(:ShaHash);
Exec Sql
    Set :WorkString2 = Base64_Encode(:QSyd0100.QSYEP);


TextMsg.ArrMsg(1) = QSyd0100.QSYEP;
TextMsg.ArrMsg(2) = ShaHash;
TextMsg.ArrMsg(3) = WorkString;
TextMsg.ArrMsg(4) = WorkString2;

TextLength = %Size(TextMsg);
DspLongMsg(TextMsg :TextLength :'' :'' :ApiError);


Return;