.PHONY: install uninstall

TEMPDIR := $(shell mktemp -d)

install:
	cd "$(TEMPDIR)"
	curl -L https://github.com/rprichard/winpty/releases/download/0.4.0/winpty-0.4.0-cygwin-2.5.2-x64.tar.gz | tar xz
	install --mode=755 -D "./winpty-0.4.0-cygwin-2.5.2-x64/bin/winpty.exe" /usr/local/bin
	install --mode=755 -D "./winpty-0.4.0-cygwin-2.5.2-x64/bin/winpty.dll" /usr/local/bin
	install --mode=755 -D "./winpty-0.4.0-cygwin-2.5.2-x64/bin/winpty-agent.exe" /usr/local/bin
	install --mode=755 -D "./winpty-0.4.0-cygwin-2.5.2-x64/bin/winpty-debugserver.exe" /usr/local/bin
	install --mode 644 -D "./winpty-0.4.0-cygwin-2.5.2-x64/lib/winpty.lib" /usr/local/lib
	install --mode 644 -D "./winpty-0.4.0-cygwin-2.5.2-x64/include/winpty/winpty.h" /usr/local/include/winpty
	install --mode 644 -D "./winpty-0.4.0-cygwin-2.5.2-x64/include/winpty/winpty_constants.h" /usr/local/include/winpty
	install --mode 644 -D "./winpty-0.4.0-cygwin-2.5.2-x64/share/doc/winpty/LICENSE" /usr/local/share/doc/winpty
	install --mode 644 -D "./winpty-0.4.0-cygwin-2.5.2-x64/share/doc/winpty/README.md" /usr/local/share/doc/winpty
	install --mode 644 -D "./winpty-0.4.0-cygwin-2.5.2-x64/share/doc/winpty/RELEASES.md" /usr/local/share/doc/winpty
	cd -
	rm -rf "$(TEMPDIR)"

uninstall:
	rm -f /usr/local/bin/winpty.exe
	rm -f /usr/local/bin/winpty.dll
	rm -f /usr/local/bin/winpty-agent.exe
	rm -f /usr/local/bin/winpty-debugserver.exe
	rm -f /usr/local/lib/winpty.lib
	rm -rf /usr/local/include/winpty
	rm -rf /usr/local/share/doc/winpty
