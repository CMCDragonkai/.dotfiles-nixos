# .dotfiles #

This directory is meant to be located in `~/.dotfiles`.

External dependencies are managed via git submodules. This facilitates component based development, where these dependencies have their own life cycle.

```
# add the master branch of prezto as a submodule
git submodule add -b master git@github.com:sorin-ionescu/prezto.git
# update the submodule to the latest master
git submodule update --remote prezto
```

When running `install.ps1` or `install.sh`, eventually macro variables like `PH_SYSTEM` and `PH_TZ` and `PH_TZDIR` must be set. The `PH_SYSTEM` can be either `CYGWIN` or `NIXOS`. The `install.sh` will run the m4 preprocessor and move all preprocessed files into `./.build` folder. Then the resulting files inside `./.build` can be symlinked or copied to `~`. Remember that some Windows files (such as the `.ps1`, `.exe`, `.bat`, or `.cmd`) and executables will need NTFS symlinks, not Cygwin symlinks. The `mklink` can do this.

Installation on Windows is:

1. Download `.dotfiles` repository into `$USERPROFILE`. 
2. Open `Run` application, and execute: `powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -Noninteractive -NoExit -File %USERPROFILE%\.dotfiles\install.ps1`

Installation on Linux (NixOS) is:

```
cd ~
git clone --recursive https://github.com/CMCDragonkai/.dotfiles.git
~/.dotfiles/install.sh
```

Secret management is still being figured out... we need to store a secrets database somewhere, which we can then extract things like SSH keys or and hosts configuration. The database must support independent files, but also just random passwords too..

Since we are installing Cygwin 64 bit, we may need 32 bit cross compilation, so `cygwin32-*` packages maybe of use. Also one can use the Cygwin 64 bit toolchain to compile MINGW executables targetting Windows natively. This can be done with `mingw64-*` or `mingw32-*` packages. Basically bring in things like GCC with these prefixes.

Interesting Paths
-----------------

`%ALLUSERSPROFILE%` - Points to a common user profile directory (that is viewable by all users on the OS). We should create a `%ALLUSERSPROFILE%/bin` directory to add PATH symlinks to all Windows executables that we install into here (this makes sense as installed Windows executables are usually installed on the entire system, not for a particular user). This refers to any natively installed Windows executable, or any extracted Windows executable.

Path hierarchy on Windows:

