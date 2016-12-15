.PHONY: install uninstall

TEMPDIR := $(shell mktemp -d)

install:
	git clone https://github.com/npat-efault/picocom "$(TEMPDIR)"
	$(MAKE) --directory="$(TEMPDIR)"
	install --mode=755 -D "$(TEMPDIR)/picocom/picocom.exe" /usr/local/bin
	install --mode=755 -D "$(TEMPDIR)/picocom/picocom.1" /usr/local/man/man1
	rm -rf "$(TEMPDIR)"
	
uninstall:
	rm --force /usr/local/bin/picocom.exe
	rm --force /usr/local/man/man1/picocom.1
