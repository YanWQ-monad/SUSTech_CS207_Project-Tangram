SKIPPED = common

SUBDIRS := $(wildcard */.)

SUBDIRS := $(SUBDIRS:/.=)                        # Trim "/." suffix
SUBDIRS := $(filter-out $(SKIPPED), $(SUBDIRS))  # Remove skipped

ifdef FILTER
	SUBDIRS := $(foreach v, $(SUBDIRS), $(if $(findstring $(FILTER), $(v)), $(v), ))
endif

.PHONY: all
all: $(SUBDIRS)
	python summary.py $(SUBDIRS)

.PHONY: clean
clean: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(SUBDIRS)
