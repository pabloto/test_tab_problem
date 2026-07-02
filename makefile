SHELL=/QOpenSys/pkgs/bin/bash

%.rpgle:
	@echo $(CURDIR)
	@echo $(USER)
	@echo $(BRANCH)
	@echo $(LIBLS)
	liblist -a $(LIBLS);\
	system -s "CRTBNDRPG PGM($(BIN_LIB)/$*) SRCSTMF('$(RELATIVEPATH)')  OPTION(*XREF *SECLVL *EVENTF) TGTCCSID(*JOB)"