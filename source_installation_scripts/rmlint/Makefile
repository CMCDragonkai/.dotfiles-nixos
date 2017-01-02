.PHONY: install uninstall

SRCDIR := $(shell mkdir -p "$(HOME)/.src/rmlint")

install:
	git clone -b develop https://github.com/sahib/rmlint.git "$(SRCDIR)"
	cd "$(SRCDIR)" && scons config && scons -j4 --prefix=/usr install

uninstall:
	cd "$(SRCDIR)" && scons uninstall
