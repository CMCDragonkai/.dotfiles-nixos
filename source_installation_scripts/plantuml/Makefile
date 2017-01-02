.PHONY: install uninstall

TEMPDIR := $(shell mktemp -d)

install:
	cd "$(TEMPDIR)"
	curl -L -o ./plantuml.jar http://sourceforge.net/projects/plantuml/files/plantuml.jar/download
	install --mode=755 -D "./plantuml.jar" /usr/local/bin
	cd -
	rm -rf "$(TEMPDIR)"
	
uninstall:
	rm --force /usr/local/bin/plantuml.jar