**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  BndDir('AL400MNUV2')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTBLOB)
  Text('Elabora richiesta di chiamate http in batch');
// ___________________________________________________________________

/copy Al400mnuv2/QRpgleSrc,UMiFunc_h
// Prototipi
Dcl-Pr TESTBLOB ExtPgm('TESTBLOB');
End-Pr TESTBLOB;

Dcl-Pi TESTBLOB;
End-Pi TESTBLOB;

// ____________________________________________________________________________
Dcl-S Method           VarChar(10);
Dcl-S HttpOptions       VarChar(1000);
Dcl-S Url              VarChar(1000);
Dcl-S RequestMsg       SqlType(Clob : 16773100);
Dcl-S OutPutPgm        Char(10);
Dcl-S OutPutType       Char(10);
Dcl-S OutPutStmf       VarChar(640);
Dcl-S OutputClob       SqlType(Clob:16773100) ccsid(65535);
Dcl-S OutputBlob       SqlType(Blob:16773100);
Dcl-S OutputFileBlob   SqlType(Blob_File);
Dcl-S OutputFileClob   SqlType(Clob_File) ccsid(1208);

Dcl-S DataLen           Int(10);
Dcl-S Data              Char(20);
Dcl-S Rc                Int(10);
Dcl-S RcChar            Char(1);
Dcl-S RowId             Int(10);
Dcl-S SqlError          Like(SqlState);
Dcl-S QueuePointer      Pointer(*proc);
Dcl-C REPLACENO         '*NO';
Dcl-C FIFO              'F';
Dcl-C KEYLEN0           0;
Dcl-C WAIT2SEC          2;
Dcl-C MESSAGELEN20      20;
Dcl-C STMF              'STMF';
Dcl-C GET               'GET';
Dcl-C CLOB              'CLOB';
Dcl-C POST              'POST';
Dcl-C BLOB              'BLOB';
Dcl-C XML               'XML';
Dcl-C SQLOK             '00000';
Dcl-C SQLEOF            '02000';
Dcl-C RCOK              '0';
Dcl-C STMFCHAR          'STMFCHAR';



//  Main Line
// ___________________________________________________________________

*Inlr = *On;

Exec Sql
  Set Option Datfmt = *Iso,
             Timfmt = *Iso,
             Closqlcsr = *EndActGrp,
             Commit = *Chg;

Url = 'https://www1.directatrading.com/mchart_table_bnpparibas.zip';
HttpOptions = '{"header" : "Content-type,application/octet-stream", "header" :"Content-Transfer-Encoding,Binary", +
                "header": "Content-Description,File Transfer", "header": "Accept-Encoding: gzip, deflate, br", +
                "header": "Accept-Ranges, bytes" , "header": "Accept, *", "header" :"Content-Encoding, compress" +
                }';

OutputFileBlob_Name = '/home/paolos/test.zip';
OutputFileBlob_NL   = %Len(%Trim(OutputFileBlob_Name));
OutputFileBlob_FO   = SQFOVR; // OverWrite

Exec Sql
  Set :OutputBlob = Blob( QSys2.Http_Get(:Url, :HttpOptions));
Exec Sql
  Set :OutputFileBlob = :OutputBlob;

Exec Sql Commit;

Return;
