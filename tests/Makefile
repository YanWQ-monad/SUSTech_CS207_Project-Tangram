TOPTARGETS := all clean

SUBDIRS := $(wildcard */.)

ifdef FILTER
	SUBDIRS := $(foreach v, $(SUBDIRS), $(if $(findstring $(FILTER), $(v)), $(v), ))
endif

$(TOPTARGETS): $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(TOPTARGETS) $(SUBDIRS)
