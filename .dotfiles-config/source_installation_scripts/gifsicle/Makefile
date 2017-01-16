.PHONY: install uninstall

SRCDIR := $(HOME)/.src/gifsicle

install:
	rm --recursive --force "$(SRCDIR)"
	mkdir --parents "$(SRCDIR)"
	git clone https://github.com/kohler/gifsicle "$(SRCDIR)"
	cd "$(SRCDIR)" && autoreconf --install && ./configure && $(MAKE) && $(MAKE) install

uninstall:
	$(MAKE) --directory="$(SRCDIR)" uninstall
