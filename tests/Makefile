TOPTARGETS := all clean

SKIPPED = common

SUBDIRS := $(wildcard */.)

SUBDIRS := $(SUBDIRS:/.=)                        # Trim "/." suffix
SUBDIRS := $(filter-out $(SKIPPED), $(SUBDIRS))  # Remove skipped

ifdef FILTER
	SUBDIRS := $(foreach v, $(SUBDIRS), $(if $(findstring $(FILTER), $(v)), $(v), ))
endif

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(TOPTARGETS) $(SUBDIRS)
