SHELL=/QOpenSys/pkgs/bin/bash

%.pgm.rpgle:
	@echo $(CURDIR)
	@echo $(USER)
	@echo $(BRANCH)
	@echo $(CURLIB)
	@echo $(LIBLS)
	liblist -a $(LIBLS);\
	system -s "CRTBNDRPG PGM($(BUILDLIB)/$*) SRCSTMF('$(RELATIVEPATH)') OPTION(*XREF *SECLVL *EVENTF) TGTCCSID(*JOB)"
