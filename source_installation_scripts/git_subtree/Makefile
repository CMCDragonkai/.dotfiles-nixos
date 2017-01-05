.PHONY: install uninstall

TEMPDIR := $(shell mktemp --directory)

install:
	wget --directory-prefix="$(TEMPDIR)" "https://rawgit.com/git/git/master/contrib/subtree/git-subtree.sh"
	install --mode=755 "$(TEMPDIR)/git-subtree.sh" /usr/local/bin/git-subtree
	rm -rf "$(TEMPDIR)"

uninstall:
	rm --force /usr/local/bin/git-subtree
