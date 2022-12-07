**free
Ctl-opt  datfmt(*iso) timfmt(*iso) alwnull(*usrctl) debug;

Dcl-F TESTFILE3     Keyed Usage(*Update :*Delete);

Dcl-Pr TESTCHAIN1 ExtPgm('TESTCHAIN1');
  Parm1 Char(1) Const;
End-Pr TESTCHAIN1;

Chain ('CHIAVE' :1) TESTFILE3;

TestChain1('N');

Return;
