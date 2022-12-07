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
  DftName(TESTCALO)
  Text('Test CALOPM');

// Partendo dall'ultimo giorno del mese ottengo ultimo giorno di valuta compreso nel mese
//  e data operazione relativa a quella valuta


Dcl-Pr CalOpmr extpgm('CALOPMR');
  Mercato     Char(4) Const;
  Data        Char(8) Const;
  Paese       Char(2) Const;
  AddDay      Char(2) Const;
  DataOperaz  Char(8);
End-Pr;

Dcl-Pr CalVamr extpgm('CALVAMR');
  Mercato     Char(4) Const;
  Data        Char(8) Const;
  Paese       Char(3) Const;
  AddDay      Char(2) Const;
  DataValuta  Char(8);
End-Pr;
// ________________________________________________________
//      Campi di work
Dcl-S DataOperazChar  Char(8);
Dcl-S DataValuta      Char(8);
Dcl-S DataOperaz      Char(8);
Dcl-S DataInput       Char(8);
Dcl-S Idx             Uns(3);
Dcl-S IdxFor          Int(5);

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

Dcl-Ds TextMsg;
  TextArr Char(80) Dim(24);
End-Ds TextMsg;
// ___________________________________________________________________________

DataOperazChar = '20200131';

For IdxFor = 1 To 24;

  CalOpmr('BITA':DataOperazChar :'':'-0':DataOperaz);

  DataValuta = '99999999';
  Idx = 0;
  Dow DataValuta >= DataOperazChar;

    CalVamr('BITA':DataOperaz:'':'+1':DataValuta);
    If DataValuta <= DataOperazChar;
      Leave;
    EndIf;

    Idx += 1;
    DataInput = DataOperaz;
    CalOpmr('BITA':DataInput :'':'-' + %Trim(%Char(Idx)) :DataOperaz);

  EndDo;
  TextArr(IdxFor) = 'Start: '+ DataOperazChar + ' Valuta: ' + DataValuta + ' OPM-' + %Trim(%Char(Idx)) + ': ' + DataOperaz;

  DataOperazChar = %Char((%Date(%Dec(DataOperazChar: 8 : 0)) +%Days(1) +  %months(1) - %Days(1)):*Iso0);

EndFor;

DspLongMsg(TextMsg:%Len(TextMsg):'':'':ApiError);

Return;