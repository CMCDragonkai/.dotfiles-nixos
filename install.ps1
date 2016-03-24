#!/usr/bin/env powershell

# installation for windows
# download https://cygwin.com/setup-x86_64.exe
# download https://cygwin.com/setup-x86
# put it in .bin/cygwin-setup-x86.exe
# put it in .bin/cygwin-setup-x86_64.exe

# for cygwin main pacakges
# .bin/cygwin-setup --quiet-mode --no-shortcuts --no-startmenu --no-desktop --arch x86_64 --no-admin --upgrade-also --root $env:home/cygwin64 --local-package-dir $env:home/cygwin/packages --site http://mirrors.kernel.org/ --packages wget,tar,qawk,bzip2,subversion,vim

# for cygwin ports packages
# .bin/cygwin-setup --quiet-mode --no-shortcuts --no-startmenu --no-desktop --arch x86_64 --no-admin --upgrade-also --root $env:home/cygwin64 --local-package-dir $env:home/cygwin/packages --site ftp://ftp.cygwinports.org/pub/cygwinports --pubkey http://cygwinports.org/ports.gpg --packages wget,tar,qawk,bzip2,subversion,vim

# will need to try the above to see what it means

# consider removing orphans or pruning, we want it to be somewhat idempotent, and without leaving a lot of garbage