**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTCLOB)
  Text('Elabora richiesta di chiamate http in batch');
// ___________________________________________________________________

Dcl-Pr TESTCLOB ExtPgm('TESTCLOB');
End-Pr TESTCLOB;

Dcl-Pi TESTCLOB;
End-Pi TESTCLOB;

// ____________________________________________________________________________
Dcl-S OutputClob       SqlType(Clob_File) ccsid(1208);
Dcl-S OutputBlob       SqlType(Blob_File);
Dcl-S HttpOptions      VarChar(2000);
Dcl-S HttpHeader       SqlType(Xml_Clob :10000) ccsid(1208);
Dcl-C SQLOK             '00000';
Dcl-C SQLEOF            '02000';

//  Main Line
// ___________________________________________________________________

*Inlr = *On;

Exec Sql
  Set Option Datfmt = *Iso,
             Timfmt = *Iso,
             Closqlcsr = *EndActGrp,
             Commit = *chg;

HttpOptions = '{"connectTimeout":"5","redirect" : "10", "header":"content-type, accept, image/webpd"}';

OutputClob_Name = '/home/paolos/test.jpeg';
OutputClob_NL   = %Len(%Trim(OutputClob_Name));
OutputClob_FO   = SQFOVR; // OverWrite

Exec Sql
    Select  Qsys2.Http_Get('http://httpbin.org/image', :HttpOptions)
      into :OutputClob;

If (SqlState = SQLOK);
  Exec Sql Commit;
EndIf;

// the result of this is:
// HTTPTransportException: Problem occurred when receiving the stream.
// No data available for message.

OutputBlob_Name = '/home/paolos/testblob.jpeg';
OutputBlob_NL   = %Len(%Trim(OutputBlob_Name));
OutputBlob_FO   = SQFOVR; // OverWrite

HttpHeader_Data = '<httpHeader>+
                      <header name="content-type" value="accept, image/webpd" />+
                    </httpHeader>';
HttpHeader_Len  = %len(%Trim(HttpHeader_Data));
Exec Sql
    Values Systools.HttpGetBlob('http://httpbin.org/image', :HttpHeader)
      into :OutputBlob;

If (SqlState = SQLOK);
  Exec Sql Commit;
EndIf;

Return;
