**FREE
// Elabora richiesta di chiamate http fatte da un programma esterno
Dcl-S Ora		      packed(6)	 Inz(133000);
Dcl-S data        Packed(8)  Inz(20220205);
Dcl-S dataOra     Timestamp(9);

dataora	= %timestamp(%Date(data) + %Time(Ora));

Return;

