**free
Ctl-Opt  DftActGrp(*no)
  ActGrp(*StgMdl)
  StgMdl(*SNGLVL)
  Thread(*Concurrent)
  Option(*NoUnRef :*SrcStmt :*NoDebugIo)
  DatFmt(*Iso) TimFmt(*Iso)
  Debug(*Constants)
  AlwNull(*UsrCtl)
  DftName(TESTJSON)
  Text('Test Select with json table');
// ____________________________________________________________________________
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

Dcl-S Json_string     VarChar(10000);

// ___________________________________________________________________________

*Inlr = *On;

Exec Sql
  Set Option Datfmt = *Iso,
             Timfmt = *Iso,
             Closqlcsr = *EndActGrp,
             Commit = *none;

Exec Sql
  With Tempemp As (
    Select *
      From Sample.Employee
  )
  Select Json_Object(
      'employeeList' Value Json_Arrayagg(
        Json_Object(
          'empNumber' Value Empno, 'name' Value Firstnme, 'surname' Value Lastname
        )
      )
  ) into :Json_string
    From Tempemp;   


DspLongMsg(Json_string:%Len(Json_string):'':'':ApiError);

Return;