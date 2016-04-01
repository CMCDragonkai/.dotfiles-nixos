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

Installation
------------

Installation and regeneration is 2 things. Installation is a complete installation from scratch. Regeneration is regenerating the confguration files. Activation is calling regeneration then running the triggers.

Regeneration needs to use md5sum or rsync or scp and not copy things that are not changed.

Copies are made, not symlinks. 

The copies in the HOME directory IS the build cache. So we need to save a `.dotfiles_checksum.md5` in the `.dotfiles` repo. Or in the home directory. If it doesn't exist, everything is generated and saved to the home. If it does exist, we check for differences, and only ones that is different will be regenerated and copied over. Or just `.dotfiles_checksum`. It should be in the repo, as it is just an implementation detail. However it could be a sha1sum checksum or sha256checksum. I think git uses sha1sum, so we should match its implementation. However we must create a sum from the generated and saved files, not all files in home directory. So perhaps a list of files that should be in the home directory `.dotfiles_generated`, and then use that list to iterate and create an md5sum.

Note that `.dotfiles_generated` needs to be nullbyte terminated.

```
xargs --arg-file="./.dotfiles_generated" --null md5sum > "./.dotfiles_checksum"
md5sum --check --quiet "./.dotfiles_checksum" 2>/dev/null
```

What out for relative pathing. Checksum will only check for relative directory!

To create the `./.dotfiles_generated`, we need printf to print `\0`. http://unix.stackexchange.com/questions/174016/how-do-i-use-null-bytes-in-bash

It also should be the absolute path to be certain. If not absolute path, then the generation of `./.dotfiles_generated` needs to be in the same directory as the checking of `./.dotfiles_generated`. To main consistency, otherwise md5sum doesn't know where to find the files.

We can also use `sha1sum`.

Each file outputed from the check is a file that requires regeneration.

```
echo ":ba:shp:p/RE:ADME.md: FAILED" | rev | cut --delimiter=':' --fields="2-" | rev
```

The problem with --null or `\0` is that `./.dotfiles_checksum` will contain newlines... So how would you even deal with this? Actuall this is solved via md5sum.

> If file contains a backslash or newline, the line is started with a backslash, and each problematic character in the file name is escaped with a backslash, making the output unambiguous even in the presence of arbitrary file names. If file is omitted or specified as ‘-’, standard input is read. 

So that means we just need:

```
md5sum --check --quiet "./.dotfiles_checksum" 2>/dev/null | xargs 
```

ACTUALLY this is not solved, because it renders it with newlines. While the .dotfiles_generated works. The result of `md5sum --check` doesn't work. Becuase it renders the newlines in the filenames.

I'm beginning to think, we should just use a local build temp, and then just rsync the shit. This is getting complicated due to newlines in filenames. It's probably faster too to just use rsync.

```
# where --archive means: --recursive --links --perms --times --group --owner
rsync --update --checksum --archive "./dotfiles/.build/" "${HOME}/"
```

We do need a local build cache now inside `.build` though.

Look the problem is that even if we create regex to handle the splitting of md5sum output, which we can do! We still have the problem of converting that to a variable that can be used by `mv` or `cp`. The point being is that having something like `"lol\ncat"` doesn't work. Actually we don't need to convert it. It works as just being assigned to a variable and you can cat it like `cat "$x"` where `$x = $(...)`. The command to produce the output.

Ok then, well other than that you require md5sum and splitting it out according to new delimitation scheme. A regex scheme to be precise:

```
/(.*?):\sFAILED(?:\n|$)/gs
```

But what unix tool supports that regex. Also this is stupid.

---

