.PHONY: install uninstall

SRCDIR := $(HOME)/.src/picocom

install:
	rm --recursive --force "$(SRCDIR)"
	mkdir --parents "$(SRCDIR)"
	git clone https://github.com/npat-efault/picocom "$(SRCDIR)"
	$(MAKE) --directory="$(SRCDIR)"
	install --mode=755 -D "$(SRCDIR)/picocom/picocom.exe" /usr/local/bin
	install --mode=755 -D "$(SRCDIR)/picocom/picocom.1" /usr/local/man/man1
	
uninstall:
	rm --force /usr/local/bin/picocom.exe
	rm --force /usr/local/man/man1/picocom.1
