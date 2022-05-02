.PHONY: all
all: tests

.PHONY: tests
tests:
	make -C tests

.PHONY: clean
clean:
	make -C tests clean
