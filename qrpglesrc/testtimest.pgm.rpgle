**free

dcl-S dataorachar		VarChar(21)	 Inz('20260701150005123456');
dcl-S dataora       Timestamp

dataora	= %timestamp(%Dec(dataorachar :21 :0))

return;

