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

Interesting resource: http://stackoverflow.com/a/21233990/582917

Scrollback buffer search in Mintty doesn't work because of ConEmu. Can ConEmu replace this functionality? Or somehow let this pass?

Mintty
------

Useful shortcuts (see the rest at the Mintty manual `man mintty`):

* <kbd>Alt</kbd> + <kbd>Enter</kbd> - Enter and Exit Full Screen - doesn't work
* <kbd>Ctrl</kbd> + <kbd>+</kbd>/<kbd>-</kbd> - Font Zooming
* <kbd>Shift</kbd> + <kbd>Up</kbd>/<kbd>Down</kbd> - Scroll Line Up and Down
* <kbd>Shift</kbd> + <kbd>PgUp</kbd>/<kbd>PgDn</kbd> - Scroll Page Up and Down
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd>/<kbd>V</kbd> - Copy & Paste
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> - Search Scrollback Buffer
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> - Switch screens between orimary buffer and secondary buffer (like between shell and less or shell and vim)

Some shortcuts are not available because they are replaced by ConEmu equivalents.

We prefer ASCII DEL `^?` to be used for backwards delete instead of ASCII BS `^H`. Instead `^H` can be mapped to nother functions. Forwards delete still uses `\e[3~`. Preferably if the design of keyboards and terminals were standardised, we could have ASCII DEL for forwards delete, and ASCII BS for backwards delete, but alas it is not so.

Consolas is the chosen font at 13 point size for Mintty. Consolas is a monospaced programming font, and is already installed with Windows. It also has a wide range of glyphs and supports interesting kinds of unicode glyphs.

We're using a solarized dark scheme.

Use http://terminal.sexy/ to produce new colour schemes, and to translate them between different terminals or shells or editors.

ConEmu
------

Full screen doesn't work properly. We need to intercept and add full screen to ConEmu, not Mintty. Then we can disable `Alt + Enter/Space` buttons.

Terminal Emulator
-----------------

Our terminal emulator would preferably support sixel graphics, W3M images, and ligatures. Here we have the different terminal emulators to work with:

* Konsole - Supports Ligatures, only on Linux
* Gnome-Terminal - Supports W3m Images, only on Linux.
* Xterm - Supports sixel graphics, w3m images, only on Linux. Probably no ligature support.
* Mintty - No sixel, no w3m images, no ligatures, only on Windows.
* Conhost - Windows default terminal emulator for Powershell and CMD.
* ConEmu - Wraps up both Mintty and ConHost and other gui applications and manages them.

So for Windows, the stack is: ConEmu + Mintty/Conhost.

For Linux, the stack will be: Konsole. Because w3m images isn't that important, and sixel graphics is an oddity. We can use graphical Emacs instead for graphics and executable documents, no need for the terminal. But in the future if Konsole could support sixel graphics or w3m images, then it would be great! That being said, over SSH, support for sixel depends on client terminal emulator. And w3mimages doesn't work on Linux console anyway. The only way to get image support into terminals in modern day systems is to create a new standard such as iTerm2, or Black screen, or use support sixel graphics eventually. Until that day comes, we stick with KDE Konsole.

Editor
------




Fonts
-----

I desire fonts usable for both the terminal and editor, the most ideal ones are those that are multilingual, monospaced, supports ligatures, supports box drawing, supports powerline, supports a good number of unicode symbols and support even APL, but this probably doesn't exist. So we have a number fonts available to choose from in different situations:

* Anonymous Pro
* Source Code Pro
* FiraCode
* Monoid
* Hasklig

Paid Fonts:

* PragmataPro - Paid

Fallback Fonts:

* Consolas - Windows
* Inconsalata - Linux

Performance
-----------

To improve performance we need to use a macro language and produce a `.build` folder. This way we can generate the correct .zshrc and other rc files and eliminate sections from the language when we don't need it. It's simple conditional macro language. I wonder if there's a bash version around, so we don't need to use m4 or anything.

Windows
-------

# TODO: We need to run console.exe along with this to allow this work flawlessly in Cygwin mintty See the aliases for Cygwin, they mostly need to use `console`. Or `winpty`. #

Installation WIP
----------------

On installing this repository for use:

```
git clone --recursive <.dotfiles-repo>
# or on git 2.8
git clone <.dotfiles-repo> <.dotfiles-path>
cd <.dotfiles-path> && git submodule update --init --recursive --depth 1
```

We need to use:

```
# where --archive means: --recursive --links --perms --times --group --owner
rsync --update --checksum --archive "./dotfiles/.build/" "${HOME}/"
```

But also Make to run the rest.


On installing this repository for development:

```
git clone --recursive <.dotfiles-repo>
# or on git 2.8
git clone <.dotfiles-repo> <.dotfiles-path>
cd <.dotfiles-path> && git submodule update --init --recursive
```

On adding new dependencies:

```
cd "$(git rev-parse --show-toplevel)"
git submodule add <repo> modules/<repo-name>
git submodule update --init --recursive --depth 1 modules/<repo-name>
```

On removing dependencies that have been committed:

```
cd "$(git rev-parse --show-toplevel)"
package="modules/package"
git submodule deinit --force "$package"
git rm --force "$package"
rm --recursive --force --dir ".git/modules/$package"
```

On updating dependencies to the latest in their branch:

```
cd "$(git rev-parse --show-toplevel)"
git submodule update --init --recursive --remote --merge modules/<repo-name>
```

On changing dependency upstream URL:

```
cd "$(git rev-parse --show-toplevel)"
git config --file=".gitmodules" "submodule.modules/<repo-name>.url" "<repo>"
git submodule sync
```

On checking submodule status:

```
cd "$(git rev-parse --show-toplevel)"
git submodule status --recursive
```