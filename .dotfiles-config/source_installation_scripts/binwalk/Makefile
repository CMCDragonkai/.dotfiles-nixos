.PHONY: install uninstall

SRCDIR := $(HOME)/.src/binwalk

install:
	rm --recursive --force "$(SRCDIR)"
	mkdir --parents "$(SRCDIR)"
	git clone https://github.com/devttys0/binwalk.git "$(SRCDIR)"
	cd "$(SRCDIR)" && python3 setup.py install

uninstall:
	cd "$(SRCDIR)" && python3 setup.py --uninstall
