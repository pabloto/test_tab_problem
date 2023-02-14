BIN_LIB=PAOLOS
LIBLIST=JDET GESTSIMDAT ROBERTO AL400SYS AL400MNUV2 MESSA
SHELL=/QOpenSys/pkgs/bin/bash
UTFTPCR=utftpcr
UTCRUSR1C=utcrusr1c
CHGPGM="CHGOBJOWN OBJ($(BIN_LIB)/$*) OBJTYPE(*PGM) NEWOWN(QSECOFR)"
COMMAND=""


all: testcalo.rpgle testblob.sqlrpgle testclob.sqlrpgle testdatora.rpgle testjson1.sqlrpgle testcont.sqlrpgle rtvlck01r.sqlrpgle
	testcont1.sqlrpgle testthread1.rpgle testthread.rpgle recaptcha1.sqlrpgle recaptchat.rpgle testcont2.sqlrpgle testcont4.sqlrpgle
	zordj2.sqlrpgle testwpos.rpgle

%.sqlrpgle:
	system -s "CHGATR OBJ('./qrpglesrc/$*.sqlrpgle') ATR(*CCSID) VALUE(1208)"
	system "CPYFRMSTMF FROMSTMF('./qrpglesrc/$*.sqlrpgle') TOMBR('/DIRECTA1/QSYS.LIB/$(BIN_LIB).LIB/QRPGLESRC.FILE/$*.MBR') MBROPT(*replace)"
	system -s "CRTPF FILE(QTEMP/UTFTPCWWIN) RCDLEN(80) TEXT('Redirezione ftp input')"
	liblist -a $(LIBLIST);\
	system  "CRTSQLRPGI OBJ($(BIN_LIB)/$*) SRCSTMF('./qrpglesrc/$*.sqlrpgle') OPTION(*EVENTF) CVTCCSID(*JOB)"

%.rpgle:
	@echo $(CURDIR)
	@echo $(USER)
	@echo $(BRANCH)
#	system -s "CHGATR OBJ('./qrpglesrc/$*.rpgle') ATR(*CCSID) VALUE(1208)"
	system "CPYFRMSTMF FROMSTMF('./qrpglesrc/$*.rpgle') TOMBR('/DIRECTA1/QSYS.LIB/$(BIN_LIB).LIB/QRPGLESRC.FILE/$*.MBR') MBROPT(*replace)"
	liblist -a $(LIBLIST);\
	system -s "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('./qrpglesrc/$*.rpgle') OPTION(*EVENTF) TGTCCSID(*JOB)"

%.rpgmod:
	system -s "CHGATR OBJ('./qrpglesrc/$*.rpgmod') ATR(*CCSID) VALUE(1208)";
	system -s "CPYFRMSTMF FROMSTMF('./qrpglesrc/$*.rpgmod') TOMBR('/DIRECTA1/QSYS.LIB/$(BIN_LIB).LIB/QRPGLESRC.FILE/$*.MBR') MBROPT(*replace)";
	system -s "chgcurlib curlib($(BIN_LIB))";\
	system -s "CRTRPGMOD MODULE($(BIN_LIB)/$*) SRCSTMF('./qrpglesrc/$*.rpgmod') OPTION(*EVENTF) TGTCCSID(*JOB)";\

%.clle:
# istruzioni speciali in caso di compilazione di UTCRUSR1C
ifeq ($*, $(UTCRUSR1C))
	@echo 'change authority'
	COMMAND = $(CHGPGM)
	@echo $(COMMAND)
endif
	@echo $*
	system -s "CHGATR OBJ('./qclsrc/$*.clle') ATR(*CCSID) VALUE(1208)"
	system "CPYFRMSTMF FROMSTMF('./qclsrc/$*.clle') TOMBR('/DIRECTA1/QSYS.LIB/$(BIN_LIB).LIB/qclsrc.FILE/$*.MBR') MBROPT(*replace)"
	liblist -a $(LIBLIST);\
	system -s "CRTBNDCL PGM($(BIN_LIB)/$*) SRCSTMF('./qclsrc/$*.clle') OPTION(*EVENTF) "
	system -s $(COMMAND)

%utcrusr1c.clle:
# 	@echo $*
# 	system -s "CHGATR OBJ('./qclsrc/$*.clle') ATR(*CCSID) VALUE(1208)"
# 	system "CPYFRMSTMF FROMSTMF('./qclsrc/$*.clle') TOMBR('/DIRECTA1/QSYS.LIB/$(BIN_LIB).LIB/qclsrc.FILE/$*.MBR') MBROPT(*replace)"
# 	liblist -a $(LIBLIST);\
# 	system -s "CRTBNDCL PGM($(BIN_LIB)/$*) SRCSTMF('./qclsrc/$*.clle') USRPRF(*OWNER) OPTION(*EVENTF)"
# 	system "CHGOBJOWN OBJ($(BIN_LIB)/$*) OBJTYPE(*PGM) NEWOWN(QSECOFR)"

%.sql:
#	sed -i.bak "s/BIN_LIB/$(BIN_LIB)/g" ./$*.sql
	system -v "RUNSQLSTM SRCSTMF('./qddspf/$*.sql') COMMIT(*NONE)"

%.cmd:
	system - v "CRTCMD CMD($(BIN_LIB)/$*) PGM($(BIN_LIB)/$*) SRCSTMF('./qcmdsrc/$*.cmd') TEXT('HTTP Client via sql') ALLOW(*BPGM *IPGM)"