# .dotfiles-nixos

## Installation

Go to TTY1. Login as a normal user.

```sh
git clone --no-checkout https://github.com/CMCDragonkai/.dotfiles-nixos /tmp/.dotfiles-nixos
mv /tmp/.dotfiles-nixos/.git "$HOME"
rmdir /tmp/.dotfiles-nixos
git checkout master
git submodule update --init --recursive
```

Exit and relogin to TTY1.

Install the base packages:

```sh
nix-env -iA env.base
```

Now you can got to TTY7 and continue the installation.

If you have problems, go back to TTY1 and fix them.

You can always kill XMonad with <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>Q</kbd>.

## Permissions

Git only persists 755 or 644 for files and directories are always 755. This means without any further processing after installation all files will appear either as executables or non-executables with read permission for the group and others, while directories are always readable and executable for the group and others. Sensitive folders should be explicitly modified to have their read and execute permissions for non-owners removed.

The `umask` setting is `027` by default, but when running with `sudo`, it changes to `022`. This is so that root created files will be readable by `other`.

```sh
chmod --recursive u=rw,u=rwX,g=,o= ~/.ssh
```

## Vim Packages

Packages should be first cloned to modules directory as submodule and then symlinked from `./profile/.vim/bundles`.

Pathogen is also installed as a submodule and symlinked from `./profile/.vim/autoload/pathogen.vim`.

## Desktop Files

Default desktop associations: `~/.config/mimeapps.list`.

* Home Desktop Files: `~/.local/share/applications`
* Nix User Desktop Files: `~/.nix-profile/share/applications`
* NixOS Desktop Files: `/run/current-system/sw/share/applications`

## Fonts

```sh
# shows fonts available
fc-list
# after installing or uninstalling fonts use this to refresh the cache
fc-cache --really-force --verbose
# also run it for root
sudo fc-cache --really-force --verbose
```

## Keyboard Control

This shows some common important keyboard controls that is configured.

### Notation

This notation is used in some configuration files such as `.inputrc` and Emacs:

* `\C` - <kbd>Ctrl</kbd>
* `\S` - <kbd>Shift</kbd>
* `\M` - Mod/Meta/Super which is <kbd>Win</kbd> on Windows, or <kbd>Cmd</kbd> on Mac. We want to avoid having to use <kbd>Alt</kbd>.
* `\A` - <kbd>Alt</kbd> on Windows Keyboards, or <kbd>Option</kbd> on Mac.
 `-` - Means hold previous, and hit the next, operator is left associative. `\C-\S-f` means `((\C-\S)-f)`
* ` ` - Means lift previous, and hit the next, operator is left associative. `e c t` means `((e c) t)`.
* `<enter>` - The Enter Key
* `<home>` - The Home key.

We prefer ASCII DEL `^?` to be used for backwards delete instead of ASCII BS `^H`. Instead `^H` can be mapped to other functions. Forwards delete still uses `\e[3~`. Preferably if the design of keyboards and terminals were standardised, we could have ASCII DEL for forwards delete, and ASCII BS for backwards delete, but alas it is not so.

### Shell

* <kbd>Shift</kbd> + <kbd>Tab</kbd> - Enter literal tab
* <kbd>Ctrl</kbd> + <kbd>Z</kbd> - Toggle backgrounding and foregrounding
* <kbd>Shift</kbd> + <kbd>Enter</kbd> - Non-executing enter to allow multiline commands
* <kbd>Ctrl</kbd> + <kbd>C</kbd> - Send SIGINT
* <kbd>Ctrl</kbd> + <kbd>\</kbd> - Send SIGQUIT
* <kbd>Ctrl</kbd> + <kbd>U</kbd> - Send SIGTERM

### Emacs

* <kbd>"</kbd> + <kbd>+</kbd> + <kbd>y</kbd> - Copy to system clipboard
* <kbd>"</kbd> + <kbd>+</kbd> + <kbd>p</kbd> - Paste from system clipboard

### Vim

```
:ls - Show all buffers
:buffers - Show all buffers
:b# - Switch to buffer #
:b ... - Switch to buffer ...
:bnext - Next buffer
:bprev - Previous buffer
:e ... - Open file and edit as buffer
:split - Split horizontally
:vsplit - Split Vertically
Ctrl-W + H/J/K/l - Move to a window by direction
Ctrl-W C - Close current window
:tabe - Open up a new tab workspace
:tabn - Next tab
:tabp - Previous tab
```

### Linux

* <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>F*</kbd> - Switch between TTYs and also X.

### XMonad

* <kbd>Mod</kbd> + <kbd>N</kbd> - Switch to workspace N
* <kbd>Mod</kbd> + <kbd>Shift</kbd> + <kbd>N</kbd> - Shift focused window to workspace N
* <kbd>Mod</kbd> + <kbd>Ctrl</kbd> + <kbd>N</kbd> - Switch focus to screen N
* <kbd>Mod</kbd> + <kbd>Alt</kbd> + <kbd>N</kbd> - Shift focused window to workspace at screen N

## Ergodox EZ

Change the layout here: https://configure.ergodox-ez.com/keyboard_layouts/qnxevg/edit

```sh
sudo teensy-loader-cli --mcu=atmega32u4 -w -v ./ergodox_ez_firmware_dragonflare_qnxevg.hex
```

## Nix Installation

Configure Nix packages in `~/.config/nixpkgs/config.nix`.

```sh
nix-env -iA env.android
nix-env -iA env.base
nix-env -iA env.crypto
nix-env -iA env.data
nix-env -iA env.development
nix-env -iA env.documents
nix-env -iA env.fonts
nix-env -iA env.gaming
nix-env -iA env.gis
nix-env -iA env.graphics
nix-env -iA env.graphs
nix-env -iA env.proprietary
nix-env -iA env.sql
```

Every time you update the Nix channel/Nix package set, make sure to rerun `nix-index` to rebuild the search index for `nix-locate`.

## Screen Layout

Manage xrandr profiles using `autorandr`. You can always setup your windows and then use `autorandr --save default`.
