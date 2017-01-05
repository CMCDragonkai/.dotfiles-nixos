.PHONY: install uninstall

TEMPDIR := $(shell mktemp --directory)

install:
	curl --location --output "$(TEMPDIR)/plantuml.jar" http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
	install --mode=755 -D "$(TEMPDIR)/plantuml.jar" /usr/local/bin
	rm -rf "$(TEMPDIR)"
	
uninstall:
	rm --force /usr/local/bin/plantuml.jar