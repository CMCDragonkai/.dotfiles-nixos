# .dotfiles #

This directory is meant to be located in `~/.dotfiles`. It's files are supposed to be symlinked into `~`.

We can should have a bash script that basically symlinks only files and creates folders. Nothing else.

External dependencies are managed via git submodules. This facilitates component based development, where these dependencies have their own life cycle.

```
# add the master branch of prezto as a submodule
git submodule add -b master git@github.com:sorin-ionescu/prezto.git
# update the submodule to the latest master
git submodule update --remote prezto
```

Installation is:

```
cd ~
git clone --recursive https://github.com/CMCDragonkai/.dotfiles.git
```

SSH Keys are not stored in `~/.ssh` and the `~/.ssh/hosts` file is not stored there either. Make sure to securely transfer all keys and hosts file into `~/.ssh` before using.

```
scp ~/.ssh/identity cmcdragonkai@X.X.X.X:~/.ssh/identity
scp ~/.ssh/identity.ppl cmcdragonkai@X.X.X.X:~/.ssh/identity.ppk
scp ~/.ssh/hosts cmcdragonkai@X.X.X.X:~/.ssh/hosts
scp -r ~/.ssh/keys/ cmcdragonkai@X.X.X.X:~/.ssh/keys
```

We need a file that dictates the system dependencies required for this user configuration to work. Similar to import_exec.

While we have a local bin folder. This should contain shell utilities that can be executed for convenience to figure out things. They are each executables. Some of them are only relevant to Windows.

Definitely symlink files, and only create directories!

Where do I get the /usr/share/nano files? It would have to be part the /nix/store. Perhaps a symlink there? Is it available via static? How does a user specific script acquire the store path of a executable on the system?

May need to create a compilation system to make for windows or make for linux. We already have conditional aspects of the configuration suited to Windows or Linux. We can use compiler flags like preprocessors that embed or disembed. Or we can create 2 different versions of the same file. I think preprocessor flags would be the best. Investigate Shake.

# I also want one for rsync? And one for ssh where we forget about host key, like force option
# also something to automate nc with gpg, or gpg with talk
# nc require a listener and a transmitter, but the listener is just activated ad-hoc
# while talk requires a daemon, which can be port activated (talk uses port 518?)
# While talkd is available in inetutils, there's no service file for it yet that is port activated
# so... yea.
# https://wiki.archlinux.org/index.php/Talkd_and_the_talk_command
# ntalk is port 518 UDP and TCP #

Did GPG, Make/M4, Shake, GPG with netcat, talk/talkd, inetutils, Nixpkgs and the /usr/share problem (files inside packages that aren't binaries), SSH related utilities and rsync, global gitignore ignoring common temporary files like Vim swap files

When deploying on Windows. We need to first install Cygwin.

When deploying on Windows, we need to also build https://github.com/rprichard/winpty project. Attach it as a submodule here too. The resulting binaries need to be put into `~/.bin`. Many windows specific executables are to be symlinked with `console`. If you don't know. Leave it as is. This package is needed for Windows GHCI, Windows Python... etc. In most cases you want Cygwin executables. But somethings cannot be built on Cygwin yet. So you use Windows executables.

When deploying on Windows, somethings we cannot symlink. Instead either a shortcut or an NTFS symbolic link must be used. For example the Documents/WindowsPowerShell/Profile.ps1. Use the `mklink` alias to do this.

The below needs to run once on installation on Windows. The environment variable has to be on Windows machine, not shell specific environment variable.

```
setx CYGWIN "nodosfilewarning"
```

The first step on Windows, is to first get Cygwin. And then run any build tools. Such a build tool needs to be immediately accessible from Linux and Cygwin easily. That makes Shake a bad idea. Even Make a bad idea. Ultimately we just need a simple `install.sh` script.

Linux install script shouldn't symlink things that have `.ps1` or `.exe` or `.bat` or `.cmd` in them! And empty folders should also be ignored once files are ignored.