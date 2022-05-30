SKIPPED = common

SUBDIRS := $(wildcard */.)

SUBDIRS := $(SUBDIRS:/.=)                        # Trim "/." suffix
SUBDIRS := $(filter-out $(SKIPPED), $(SUBDIRS))  # Remove skipped

FILTER ?= test_
SUBDIRS := $(foreach v, $(SUBDIRS), $(if $(findstring $(FILTER), $(v)), $(v), ))

.PHONY: all
all: $(SUBDIRS)
	python summary.py $(SUBDIRS)

.PHONY: clean
clean: $(SUBDIRS)

$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: $(SUBDIRS)
