.PHONY: install uninstall

TEMPDIR := $(shell mktemp --directory)

install:
	curl --location --output "$(TEMPDIR)/winpty.tar.gz" https://github.com/rprichard/winpty/releases/download/0.4.3/winpty-0.4.3-cygwin-2.8.0-x64.tar.gz
	mkdir "$(TEMPDIR)/winpty"
	tar xfz "$(TEMPDIR)/winpty.tar.gz" --directory "$(TEMPDIR)/winpty" --strip-components 1
	install --mode=755 -D "$(TEMPDIR)/winpty/bin/winpty.exe" /usr/local/bin
	install --mode=755 -D "$(TEMPDIR)/winpty/bin/winpty.dll" /usr/local/bin
	install --mode=755 -D "$(TEMPDIR)/winpty/bin/winpty-agent.exe" /usr/local/bin
	install --mode=755 -D "$(TEMPDIR)/winpty/bin/winpty-debugserver.exe" /usr/local/bin
	install --mode 644 -D "$(TEMPDIR)/winpty/lib/winpty.lib" /usr/local/lib
	install --mode 644 -D "$(TEMPDIR)/winpty/include/winpty/winpty.h" /usr/local/include/winpty
	install --mode 644 -D "$(TEMPDIR)/winpty/include/winpty/winpty_constants.h" /usr/local/include/winpty
	install --mode 644 -D "$(TEMPDIR)/winpty/share/doc/winpty/LICENSE" /usr/local/share/doc/winpty
	install --mode 644 -D "$(TEMPDIR)/winpty/share/doc/winpty/README.md" /usr/local/share/doc/winpty
	install --mode 644 -D "$(TEMPDIR)/winpty/share/doc/winpty/RELEASES.md" /usr/local/share/doc/winpty
	rm -rf "$(TEMPDIR)"

uninstall:
	rm -f /usr/local/bin/winpty.exe
	rm -f /usr/local/bin/winpty.dll
	rm -f /usr/local/bin/winpty-agent.exe
	rm -f /usr/local/bin/winpty-debugserver.exe
	rm -f /usr/local/lib/winpty.lib
	rm -rf /usr/local/include/winpty
	rm -rf /usr/local/share/doc/winpty
