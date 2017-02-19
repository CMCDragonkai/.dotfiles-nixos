.PHONY: install uninstall

SRCDIR := $(HOME)/.src/acme.sh

install:
	rm --recursive --force "$(SRCDIR)"
	mkdir --parents "$(SRCDIR)"
	git clone https://github.com/Neilpang/acme.sh "$(SRCDIR)"
	# this will also opportunistically add itself to automatic renewals via cygwin
	# renewal progress will be logged in the default location
	cd "$(SRCDIR)" && ./acme.sh --install --accountemail "roger.qiu@polyhack.io" --log --certhome '$(HOME)/.local/share/acme' && ./acme.sh _uninstallalias
	ln --symbolic --force "$(HOME)/.acme.sh/acme.sh" "$(HOME)/bin/acme.sh"

uninstall:
	cd "$(SRCDIR)" && ./acme.sh --uninstall
	rm --force "$(HOME)/bin/acme.sh"
