.PHONY: all
all:

.PHONY: test
test:
	make -C tests

.PHONY: clean
clean:
	make -C tests clean
