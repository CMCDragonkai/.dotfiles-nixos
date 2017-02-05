.PHONY: install uninstall

SRCDIR := $(HOME)/.src/mosh

install:
	rm --recursive --force "$(SRCDIR)"
	mkdir --parents "$(SRCDIR)"
	curl --location https://mosh.org/mosh-1.2.6.tar.gz | tar xvfz - --directory "$(SRCDIR)" --strip-components 1
	cd "$(SRCDIR)" && ./configure && $(MAKE) && $(MAKE) install

uninstall:
	$(MAKE) --directory="$(SRCDIR)" uninstall
