**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Dcl-S dataorachar		VarChar(21)	 Inz('20220408150005123456');
Dcl-S dataora       Timestamp;

dataora	= %timestamp(%Dec(dataorachar :21 :0));

Return;

