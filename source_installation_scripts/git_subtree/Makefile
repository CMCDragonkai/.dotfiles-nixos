install:
	wget --directory-prefix="/tmp" "https://rawgit.com/git/git/v$(git --version | cut --delimiter=' ' --fields=3)/contrib/subtree/git-subtree.sh"
	install --mode=755 /tmp/git-subtree.sh /usr/local/bin/git-subtree

uninstall:
	rm --force /usr/local/bin/git-subtree
