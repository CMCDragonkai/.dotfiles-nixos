.PHONY: install uninstall

TEMPDIR := $(shell mktemp --directory)

install:
	curl --location --output "$(TEMPDIR)/composer" https://getcomposer.org/composer.phar
	install --mode=755 -D "$(TEMPDIR)/composer" /usr/local/bin
	rm -rf "$(TEMPDIR)"

uninstall:
	rm --force /usr/local/bin/composer
