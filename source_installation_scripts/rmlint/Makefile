.PHONY: install uninstall

SRCDIR := $(HOME)/.src/rmlint

install:
	mkdir --parents "$(SRCDIR)"
	git clone --branch develop https://github.com/sahib/rmlint.git "$(SRCDIR)"
	cd "$(SRCDIR)" && scons config && scons -j4 --prefix=/usr install

uninstall:
	cd "$(SRCDIR)" && scons uninstall
