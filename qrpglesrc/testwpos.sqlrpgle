**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Bnddir('AL400MNUV2': 'WEBSCKDIR' : 'TESTBND')
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTWPOS)
  Text('Test contattone');
// ___________________________________________________________________
/Include QSYSINC/QRPGLESRC,PTHREAD
/Include Roberto/qrpglesrc,copy_pr
/Include Roberto/qrpglesrc,copy_ds

/copy Al400mnuv2/QRpgleSrc,UMiFunc_h
// Prototipi
Dcl-Pr TESTWPOS ExtPgm('TESTWPOS');
End-Pr TESTWPOS;

Dcl-Pi TESTWPOS;
End-Pi TESTWPOS;

Dcl-S ThreadId    Char(20);
Dcl-S ThreadIdPt  Pointer Inz(%addr(threadid));

Dcl-S WPos Int(5);
// ____________________________________________________________________________

*Inlr = *on;

// passa descrittore al thread, con pad x'00'
Clear WPos;
DoW (WPos < 20);
  WPos = %Len(%Trim(ThreadId));
  If (WPos < 20);
    %SubSt(ThreadId :WPos +1 :1) = x'00';
    Iter;
  EndIf;
EndDo;


Return;
