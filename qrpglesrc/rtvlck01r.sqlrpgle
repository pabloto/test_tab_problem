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
   DftName(RTVOBJ01R)
   Text('Retreive lock');

dcl-pr RtvLck01r extpgm('RTVLCK01R');
end-pr;

dcl-pi RtvLck01r;
end-pi;

dcl-s Idx int(5);

dcl-pr uSleep int(10) extproc('usleep');
  *n uns(10) value; // seconds
end-pr;
Dcl-s Library                  Char(10);
Dcl-s Object                   Char(10);
Dcl-s ObjType                  Char(10);
Dcl-s MemberName               Char(10);
Dcl-s DelayTime                     int(10);
// ***********************************************************************
// Main Line

Object = 'PUSHTH0F';
Library= 'GESTSIMDAT';
ObjType= '*FILE   ';
MemberName = 'PUSHTH0F';
Delaytime  = 100;
Dow 1 = 1;
  If %Shtdn;
    Leave;
  EndIf;

  Exec Sql
    Insert into paolos/RtvObj01f
    (SELECT a.*, current timestamp
      FROM QSYS2.OBJECT_LOCK_INFO a WHERE
      SYSTEM_OBJECT_NAME = 'PUSHTH0F' and LOCK_STATUS = 'WAITING' )            ;

  USleep(DelayTime);

EndDo;

*Inlr = *On;
