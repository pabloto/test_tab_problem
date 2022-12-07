**FREE
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2' :'WEBSCKDIR')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTSHA2)
  Text('Test sha con iconv');
// ___________________________________________________________________
/copy JDET/QRPGLESRC,WEBSOCSP_H
// ____________________________________________________________________________
// Sha1 prototipo
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


// Base64
Dcl-Pr apr_base64_encode_binary Int(10) ExtProc('apr_base64_encode_binary');
  coded_dst           Char(100) options(*varsize);        // coded_dst
  plain_src           Char(100) options(*varsize) Const;  // plain_src
  source_len          Int(10) Value;                        // source_len
End-Pr apr_base64_encode_binary;

Dcl-Ds ALGD0500_t Qualified Based(Template);
  HashAlg Int(10);
End-Ds ALGD0500_t;

Dcl-Ds DsError len(256);
  BiteAvail bindec(9) Inz(100);
  BiteReturn bindec(9);
  ErrMesg Char(7);
  Reserved1 Char(1);
  MessageDta Char(100);
End-Ds DsError;

Dcl-C HASH_MD5      1;
Dcl-C HASH_SHA1     2;
Dcl-C HASH_SHA256   3;
Dcl-C HASH_SHA384   4;

Dcl-Ds Alg LikeDs(algd0500_t);

// HandShake DataStructure
Dcl-Ds Hs LikeDs(wshandshake) Based(ptrhs);

Dcl-S Host      Char(100);
Dcl-S Origin    Char(100);
Dcl-S Key       Char(100);
Dcl-S Resource  Char(100);

Dcl-S ShaHash           Char(20);
Dcl-S KeyLength         Uns(20);
Dcl-S Rc                Int(10);
Dcl-S ResponseKeyAscii  Char(100) CcsId(1208);
Dcl-S ResponseKey       Char(100);
Dcl-S InputFrame        Char(64000) Based(PtrFrame);
dcl-ds ToUtf8 likeds(iconv_t)  ;
dcl-ds ToEbcdic likeds(iconv_t);
// ____________________________________________________________________________


// Open token for IConv conversion
ToUtf8 = QtqIconvOpen(Utf8: Ebcdic);
ToEbcdic = QtqIconvOpen(Ebcdic :Utf8);

Key = 'sdnklawndioweqnASDNL';

KeyLength = %Len(%Trim(Key)) + %Len(secret);

ResponseKey = %Trim(Key) + Secret;

//  Convert to Ascii to make SHA1
IConvInpDat = ResponseKey;
IConvInpPtr = %Addr(IConvInpDat);
IConvInpLen = KeyLength;
IConvOutPtr = %Addr(ResponseKey);
IConvOutLen = %Size(ResponseKey);
Rc = IConv(ToUtf8: IConvInpPtr :IConvInpLen :IConvOutPtr :IConvOutLen);

KeyLength = %Size(ResponseKey) - IConvOutLen;

Alg.HashAlg = HASH_SHA1;
//  Calculate SHA1 Hash
Qc3CalculateHash( %addr(ResponseKey) :KeyLength :'DATA0100' :Alg
                :'ALGD0500'  :'0' :*OMIT :ShaHash :DsError);

ResponseKey = '';

//  Base64 encode
KeyLength = apr_base64_encode_binary( ResponseKey :ShaHash :%Size(ShaHash)) -1;


Iconv_Close(Utf8);
Iconv_Close(Ebcdic);


Return;