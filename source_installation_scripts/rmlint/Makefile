.PHONY: install uninstall

SRCDIR := $(shell mkdir -p '~/.src/rmlint')

install:
	git clone -b develop https://github.com/sahib/rmlint.git "$(SRCDIR)"
	cd "$(SRCDIR)"
	scons config
	scons -j4 --prefix=/usr install
	cd -

uninstall:
	cd "$(SRCDIR)"
	scons uninstall
	cd -