```
> cd project
> mkdir --parents modules
> # add a new submodule and put in particular path relative to project root directory optionally
> git submodule add --branch master <repository> [<path>]
> # shows the status, commit hash, path and branch for immediate submodules 
> git submodule status
> # ...recursively
> git submodule status --recursive
> # + means out of sync if the currently checked out submodule commit does not match the SHA-1 found in the index of the containing repository
 5e94d3c285f4424f3fa4c6ddf036f405688b1d51 modules/bashpp (heads/master)
 4f19700919c8ebbaf75755fc0d03716d13183f49 modules/prezto (heads/master)
-f0a745576ff69fa608421ee7214d4cd77b43e62f modules/prezto/modules/autosuggestions/external
-3a2bb8781d32d05d1bf05deeeb476beb651e8272 modules/prezto/modules/completion/external
-7a4b54b708ab88e0421097614f1acaa7a973c795 modules/prezto/modules/history-substring-search/external
-43cb371f361eecf62e9dac7afc73a1c16edf89c7 modules/prezto/modules/prompt/external/agnoster
-8e81152340c4beb2d941340d1feb2dc29bbcc309 modules/prezto/modules/prompt/external/powerline
-fb4c37dad3c5cbdebca61a8ff5545397c11d450f modules/prezto/modules/prompt/external/pure
-7044c1986e2f6b15eec27a03651207fccb0a2fbe modules/prezto/modules/syntax-highlighting/external


> # clones the repo and all submodules
> git clone --recursive <repository>
> # updates all submodules and initialises non-initialised repo, while having recursive depth
> git submodule update --init --recursive
> # updates just the submodule with depth = 1
> git submodule update
> 
> # remove the submodule from the worktree, but keep tracking the submodule, not really useful here
> git submodule deinit <path>
> # ...forced including any local changes
> git submodule deinit --force <path>
> # actually remove the submodule (along with any local changes) and (-r is required for recursive directory)
> git rm --force -r <path>

> # update the submodule to latest changes in the tracking branch (set to master previously)
> # it will auto fetch and merge if necessary
> git submodule update --remote "modules/prezto"

# runs git branch -vv on each submodule
> git submodule foreach 'git branch -vv'
Entering 'modules/bashpp'
* master 5e94d3c [origin/master] Merge remote-tracking branch 'upstream/master'
Entering 'modules/prezto'
* master 4f19700 [origin/master] Add missing syntax highlighter

> # checks the status of each git submodule
> git submodule foreach 'git status'

> # change .gitmodules URL for a given submodule, and then synchronise this change to the .git index
> # make sure to commit the change later, and push it the repo
> # this is used when the upstream URL has changed!
> git config --file=".gitmodules" "submodule.modules/prezto.url" "https://github.com/sorin-ionescu/prezto.git"
> git submodule sync

> # change the branch of the submodule, update the submodule to the latest in the branch from the given remote
> git config --file=".gitmodules" "submodule.modules/prezto.url" "development"
> git submodule update --init --recursive --remote

> # take a look at all the submodule settings
> git config --file=".gitmodules" --list

> # update from remote and the tracking branch and merge the new changes
> # isn't merge redundant here, because it should automerge
> git submodule update --remote --recursive --init --merge
> 
> # by default submodule update uses --checkout, meaning it checks out the superproject's recorded commit for the submodule
> 
> # it makes sense to use --depth 1 if we're just using it as a dependency, then a shallow clone of the submodules is correct, this causes all the dependencies to be at detached heads, don't develop on submodules here, instead fork your dependency, and work on your fork, and push updates here, can however work on the detached submodules, just be wary of your lack of history

> git submodule add --branch master --depth 1 <repository> [<path>]
> 

# now if you want a project that uses submodules, you just use:
# however this will pull in all history, you can't specify depth just for submodules
# therefore instead of running this, prefer just normal clone, then run
# git submodule update --remote --init --merge --depth 1 --recursive
git clone <repository>
git submodule update --remote --init --merge --depth 1 --recursive

git clone --recursive <repository>

# adds one repository optionally into a particular path relative the project root
git submodule add --branch master --depth 1 <repository> [<path>]
# updates all submodules and downloads all recursive submodules (the add command does not have recursion at this moment), optionally for a particular submodule, or without means all submodules
git submodule update --remote --init --merge --depth 1 --recursive [<path>]

# the --depth 1 works best at git 2.8 released on March 2016
# see: http://stackoverflow.com/a/17692710/582917
# git submodules is the bleeding edge of git features!

# another usecase is to say, you have a shahash, and you want acquire a submodule at that particular hash
# what's the best way to do this?
# furthermore, once you can acquire the submodule at that particular hash, you want to get it for a depth of 1
# so it's the most lighest way of acquiring the dependencies
# one way is the archive links, but that's not really going through git, as so much as going through github
# http://stackoverflow.com/questions/2144406/git-shallow-submodules#comment60341398_17692710
# ok it seems that there's no easy way to acquire a submodule at a particular hash with a depth of 1
# you can do it with a branch, a tag, but not a commit id
# the only way with commit id right now is to do something which clones everything and checks out a particular commit id
# if that commit id is related to something on the a branch or tag, then you're all set to go
# i'm not sure if -b open accepts a tag
# in that case, forking is really required, and also git ls-remote will come in handy too!
```

The `-` means those repos were not initialised.


