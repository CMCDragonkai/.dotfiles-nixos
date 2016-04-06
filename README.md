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

Remember the correct permissions: `chmod 600 -R ~/.ssh`. And use the preprocessor on all relevant files including `~/.ssh/config`.

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

---

On Windows, open `Run` application and copy paste this command:

```
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Noninteractive -NoExit -File .\install.ps1
```

This script will not manage Windows GUI applications except for ConEmu.

The rest should be installed directly or using Chocolatey. But Chocolatey is outside the realm of this particular repository. This does mean dealing with things like Haskell Platform is outside the realm of this `.dotfiles`, except as configuration files.

---

Remember to properly configure Cygwin's home menu to be `%USERPROFILE%`.

Also note that there are 3 temporary directories for Cygwin use:

* User Local Temporary - `TEMP=%USERPROFILE%\AppData\Local\Temp`
* System Temporary - `TEMP=%SystemRoot%\TEMP`
* Cygwin Temporary - `export TMPDIR=/tmp`

We need a differentiation between the temporary directories due to different expectations of permissions between Cygwin (Linux) and Windows. So when clearing the temporary directory, feel free to clear `/tmp` and also the user local temporary. System temporary should be carefully cleaned. In order to allow access to the windows tmp, in Cygwin, the `WINTMP` is set to the original user local temporary. System temporary is not directly accessible, but that's alright.

---

`%ALLUSERSPROFILE%` - Points to a common user profile directory (that is viewable by all users on the OS). We should create a `%ALLUSERSPROFILE%/bin` directory to add PATH symlinks to all Windows executables that we install into here (this makes sense as installed Windows executables are usually installed on the entire system, not for a particular user). This refers to any natively installed Windows executable, or any extracted Windows executable. This does not refer to Chocolatey's installed executables, which has its own bin path at `%ALLUSERSPROFILE%/chocolatey/bin`. Note that Chocolatey will not necessarily install bin links for every package. Look for packages with a suffix of `.portable`. Do not use `.install` unless you verify its behaviour. Note that `.install` refers to natively installed packages, and these packages cannot be auto-uninstalled, without first uninstalling it natively, then uninstalling it from Chocolatey. Packages without a suffix are usually meta-packages. But make sure to review them before installing.

This means we need specifically, PATH needs to be set up in this way:

* Default Windows Paths (on Windows): `C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\`
* Prepend Chocolatey path (on Windows): `%ALLUSERSPROFILE%\chocolatey\bin`
* Prepend custom Windows path (on Windows): `%ALLUSERSPROFILE%\bin`
* Prepend Cygwin paths (on Cygwin): `/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin`
* Prepend Home paths (on Cygwin): `~/bin`

What this means is that Windows executables will always be available to Windows executables, but both Windows and Cygwin executables will be available to Cygwin executables and Windows executables executed through Cygwin.

Only one problem, Powershell scripts in `~/bin` won't be available to Powershell by default. The way to solve this is to put in `~/Documents/WindowsPowerShell/profile.ps1` an extra piece of code to set `%USERPROFILE%/bin` as prepended as well. This way, all user executed powershells will gain access to `~/bin`. Also to make sure that `PATHEXT` also contains `.PS1`. All of this is done currently.

As for `CMD`, this is fixed via `~/.cmd_profile`. Which you need to hook into any call via `cmd /K %USERPROFILE%/.cmd_profile`.

You must RAID your Windows Disks to get a single disk. Don't spread out the disks. This prevents problems with Chocolatey not allowing one to install into different drive letters.