* Default Windows Paths (on Windows): `C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\`
* Chocolatey path (on Windows): `%ALLUSERSPROFILE%\chocolatey\bin` (use `$env:ChocolateyPath\bin` instead)
* Custom Windows Path (on Windows): `%ALLUSERSPROFILE%\bin`
* Cygwin Paths (on Cygwin): `/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin`
* Home paths (on Cygwin): `~/bin`

To take advantage of Home paths in CMD, make sure to set startup task to: `cmd /K %USERPROFILE%/.cmd_profile`

Keyboard Control
-----------------------

Since we have many applications, and we are customising all of them, we will have a different set of keyboard shortcuts for every application.

This notation is used in some configuration files such as `.inputrc` and Emacs:

* `\C` - <kbd>Ctrl</kbd>
* `\S` - <kbd>Shift</kbd>
* `\M` - Mod/Meta/Super which is <kbd>Win</kbd> on Windows, or <kbd>Cmd</kbd> on Mac. We want to avoid having to use <kbd>Alt</kbd>.
* `\A` - <kbd>Alt</kbd> on Windows Keyboards, or <kbd>Option</kbd> on Mac.
 `-` - Means hold previous, and hit the next, operator is left associative. `\C-\S-f` means `((\C-\S)-f)`
* ` ` - Means lift previous, and hit the next, operator is left associative. `e c t` means `((e c) t)`.
* `<enter>` - The Enter Key
* `<home>` - The Home key.

For Mintty:

* <kbd>Ctrl</kbd> + <kbd>+</kbd>/<kbd>-</kbd> - Font Zooming
* <kbd>Shift</kbd> + <kbd>Up</kbd>/<kbd>Down</kbd> - Scroll Line Up and Down
* <kbd>Shift</kbd> + <kbd>PgUp</kbd>/<kbd>PgDn</kbd> - Scroll Page Up and Down
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>C</kbd>/<kbd>V</kbd> - Copy & Paste
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd> - Search Scrollback Buffer
* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd> - Switch screens between orimary buffer and secondary buffer (like between shell and less or shell and vim)
* <kbd>Win</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd> - Show settings

(For more see: https://github.com/mintty/mintty/wiki/Keycodes)

For ConEmu:

* <kbd>Win</kbd> + <kbd>Ctrl</kbd> + <kbd>Enter</kbd> - Full Screen (also try Alt + Enter)

We prefer ASCII DEL `^?` to be used for backwards delete instead of ASCII BS `^H`. Instead `^H` can be mapped to other functions. Forwards delete still uses `\e[3~`. Preferably if the design of keyboards and terminals were standardised, we could have ASCII DEL for forwards delete, and ASCII BS for backwards delete, but alas it is not so.

For Konsole:

* <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>Left</kbd>/<kbd>Right</kbd> - Move Tab Position
* <kbd>Shift</kbd> + <kbd>Left</kbd>/<kbd>Right</kbd> - Move to Left/Right Tab

Shell Commands:

* <kbd>Shift</kbd> + <kbd>Tab</kbd> - Enter literal tab
* <kbd>Ctrl</kbd> + <kbd>Z</kbd> - Toggle backgrounding and foregrounding
* <kbd>Shift</kbd> + <kbd>Enter</kbd> - Non-executing enter to allow multiline commands
* <kbd>Ctrl</kbd> + <kbd>C</kbd> - Send SIGINT
* <kbd>Ctrl</kbd> + <kbd>\</kbd> - Send SIGQUIT
* <kbd>Ctrl</kbd> + <kbd>U</kbd> - Send SIGTERM

Hotkey Hierarchy:

* Linux Commands -> XMonad Commands -> Konsole Commands -> Tmux Commands -> Shell Commands -> Application Commands
* Windows Commands -> ConEmu Commands -> Mintty Commands -> Tmux Commands -> Shell Commands -> Application Commands

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

The Search Field in ConEmu only applies to ConHost applications. Things like Powershell and CMD that uses Windows ConHost. If you are running mintty, the search field in ConEmu does not work. Instead Mintty has its own search functionality. This is because mintty is a terminal emulator itself, and ConHost is  Windows terminal emulator!

Note that "window management" in Cygwin occurs via ConEmu and Tmux. Need to design hotkeys around this, and prefer most of the time for ConEmu to intercept hotkeys.

Fonts
-----

The most ideal ones are those that are multilingual, monospaced, supports ligatures, supports box drawing, supports powerline, supports a good number of unicode symbols and support even APL, but this probably doesn't exist. So we have a number fonts available to choose from in different situations:

* Anonymous Pro
* Source Code Pro
* FiraCode
* Monoid
* Hasklig
* Input

Paid Fonts:

* PragmataPro - Paid

Fallback Fonts:

* Consolas - Windows
* Inconsalata - Linux

ZSH as Default Shell
--------------

The `/etc/passwd` has been changed to match ZSH. For the 2 ways of launching the terminal.

* `Cygwin.bat` - Official Cygwin launcher. Because it starts as a Windows Batch File, it only has access to Windows environment variables.
* `mintty.exe` - Launches Mintty directly. It has a number of command line flags that changes its behaviour, and it will autolaunch the default shell for the user. It has the capability of launching the shell as a login shell or just a normal interactive shell. The autolaunching of the shell works by: checking SHELL executable, reading /etc/passwd before falling back onto /bin/sh.

Basically ConEmu doesn't bother with `Cygwin.bat`, but ConEmu instead directly launches `mintty.exe` and passes it parameters.

The Mintty manual says:

```
       If a program name is supplied on the command line, this is executed with any additional arguments given.  Otherwise, mintty
       looks for a shell to execute in the SHELL environment variable.  If that is not set, it reads the user's default shell setting
       from /etc/passwd.  As a last resort, it falls back to /bin/sh.  If a single dash is specified instead of a program name, the
       shell is invoked as a login shell.
```

Which means since `$SHELL` is not available as a Windows environment variable, it will read the result from `/etc/passwd`. Which is what we have set.

One important thing. There's no real point in making every shell a Login shell, so all shells launched from ConEmu to Mintty, they should all be non-login interactive shells. An explicit option should be offered to launch a login shell.

The startup task for ConEmu for a non-login shell should be: `%USERPROFILE%\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico`.

The startup task for ConEmu for a login shell should be: `%USERPROFILE%\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -`.

Process Hierarchy on Cygwin
---------------------------

Make sure to use Process Explorer to view this. Ideally the process tree of using ConEmu, Cygwin, Mintty.. etc is like this (this is not a real tree!):

```
# here's a tree with Process Name and Actual Executable:
Console Emulator (x64) [ConEmu64.exe]
    -> ConEmu console extender (x86) (32 bit) [ConEmuC.exe]
        -> Console Window Host [conhost.exe] & Windows Command Processor (32 bit) [cmd.exe]
    -> ConEmu console extender (x64) [ConEmuC64.exe]
        -> Console Window Host [conhost.exe] & Windows Command Processor [cmd.exe]
        -> Console Window Host [conhost.exe] & Windows PowerShell [powershell.exe]
        -> Console Window Host [conhost.exe] & Terminal [mintty.exe]
            -> zsh.exe [zsh.exe]
```

The `ConEmu64.exe` is the ConEmu terminal emulator process. This manages the launching of ConEmu Containers `ConEmuC.exe` and `ConEmuC64.exe`. The containers are like "windows" that contains a ConHost and Terminal Emulator pair. Note the 32 bit and 64 bit versions of the containers, a 32 bit container contains a 32 bit pair. An example pair is `conhost.exe` and `mintty.exe`. In Windows parlance, the `conhost.exe` is a "Windows Process", while ConEmu processes, `mintty.exe`, `cmd.exe`, `powershell.exe` and ZSH processes including child processes are considered "Background Processes". The only process to be considered a "User Process" is the top-level `ConEmu64.exe`.

This shows that each time you launch a new Cygwin window (as in `conhost.exe` & `mintty.exe`), you end up with a new process tree, with each `mintty.exe` acting as its own Cygwin PID 1 init.

This may or may not be problematic. If it is, then it's better to use tmux to further launch sub-shells, rather than using ConEmu to launch new Cygwin windows. This may explain why it might be difficult to share SSH-Agent across Cygwin windows.

On the status bar, the left number is the Windows PID of the contained terminal emulator, while the right number is the Windows PID of the ConEmu container.

While we can visualise the process hierarchy as a tree, it doesn't actually behave like a process supervisor tree. It is very easy to create orphaned processes by killing process nodes in an incorrect manner.

For example, killing `ConEmu64.exe` doesn't kill the child processes, they are left running. But they are no longer visible.

There are various pecularities in the behaviour of `conhost.exe` and its paired up terminal emulators. But the one I'm concerned about most, is when `mintty.exe` is terminated, whether it propagates kill signals to its child processes such as ZSH, and whether ZSH then propagates kill signals to its child processes, thus allowing us to clean up all Cygwin processes upon killing the Cygwin window.

The best way to test this is to have processes running the background of the shell, and then to kill the mintty process directly, we specifically 3 things to happen:

1. The associated `conhost.exe` is to be terminated.
2. All Cygwin processes must be terminated (including any backgrounded processes, suspended processes like `less`)
3. The ConEmu container should also be terminated.

This behaviour needs both Mintty and the Shell to propagate kill signals. Note that with an idle Shell, Mintty will automatically propagate the kill signal to the Shell (it could be SIGHUP), Mintty will only ask for confirmation if it detects that there are child processes under the Shell. Note that the Shell isn't the only child process of Mintty, there can be other processes such as SSH-Agent. It is apparent that Bash receives a SIGHUP, and then propagates SIGHUP to all child processes.

Let's try to make ZSH propagate kill signals:

* `exit` - leaves orphaned process after 1 warning.
* `kill -HUP $$` - no warning, but still leaves orphaned process.
* Mintty Close from GUI - warning from mintty, but still leaves orphaned process.
* <kbd>Ctrl</kbd> + <kbd>D</kbd> - warning from ZSH, but still leaves orphaned process.
* Task Termination - no warning, leaves lots of orphaned processes.

According to http://superuser.com/q/662431/248499, for Bash, all child processes will receive SIGHUP if the SSH connection is closed and that `huponexit` is set to true. However if the SSH connection is killed or is dropped, then child processed will still receive SIGHUP regardless of `huponexit`.

According to ZSH docs, simply `setopt HUP` should just result in ZSH closing all child processes. 

Don't use orphan processes to create services/daemons. Create services using a service wrapper! Use your init's service wrapper capabilities. Systemd has services. So does Windows. Using orphan processes for services/daemons is totally deficient!! But you ask, what about user local processes!? Well systemd has user services too! Then you ask, what if I just want to run a long running process, and not look at it, and log out of SSH? I don't have the ability to create service! Well then that's when you us a terminal multiplexer called tmux or screen to create detached sessions! In no situation is orphaned processes the right answer. EXCEPT under one/two circumstance. When launching X applications or DE applications from the command line. That's the only time it makes sense to orphan a process, when it's like a GUI application that you want to launch independently. In that case, you're creating a "launcher", which is really a specific situation! It makes sense in this case, because firstly you don't want to control the process from the terminal (not even send signals), and it's not a long running daemon either, so it's not a service. Alternatively, if you do have tmux or screen, orphaning may not be required either. As you can just launch into detached sessions. HOWEVER this is kind of inefficient, as there's lots of baggage being carried around. Or you can just orphan it and make it be handled as an independent process. The only time where this makes sense is GUI applications like launching firefox.. etc. Make sure to attach its error handling into the X or DE based error handling. Which should be journald or syslog or .xsession-errors.

Development
----------------

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
rm --verbose --recursive --force --dir ".git/modules/$package"
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

M4 compile time macros can query the system:

We can use `sysval`:

```
syscmd(`false')
=>
ifelse(sysval, 0, zero, non-zero)
=>non-zero
syscmd(`true')
=>
sysval
=>0
```

Or perhaps:

```
define(`vice', `esyscmd(grep Vice ../COPYING)')
=>
vice
=>  Ty Coon, President of Vice
=>
```

The `esyscmd` could be applied like:

```
ifelse(esyscmd(`hash "firefox" 2>/dev/null && { printf "1"; } || { printf "0"; }'), 1, 
FIREFOX IS INSTALLED
, 
FIREFOX IS NOT INSTALLED
)
```

---

ls /dev/ | grep tty # only on Linux, the actual Linux console
ls /dev/ | grep pty # cygwin has this, and I think X as well
ls /dev/ | grep pts # not sure

Each terminal represents a `pty` or `tty`. You can then do `echo "haha" > /dev/tty0` or something to send output to another terminal emulator.

Remember it sends to the terminal emulator, not the shell that it is running. So this is an interesting way of sending side by side output. If we can easily acquire the address of particular terminal emulator.

Fortunately it's easy. All you need is to run `tty` on the terminal emulator you're in. And you get the address to it.

However consider if we can add this address persistently to the UI that runs the terminals. Like ConEmu, or Mintty, or Tmux.

To find out who's listening:

fuser /dev/pty2
fuser --verbose --user /dev/pty2
fuser --user /dev/pty2

That gives you the shell. Or something, not the PID of the terminal emulator. The parent of the shell would be the terminal emulator, which is useful. Works even with nested commands, like if a shell ran less or another shell.

Actually we don't even need to run `tty`, we can just `echo $TTY`.

Now we just need something to add TTY to the window name of Mintty. Not sure.

Also Windows con hosts get /dev/cons0 but this is not usable because of a limitation of Windows. So they get tty too, but its useless.

* Investigate where TTY environment variable was set in ZSH
* Make $TTY appear in Mintty's window title (or ZSH's RPROMPT).
    - http://randomartifacts.blogspot.com.au/2012/10/a-proper-cygwin-environment.html
* Make $TTY appear in Tmux's panel title (or ZSH's RPROMPT).
* Install stderred (https://github.com/sickill/stderred), however no CYGWIN support, also no bash support
* Alternatively have explicit color http://stackoverflow.com/a/16178979/582917

---

Linux Desktop Files

NixOS:

* User Application Desktop Files: `~/.nix-profile/share/applications`
* System Application Desktop Files: `/run/current-system/sw/share/applications`

Non-NixOS:

* User Application Desktop Files: `~/.local/share/applications`
* System Application Desktop Files: `/usr/share/applications` or `/usr/local/share/applications`

---

Control the buffering:

* `unbuffer` or `zpty` - uses PTY (which forces line buffering or byte buffering, no idea)

---

So vim has buffers and tabs. And `:buffers` or `:ls` and `:vsplit` is awesome.

The commands:

```
:split
:vsplit
```

Split the windows equally, and always shows a duplicated view of the buffer you're currently looking at. This sounds likes what you're looking for in your hybrid TUI and GUI. The idea of always duplicating your current buffer is a good idea.

And also focus is always placed on the new buffer being split. So horizontal split means the new buffer should be the bottom one, while vertical split means the new buffer should the right one. Focus is always placed onto the new window.

Wait so now we have XMonad -> Tmux -> Vim Buffers/Windows???

And also Explorer -> ConEmu -> Tmux -> Vim.

Vim tabs are meant to be a different layout. Actually vim tabs is similar meaning to XMonad workspace. Workspaces usually is placed onto another monitor. But it doesn't need to be. It can be overlayed and stacked on top of each other.

1 X Screen -> X Monitors -> Y Workspaces(Tabs) -> Z Windows

Sometimes like ConEmu, the tabs themselves are windows. So they don't have a separate workspace. Except as program tabs inside explorer. Like having a different ConEmu.

Basically the concept of "tabs" is amorphous. For XMonad, tabs refers to workspaces. For Vim, tabs is also a form of workspaces. However in Sublime, tabs are actually per-buffer. While ConEmu, tabs is equivalent to windows. Basically the concept of a tab is kind of different across different things. One can make Vim do 1 buffer 1 tab. But that's what it was originally designed for.

Vim currently keeps the focus on the original buffer. And instead I would suggest the new buffer should be the focus. But I guess that's configurable.

> A buffer is the in-memory text of a file.
> A window is a viewport on a buffer.
> A tab page is a collection of windows.

Use `:tabe` to open a new tab. Then use `:qa` to close everything, thus saving the entire session.

---

Moving processes between terminal emulators, screens, shells... etc. And also changing their redirection parameters (such as after suspending and backgrounding), this is useful for actual process management.

* http://monkeypatch.me/blog/move-a-running-process-to-a-new-screen-shell.html
* https://github.com/nelhage/reptyr
* http://stackoverflow.com/questions/1323956/how-to-redirect-output-of-an-already-running-process
* https://github.com/jerome-pouiller/reredirect/

---

When reinstalling old versions of Windows, the update system will most likely fail to work. Instead of using the automatic updates. It's recommended to use https://catalog.update.microsoft.com/ which can only be accessed by Internet Explorer 6 or higher. Visiting it will ask you to install an extension, you can then proceed to use this site to download any update you need.

There are "rollup" updates that will install many updates that have been released for a certain time period for a given Windows version.

These rollups should be released near the end of the mainstream support listed here: http://windows.microsoft.com/en-au/windows/lifecycle

It's however still kind of complicated, as it seems Microsoft no longer cares about old operating system versions. For example, here is one person's journey reinstalling Windows 7 and attempting to bring it to the latest version: https://www.thurrott.com/windows/67305/convenience-rollup-makes-big-difference-windows-7-updating-still-broken

It's just much easier to use free Windows 10 upgrade directly. Burn it onto a CD or deploy it onto a USB drive, and install that instead. Make sure you first installed your old version of Windows, and activated it.

Installing Windows 7 -> 10. 

* Install Windows 7
* Install Shuttle Drivers (to acquire Network Adapter Driver)
* Activate Windows 7 (Go to Computer Properties)
* Install Windows 10 (from USB) (do not install upgrades)
* Replace Windows 7 with Windows 10
* Install NVIDIA drivers and DVD Writer Drivers

Windows 7 updates no longer work, so we need to change to Windows 10.

---

Power monitoring:

https://github.com/fenrus75/powertop
http://upower.freedesktop.org/
https://github.com/Spirals-Team/powerapi

Which one should we use?

---

Package Management has finally arrived on Windows 10!

```
> Get-Command -Module PackageManagement

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Find-Package                                       1.0.0.1    PackageManagement
Cmdlet          Find-PackageProvider                               1.0.0.1    PackageManagement
Cmdlet          Get-Package                                        1.0.0.1    PackageManagement
Cmdlet          Get-PackageProvider                                1.0.0.1    PackageManagement
Cmdlet          Get-PackageSource                                  1.0.0.1    PackageManagement
Cmdlet          Import-PackageProvider                             1.0.0.1    PackageManagement
Cmdlet          Install-Package                                    1.0.0.1    PackageManagement
Cmdlet          Install-PackageProvider                            1.0.0.1    PackageManagement
Cmdlet          Register-PackageSource                             1.0.0.1    PackageManagement
Cmdlet          Save-Package                                       1.0.0.1    PackageManagement
Cmdlet          Set-PackageSource                                  1.0.0.1    PackageManagement
Cmdlet          Uninstall-Package                                  1.0.0.1    PackageManagement
Cmdlet          Unregister-PackageSource                           1.0.0.1    PackageManagement

```

It used be called OneGet, but its official name is the PackageManagement

We can install a module called Carbon.

Using

```
Update-Help -Force
Import-Module PackageManagement
Install-PackageProvider -Name 'chocolatey' -Force
Install-Package -Name 'carbon' -RequiredVersion '2.2.0' -ProviderName 'chocolatey' -Force
```

The Carbon module will not always be loaded into our system.

The current `Chocolatey` provider has some serious bugs. It is just a prototype that isn't being developed anyhmore. There is a new Chocolatey provider developed here: https://github.com/chocolatey/chocolatey-oneget But it isn't finished, and it's not available for installation. A third chocolatey provider is here: https://github.com/jianyunt/ChocolateyGet and it is ready for installation, but isn't much used. It seems to be an alternative to the `Chocolatey` provider in case you meet some problems installing things.

We can use it like this:

```
Install-PackageProvider -Name 'ChocolateyGet' -Force
Import-PackageProvider -Name 'ChocolateyGet'
```

The last command may not be necessary:

> As a side question, will there ever be Upgrade-Package or equivalent? Also if I install something like Firefox from Chocolatey, I can't exactly uninstall it from Chocolatey, I need to first uninstall it normally, then finally remove it from Chocolatey. Oneget has this same problem right?

It appears that `ChocolateyGet` is superior to the current `Chocolatey` provider, and perhaps it is a stop-gap between getting to the final chocolatey provider at https://github.com/chocolatey/chocolatey-oneget.

---

Windows Homegroups AKA CIFS/SMB, you can view currently shared folders using:

```
net view \\polyhack-surf1
```

It only shows top level folders, not subsequent folders.

Within Windows, there are 2 main ways of sharing files over a network.

The first is the Windows Workgroup concept, which was later called "Homegroup". It encompasses several features including the standard file sharing protocol called CIFS/SMB, but also things like printer sharing and internet connection sharing. (Note that CIFS/SMB can run on top of the NetBIOS protocol, which is a networking protocol that allows computers using the old NetBIOS API to run on TCP/IP.)

The second is the Windows Domain, which unlike Windows Workgroup/Homegroup, is a client-server architecture. There is one computer designated the domain controller, and this domain controller is what controls authentication into the sharing network.

The client-server architecture scales better than the p2p system in this case (which isn't always necessarily true with things like supernodes in P2P networks, which can have hybrid p2p2 and client-server), and allows more stringent security controls, and is one of the main features of Active Directory. https://en.wikipedia.org/wiki/Windows_domain One of the key features of Windows Domaisn is roaming user profiles, which allows transfer of the user profile for any user to any computer over LAN or WAN.

> Workgroups are considered difficult to manage beyond a dozen clients, and lack single sign on, scalability, resilience/disaster recovery functionality, and many security features. Windows Workgroups are more suitable for small or home-office networks.
> https://en.wikipedia.org/wiki/Windows_domain

Another key feature of Windows domains is the application of group policy, which allows sysadmins to configure many Windows computers part of the same domain.

Opensource Alternatives of Windows Active Directory include:

* ApacheDS + Apache Directory (runs on Linux/Windows/Mac)
* OpenLDAP (runs on Linux/Windows/Mac)
* Univention Corporate Server (runs on Linux)
* Samba + Winbind (runs on Linux) (Samba can act as a domain controller as well!)

Basically the above implement the domain controller daemons, and can perform single sign on for a domain of Windows computers.

It appears that Active Directory is the main official configuration management tool of Windows computers.

> A server running Active Directory Domain Services (AD DS) is called a domain controller. It authenticates and authorizes all users and computers in a Windows domain type network—assigning and enforcing security policies for all computers and installing or updating software. For example, when a user logs into a computer that is part of a Windows domain, Active Directory checks the submitted password and determines whether the user is a system administrator or normal user.

But unlike many configuration management systems, it expects Windows are used live and interactively, which means many features are designed to deal with user profile migration, and user based security. Whereas Linux CM systems are usually designed around installing and deploying software onto machines that are not intended to be used interactively by users directly. Linux servers are meant to be cattle not special snowflakes.

Active Directory is included in most Windows Server editions.

This also means active directory is often ran as a daemon, not just as single batch transformational program. Also it's very complicated, as is used to share services and tightly integrate into Windows technology stacks. I guess this is used by enterprises that are deeply into Windows technologies.

---

Recommend autocreating shortcuts for chrome apps that you use.

All you need is the relevant target as set below.
You need the path to Chrome executable.
Chrome needs to be on the PATH.
In PowerShell you can do `Get-Command chrome | Select-Object -ExpandProperty Source` or `(Get-Command chrome).Source`. There's a problem... though. Because now I'm installing through the Chocolatey Provider, I'm not getting the BinRoot setup automatically. And many packages are installed through some custom installer which again doesn't put it into the BinRoot anyway. This means we cannot expect to know where things are being installed through the provider. The Get-Package only tells us where the package was installed from OneGet's perspective, not where exactly the package is. This is STUPID!

So we need to find out a way to get the file path to the executable. I guess we can assume where it is going to be, and hard code it for now.

```
Target: "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --app=https://app.fullcontact.com/
Start In: "C:\Program Files (x86)\Google\Chrome\Application"
```

Also another problem is that the icon isn't setup properly.

Icon for Full Contact:

```
%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default\Web Applications\app.fullcontact.com\https_80\FullContact.ico
```

Yea, so Chrome only downloads the icon when we tell it to setup an application.

What we can do is save the ICO files in this directory. These ICO files are generated from the Website FAVICON.

While we could curl the website and parse out the HTML for the favicon.ico. It turns out that this is quite complex. Overall I can just save the favicon.ico files that I need for my Chrome applications. Oh well..

---

Remote Desktop

http://ishanaba.com/blog/2012/11/graphical-remote-desktop-protocols-rfbvncrdp-and-x11-2/

Ok so there are 3 main protocols:

* VNC (a.k.a. RFP)
* RDP
* X11 (a.k.a. XDMCP (well not exactly, the XDMCP is a protocol built on top of X11))

VNC works pretty much everywhere.
RDP is a proprietary protocol, but there are open implementations of it.
XDMCP was designed solely for X.

There are clients for every OS (Win,Linux,Mac) that support 1 or all of the protocols. 2 clients that support most things are "Remmina" and "Guacamole". Xephyr is a cool client for XDMCP only.

Linux:

* RDP - rdesktop, remmina, guacamole
* XDMCP - xnest, xephyr
* VNC - vncviewer 

Servers are more specific to the OS. Generally Linux has serving solutions for VNC, RDP and XDMCP. For Windows, generally there are VNC and RDP servers.

Linux:

* RDP - xrdp
* XDMCP - xorg
* VNC - tigervnc, x11vnc... etc

Windows:

* RDP - native
* XDMCP - Cygwin X
* VNC - lots

Generally RDP works best when remoting to Windows. While XDMCP works best when remoting to Linux.

The choice of the protocol depends on what the remote server supports, and your bandwidth/latency tradeoff.

VNC works best for high bandwidth.
RDP works best for low latency.
XDMCP

Vim Packages
------------

Packages should be first cloned to modules directory as submodule and then symlinked from `./profile/.vim/bundles`. 

Pathogen is also installed as a submodule and symlinked from `./profile/.vim/autoload/pathogen.vim`.

Language Runtimes
-----------------

It's preferable to install language runtimes on Cygwin, and if installing or compiling on Cygwin is prohibitively expensive, then install the Windows version (for example NodeJS, Haskell, and Idris). In both cases these language runtimes shouldn't be used for full development, for full development, use a docker container or a virtual machine. These language runtimes are installed for convenience and testing out language constructs.

An exception are language runtimes designed for Windows like Visual C/C++, Visual Basic, C# and F#. These can be used for development.

Note that Windows language runtimes won't have access to Cygwin executables in their PATH. Also remember to use Windows paths when developing in Windows language runtimes.