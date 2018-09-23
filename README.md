# .dotfiles

This directory is meant to be located in `~/.dotfiles`.

Installation on Windows is (enter your computer name!):

Launch Powershell as Administrator and run...

```posh
# set your computer host name uniquely!
$ComputerName = 'POLYHACK-?'
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Invoke-WebRequest 'https://github.com/CMCDragonkai/.dotfiles/archive/master.zip' -OutFile '~/Downloads/.dotfiles-master.zip'
Remove-Item '~/Downloads/.dotfiles-master' -Recurse -Force -ErrorAction SilentlyContinue
Expand-Archive -Path '~/Downloads/.dotfiles-master.zip' -DestinationPath '~/Downloads' -Force
powershell -NoExit -NoLogo -NoProfile -ExecutionPolicy Unrestricted "& '~/Downloads/.dotfiles-master/.dotfiles-tools/install.ps1' -ComputerName '$ComputerName' -LogPath '${Env:TEMP}\.dotfiles.log'"
# Install all the remaining applications you want manually then run this:
powershell -NoExit -NoLogo -NoProfile -ExecutionPolicy Unrestricted "& '~/Downloads/.dotfiles-master/tools/set-windows-path.ps1'"
```

Windows installation requires multiple restarts so check the log later for details. It is also not fully unattended, there are some package installations that require prompts.

Installation on Linux (NixOS) is:

```sh
# if you already have git
# we need gnum4 to run the installation
nix-env -i gnum4
git clone --recurse-submodules https://github.com/CMCDragonkai/.dotfiles
cd .dotfiles
.dotfiles-tools/install.sh
```

```sh
# if you don't have git
curl --location --create-dirs https://github.com/CMCDragonkai/.dotfiles/archive/master.tar.gz --output ~/Downloads/.dotfiles-master.tar.gz
rm --recursive --force ~/Downloads/.dotfiles-master && tar xvzf ~/Downloads/.dotfiles-master.tar.gz --directory ~/Downloads
~/Downloads/.dotfiles-master/.dotfiles-tools/install.sh
```

However some steps needs to be reversed. On NixOS, we must first install all the tools before bringing in all the other .dotfiles. So our install.sh must copy `config.nix` first, then install everything with `nix-env -i env-all`.

## Permissions

Git only persists 755 or 644 for files, and directories are always 755. This means without any further processing after installation all files will appear either as executables or non-executables with read permission for the group and others, while directories are always readable and executable for the group and others. Sensitive folders should be explicitly modified to have their read and execute permissions for non-owners removed.

## PowerShell Execution of Windows Symlinks to Executables

You actually have to use `Start-Process` or the shorcut `start`. You cannot just
execute it directly by calling its executable name or using the call operator `&`.

This is however not necessary in Cygwin shells, which will automatically launch
them.

## DNS

Run acrylic with these configuration.

You will need powershell to point DNS server to localhost 127.0.0.1.

```
Set-DnsClientServerAddress -InterfaceAlias 'WiFi' -ServerAddresses '127.0.0.1' -Validate
Set-DnsClientServerAddress -InterfaceAlias 'WiFi' -ServerAddresses '::1' -Validate
```

Note that DNSAgent supports both ipv4 and ipv6 and is listening on both. Verify with Windows:

```
netstat -a -b -p udp | select-string -SimpleMatch '127.0.0.1:53 ' -Context 0,1
netstat -a -b -p udpv6 | select-string -SimpleMatch '[::1]:53 ' -Context 0,1
```

You can also set it for Local Area Connection. But you'll need to find what your Interface Alias is, WiFi is common for laptops and Local Area Connection is common for desktops. Use `Get-NetAdapter` to see all available interfaces. Note that unconnected interfaces may be hidden. Also to check what all the interfacers have their DNS set to, run `Get-DnsClientServerAddress`. You can then set the DNS servers as well as their alternatives for IPv4 and IPv6 interfaces.

If you're using Hyper-V and bridging into your WiFi, you will find that WiFi is no longer available, and instead you'll need to configure your DNS via an interface that begins with `vEthernet` interface.

## Java

Java applets are a dieing breed. Google Chrome does not support JRE at all. While only Firefox 32 bit supports JRE, and it requires 32 bit JRE. On Windows 10, if you need to run Java applets, after installing JRE, you can use Internet Explorer.

## Interesting Paths

`%ALLUSERSPROFILE%` - Points to a common user profile directory (that is viewable by all users on the OS). We should create a `%ALLUSERSPROFILE%/bin` directory to add PATH symlinks to all Windows executables that we install into here (this makes sense as installed Windows executables are usually installed on the entire system, not for a particular user). This refers to any natively installed Windows executable, or any extracted Windows executable.

`%APPDATA%\bin` - Should be used for User Profile installed Windows Apps bin.
`%LOCALAPPDATA%\bin` - Should be used for User Profile locally installed Windows Apps bin.

Data files should generally be in `%LOCALAPPDATA%`, see Manager.io. But applications should be in Roaming Profile. At least there's no reason why not?

In linux, data is often considered shared, because they are architecture indepedent. So data should be on a roaming profile, but applications which is architecture specific should be on a local profile. Thus manager should be installing on a local profile. This means there should not be an `%APPDATA%\bin`. The Windows PATH includes `%LOCALAPPDATA%\bin`.

Path hierarchy on Windows:

* Default Windows Paths (on Windows): `C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\`
* Chocolatey path (on Windows): `%ALLUSERSPROFILE%\chocolatey\bin` (use `$env:ChocolateyPath\bin` instead)
* Custom Windows Path (on Windows): `%ALLUSERSPROFILE%\bin`
* Cygwin Paths (on Cygwin): `/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin`
* Home paths (on Cygwin): `~/bin`

To take advantage of Home paths in CMD, make sure to set startup task to: `cmd /K %USERPROFILE%/.cmd_profile`

## Keyboard Control

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

Shell Commands:

* <kbd>Shift</kbd> + <kbd>Tab</kbd> - Enter literal tab
* <kbd>Ctrl</kbd> + <kbd>Z</kbd> - Toggle backgrounding and foregrounding
* <kbd>Shift</kbd> + <kbd>Enter</kbd> - Non-executing enter to allow multiline commands
* <kbd>Ctrl</kbd> + <kbd>C</kbd> - Send SIGINT
* <kbd>Ctrl</kbd> + <kbd>\</kbd> - Send SIGQUIT
* <kbd>Ctrl</kbd> + <kbd>U</kbd> - Send SIGTERM

For Spacemacs (not all keybindings are shown here, only the important ones):

* Copy to System Clipboard - <kbd>"</kbd> + <kbd>+</kbd> + <kbd>y</kbd>
* Paste from System Clipboard - <kbd>"</kbd> + <kbd>+</kbd> + <kbd>p</kbd>

Hotkey Hierarchy:

* Linux Commands -> XMonad Commands -> Terminal Emulator Commands -> Tmux Commands -> Shell Commands -> Application Commands
* Windows Commands -> ConEmu Commands -> Mintty Commands -> Tmux Commands -> Shell Commands -> Application Commands

Linux Commands:

* <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>F*</kbd> - Switch between TTYs and also X.

## Terminal Emulator

Our terminal emulator would preferably support sixel graphics, W3M images, and ligatures.

On Linux we have the kitty terminal.

On Windows we use these 3:

* Mintty - No sixel, no w3m images, no ligatures, only on Windows.
* Conhost - Windows default terminal emulator for Powershell and CMD.
* ConEmu - Wraps up both Mintty and ConHost and other gui applications and manages them.

The Search Field in ConEmu only applies to ConHost applications. Things like Powershell and CMD that uses Windows ConHost. If you are running mintty, the search field in ConEmu does not work. Instead Mintty has its own search functionality. This is because mintty is a terminal emulator itself, and ConHost is  Windows terminal emulator!

## Fonts

The most ideal ones are those that are multilingual, monospaced, supports ligatures, supports box drawing, supports powerline, supports a good number of unicode symbols and support even APL, but this probably doesn't exist. So we have a number fonts available to choose from in different situations:

* Anonymous Pro
* Source Code Pro
* FiraCode
* Monoid
* Hasklig
* Input
* DejaVu Sans Mono

Paid Fonts:

* PragmataPro - Paid

Fallback Fonts:

* Consolas - Windows
* Inconsalata - Linux

```sh
# shows fonts available
# cyginw doesn't show all available Windows fonts
fc-list
# after installing or uninstalling fonts use this to refresh the cache
fc-cache --really-force --verbose
# also run it for root
sudo fc-cache --really-force --verbose
```

## ZSH as Default Shell

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

The startup task for ConEmu for a non-login shell should be: `%ALLUSERSPROFILE%\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico`.

The startup task for ConEmu for a login shell should be: `%ALLUSERSPROFILE%\cygwin64\bin\mintty.exe -i /Cygwin-Terminal.ico -`.

## Process Hierarchy on Cygwin

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

## Development

On adding new dependencies:

```
cd "$(git rev-parse --show-toplevel)"
git submodule add <repo> .dotfiles-modules/<repo-name>
git submodule update --init --recursive --depth 1 .dotfiles-modules/<repo-name>
```

On removing dependencies that have been committed:

```
cd "$(git rev-parse --show-toplevel)"
package=".dotfiles-modules/package"
git submodule deinit --force "$package"
git rm --force "$package"
rm --verbose --recursive --force --dir ".git/modules/$package"
```

On updating dependencies to the latest in their branch:

```
cd "$(git rev-parse --show-toplevel)"
git submodule update --init --recursive --remote --merge .dotfiles-modules/<repo-name>
# to change the working index, go into the submodule and use git checkout
```

On changing dependency upstream URL:

```
cd "$(git rev-parse --show-toplevel)"
git config --file=".gitmodules" "submodule..dotfiles-modules/<repo-name>.url" "<repo>"
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

Also Windows con hosts get /dev/cons0 but this is not usable because of a limitation of Windows. So they get tty too, but its useless.

* Investigate where TTY environment variable was set in ZSH
* Make $TTY appear in Mintty's window title (or ZSH's RPROMPT).
    - http://randomartifacts.blogspot.com.au/2012/10/a-proper-cygwin-environment.html
* Make $TTY appear in Tmux's panel title (or ZSH's RPROMPT).

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

Vim and Spacemacs Controls.

Both Vim and Spacemacs have:

1. Buffers
2. Windows

Both have a similar concept to "workspaces". Vim has tabs while Spacemacs has layouts and also workspaces which act like sublayouts. This linke explains the similarity between Spacemacs layouts and Vim tabs: http://joshldavis.com/2014/04/05/vim-tab-madness-buffers-vs-tabs/

Basically you only need "workspaces", when you're working across multiple independent projects that have no relation to each other.

Note that the clipboard is shared between the same instance of Vim. This is better than running multiple Vim instances in separate terminals, and then coordinating the clipboard between Vim instances through the desktop system.

Vim controls:

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

---

Moving processes between terminal emulators, screens, shells... etc. And also changing their redirection parameters (such as after suspending and backgrounding), this is useful for actual process management.

* http://monkeypatch.me/blog/move-a-running-process-to-a-new-screen-shell.html
* https://github.com/nelhage/reptyr
* http://stackoverflow.com/questions/1323956/how-to-redirect-output-of-an-already-running-process
* https://github.com/jerome-pouiller/reredirect/

---

Power monitoring:

Use `powertop` to monitor against processes.

Use `upower` to check up on your power status of the computer.

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

Graphics Programming
--------------------

Since you probably have an NVIDIA computer, then you should first install the NVIDIA Graphics driver and then the CUDA SDK. The CUDA SDK includes the OpenCL SDK.

Unfortunately I don't have this automated in Chocolatey, so this is a manual process.

Once these are installed, you can test if everything is working by first launching "Visual C++ 2015 x64 Native Build Tools Command Prompt", and then running:

```
cd "C:\ProgramData\NVIDIA Corporation\CUDA Samples\v8.0\5_Simulations\nbody"
msbuild ./nbody_vs2015.sln
rem Now go run the actual executable, the output of the command should show where it is
msbuild ./nbody_vs2015.sln /target:Clean
rem The above will clean all the build artifacts including the nbody.exe
```

This shows you don't really need all of Visual Studio to work with CUDA. You just need the Visual C++ Build Tools package.

Running the above requires the .NET Framework 3.5 feature to be enabled. This is already automated in `./install.ps1`.

Then you want to get the cuDNN library. To do this, you need to go get the appropriate cuDNN library. For Windows, it's a matter of downloading the zip file, and copying the `bin`, `lib` and `include` directories into `C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v8.0\`. I've already added the appropriate directories to the PATH.

## Full Disk Encryption

Windows:

Go to gpedit.msc and `Computer Configuration -> Administrative Templates -> Windows Components -> Bitlocker Drive Encryption -> Operating System Drives`, and activate these 3:

* Require additional authentication at startup
* Enable use of Bitlocker authentication requiring preboot keyboard input on slates
* Allow enhanced PINs for startup

All the sub-options can be left as default.

You can now add a TPMAndPin authentication:

```
manage-bde -protectors -add c: -TPMAndPin
```

Remember to backup your Recovery Key (called "Numerical Password" or "Recovery Password") to a USB and paper.

## Virtual desktops/Workspaces

Windows:

Win + Ctrl + D : to create new desktop
Win + Ctrl + F4 (Fn) : to destroy current desktop (moves all windows to previous desktop)
Win + Ctrl + Left/Right : move between desktops
Win + Tab : Show all windows and virtual desktops
Four Finger Scroll Left/Right : move between desktops
Three Finger Scroll Left/Right : see alt+tab

Unfortunately on Windows, you cannot project virtual desktops to multiple monitors

XMonad:

I changed from the original Mod + {W,E,R} to these:

Mod + N - Switch Focus Workspace N
Mod + Shift + N - Shift focused window to Workspace N
Mod + Ctrl + N - Switch Focus to Screen N
Mod + Alt + N - Shift focused window to Workspace at Screen N

---

Docker for Windows

You need to first launch Docker for Windows (it's not launched by default).
This will start the HyperV virtual machine. By default it tries to launch with 2GiB of RAM.
Switch this down to 1.5 GiB in the Docker for Windows Settings (just for my 8 GiB laptop).

A default NIC (sometimes called "virtual switch") for Docker will be running.

The docker creates a HyperV VM called MobyLinuxVM which is booted with mobylinux.iso.

This VM can be managed by Hyper-V Manager. The only network card attached to it is the DockerNAT.
Which is only internal, so it has no external internet access. Remmeber this is just like Virtual Box.

With Hyper-V switched ON, VirtualBox is not able to run!

The VM is a full Linux VM using the `Kernel Version: 4.4.27-moby` kernel.

The OS is `Alpine Linux v3.4`. It's harddisk is by default located in: `C:\Users\Public\Documents\Hyper-V\Virtual Hard Disks\MobyLinuxVM.vhdx`.

---

Firewall Profiles.

On most desktop computers, outbound connections are by default allowed, but inbound connections not matching a particular rule are by default disallowed.

Which means we are mostly going to be allowing things via inbound rules, and disallowing things via outbound rules.

This is true for both Windows and Linux. Although on Windows, there are 3 firewall profiles used for 3 different network profiles: Domain, Private and Public. In all 3 profiles the above is still true (although it is editable). We'll leave that to be default to keep things simple.

Now a network adapter or "network interface card/controller" is piece of hardware. A network interface is a software construct. A single network adapter can expose multiple network interfaces. An OS can create virtual network interfaces that only exist in software. Like virtual ethernets.. etc. See: https://en.wikipedia.org/wiki/Virtual_network_interface

Each network interface can be given a network profile on Windows. Each network profile has its corresponding firewall rule set.

The 3 profiles are: Domain, Private and Public. Domain is used specifically for Windows Domain network. We will not bother with this except, by considering that Domain networks will be as safe as Private networks. Private networks should be used for trusted networks. And public should be used for any network where you don't control all the nodes or you don't trust all the nodes.

A network profile is sometimes called a "network location". I guess a firewall profile has a 1 to 1 correspondence with "network location".

Now I thought each individual known WiFi network has a setting for network location, I wouldn't think an entire interface is set to a particular network location. At least it would make sense for this setting to be specific to each WiFi network. Your home wifi network should be private, but your coffee shop wifi should be public.

* `InterfaceAlias` - Name of the network interface. (Can be renamed from `Control Panel\Network and Internet\Network Connections`)
* `InterfaceDescription` - Description of the network interface.
* `InterfaceIndex` - Numeric index of the network interface.
* `NetworkCategory`/`Network Location`/`Firewall Profile` - Public/Private/Domain
* `Network Name`/`Connection Profile` - A particular connection that the network interface is connected to. Having a network interface doesn't mean it's connected to an actual connection! You could have a WiFi network interface that isn't connected to anything, and when it is, it is connected to a WiFi network. That WiFi network represents a single connection profile with a network name is assigned to the WiFi SSID.

The Control Panel\Network and Internet\Network Connections switching to list view is actually quite confusing.

To be exact what we actually see is:

* Name -> InterfaceAlias
* Status -> Disabled, Enabled, Not Connected, <Network Name/Connection Name>
* Device Name -> InterfaceDescription
* Connectivity -> Blank, No network access, No Internet access, Internet access
* Network Category -> Domain network, Private network, Public network

The weird thing is Status and Connectivity. Both are quite confusing. The important thing is that Status can actually show you the network name/connection profile when that interface thinks its connected to something. For WiFi adapter, this is often set automatically to the WiFi SSID. For Ethernet adapters, this is often set to an enumerated name like `Network 3`. For virtual network interfaces, this name may not be set, which means it is defaulted to `Unidentified network`.

I'm not sure what the difference between `Enabled` and `Not Connected` is. Anyway, the GUI is ultimately unreliable, so we have to use powershell commands.

The main point is that network names are not really important for ethernet interfaces or virtual network interfaces, since these are most likely alwaysb plugged to the same connection. However network names are quite important for the wifi interface, as this is how you know which wifi network you're connected to, and you most likely will want a specific network category for a specific wifi network name.

```
# Gets all the network interfaces (does not include loopback)
Get-NetAdapter
# Gets all the network interfaces including hidden interfaces (does not include loopback)
Get-NetAdapter -IncludeHidden
# Gets all the network interfaces corresponding to an actual network adapter (does not include loopback)
Get-NetAdapter -Physical
# Gets all network interfaces that have an IP address (IPv4 and IPv6) (includes loopback interfaces)
Get-NetIPInterface
# Gets all the actual connections. Shows the network name for the connection, the interface that the connection is connected to
Get-NetConnectionProfile
# Gets all the IPs assigned to the interfaces (there can be multiple IPs to each interface)
Get-NetIPAddress
# Gets the relationship between network interfaces and IPs along with metadata
Get-NetIPConfiguration
# Gets the relationship betwene network interfaces (including hidden network interfaces) and IPs along with even more metadata
Get-NetIPConfiguration -All -Detailed
# Gets the routing table (compare with `route PRINT`)
Get-NetRoute
```

In looking up the hidden network interfaces, we can see quite a few interesting network interfaces that are hidden:

* `Microsoft Wi-Fi Direct Virtual Adapter` - this is the new interface that replaces the hosted network feature in older windows devices (if you want to use this, you need to go into windows 10 settings, and go to "Mobile hotspot", haven't found any powershell automation for this)
* `Microsoft Kernel Debug Network Adapter` - this adapter is used to allow another computer to debug this computer's kernel remotely

Loopback interfaces however are still now shown. But we can find them via `Get-NetIPAddress`:

* `Loopback Pseudo-Interface 1` - 127.0.0.1 and ::1

But there's not much to do with the loopback interface, so let's try something else.

What if we want to be able to create a virtual network interface. Just some random interface for the purposes of creating of simulating a LAN party. We could potentially launch multiple programs binding to the virtual network interface using a particular IP (a static IP) or running a virtual DHCP server on this interface. Well


Common networks to ping!

```
ping google-public-dns-a.google.com
ping 8.8.8.8
ping google-public-dns-b.google.com
ping 8.8.4.4
ping internetbeacon.msedge.net
ping 13.107.4.52
ping b.resolvers.level3.net
ping 4.2.2.2
```

You can show your network password being used for a particular connection by doing:

```
netsh wlan show profiles name="Network Name" key=clear
```

It also shows some interesting metadata for the connection profile.

You can also delete profiles by doing this:

```
netsh wlan delete profile name="<profile-name>"
```

There are some interesting properties of profiles you can do:

```
# enables MAC randomization for a profile
# this means the MAC is randomly set for the particular profile, and does not change upon reconnection
# an alternative policy is to change it daily (which then changes the mac daily)
# while you can't use this to get around open wifi schemes, you can use this for privacy reasons
netsh wlan set profileparameter name="<profile-name>" Randomization=yes|no|daily
# sets whether to connect when in range automatically
netsh wlan set profileparameter name="<profile-name>" ConnectionMode=auto|manual
# sets whether the connection is metered or not (unrestricted is the default), while fixed is when it is metered
# setting something to metered can make windows 10 apps not try to run updates on these connections, or make them use less data
# can be useful for wifi connections where you have limited data!
netsh wlan set profileparameter name="<profile-name>" cost=default|unrestricted|fixed|variable
# choose whether to connect even when the network is not broadcasting its ssid
netsh wlan set profileparameter name="<profile-name>" nonBroadcast=yes|no
# choose whether to automatically switch to a higher priority wifi network if that network becomes in range
# only works if the ConnectionMode is auto (not sure if this is the current network or the higher prority network)
netsh wlan set profileparameter name="<profile-name>" autoSwitch=yes|no
```

There is a priority order that can be changed for wlan profiles:

```
# set this profile on this interface to be on priority 1
# all 3 parameters are required
netsh wlan set profileorder name="<profile-name>" interface="<interface-alias>" priority=1
```

The order is shown on `netsh wlan show profiles`.

This is only useful for the autoswitching functionality, and when there are multiple wifi networks in range you want to connect to.

After doing all of this, it's possible to export the WiFi profiles.

---

The only way to change the names of any profile in a fool proof manner is to use regedit. While yes you can change the name by using `Get-NetConnectionProfile` and then `Set-NetConnectionProfile`, this only works for currently connected connection profiles. TO do it for any profile whether LAN or WLAN whether connected or not connected, you have to do with: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles`, and change the `ProfileName`. It is the `ProfileName` that gets used, however do note that you will need to restart before this name is propagated everywhere. Note the `Description` field which is often just number truncated version of `ProfileName`. Also note that unindentified connection profiles will not be listed here!

> First let’s start with what NLA does. For each network interface the PC is connected to, NLA aggregates the network information available to the PC and generates a globally unique identifier (GUID) to identify each network. In other words, it creates a Network Profile for any network it connects to. The Windows Firewall then uses that information to apply rules from the appropriate Windows Firewall Profile. This allows you to apply a different set of Firewall rules depending on which network you are connected to. For example, a Public network could get a very restrictive set of rules, a Home network could get a less restrictive set of rules, and a Managed network could get a set of rules determined by an administrator. NLA can be used for more but I want to focus on how it interacts with the Windows Firewall.

It turns out that the only way to set a connection profile's category (regardless of whether that connection profile is currently connected) is via this same registry area. Basically this is controlled by the `Category` DWORD. Where `0` means public and `1` means private.

Ok and since there aren't any powershell modules dealing with this, one can create a simple script that allows showing all the profiles, and allows you to change its category and its name and description. Simple!!

To have LAN profiles shown, one must activate the Wired AutoConfig service. Does this end up showing the unindentified profiles!?

---

Need a command that interrogates that and gives options. Really for WiFi management.

Need a command to test if a firewall port is open or something.

Need a command to change connection profile names for local connections. This is not necessary really.

HOWEVER it is important to be able to set the network category for the ethernet networks, and without the necessary labels, you can't do this!? And the registry doesn't support it. It's because they are still unidentified, the first method doesn't work!

That is basically it.

```
devcon64 find '*MSLOOP'
devcon64 install ${Env:WINDIR}\INF\netloop.inf '*MSLOOP'
devcon64 remove @ROOT\NET\0000
```

---

Any unidentified networks are all put into the public category. For virtual interfaces, they are often directly connected to some unindentified network, the computer doesn't ask you what category you want to put them in, and the only way to set their categories is via `Get-NetConnectionProfile` and `Set-NetConnectionProfile`. This results in a minor problem. One way to get around this is to have Public category firewall rules that address this particular issue. These rules apply to the Public Category, but they specify that the remote address must be a local subnet. This appears to refer to a set of addresses that Microsoft considers to be a local subnet. I don't know exactly what these are addresses are, but I know that loopback addresses are considered to be from the a local subnet.

---

On Windows, the path hierarchy goes SYSTEM PATH + USER PATH. This means the SYSTEM PATH always takes precedence over the USER PATH. This means USER PATH executables can never shadow SYSTEM PATH executables.

However on Linux, it is the other way around, local PATH customisations are intended be prepended to the PATH (although you do have the option of appending it), that way you can wrap system executables. This is in fact what we do, while leaving the Windows user path to be appended to the system path, Cygwin path additions are always prepended.

Just something to beaware of you intend to wrap Windows executables

---

Node and Node-Gyp. Some Node packages require the usage of Node-Gyp and Windows Python to compile on Windows. For this to work you must first run `npm config set msvs_version 2015`, in this case, I have already set it to the 2015 version, because I have the 2015 Visual C++ Build tools. But then afterwards, you may need to run the entire `npm install -g ...` command inside the Visual C++ 201* x64 Build Tools Command Prompt so it can find the necessary tools (MSBuild.. etc).

---

To upload the new firmware to Ergodox EZ you need to run:

```
sudo teensy-loader-cli --mcu=atmega32u4 -w -v ./ergodox_ez_firmware_dragonflare_qnxevg.hex
```

Make sure to have the reset button available.

Change the layout here: https://configure.ergodox-ez.com/keyboard_layouts/qnxevg/edit

---

Default List of Applications for NixOS

Use xdg-mime, it operates on the file ~/.local/share/applications/mimeapps.list.

Note that I symlinked ~/.config/mimeapps.list to this file, to avoid confusion when you're added entries there, and forgot that it overrides the settings set by xdg-mime. That way there's only 1 place that sets the filetype associations.

Also where are the desktop files located? They are in ~/.nix-profile/share/applications. Those are the places to look for desktop apps installed by nix-env. For system apps, the are located in `/run/current-system/sw/share/applications`. But most GUI apps should be part of nix-env, not the system configuration.

---

Trash cli has been installed, when attempting to reclaim space, make sure to use `trash-empty`.

---

Every time you update the Nix channel/Nix package set, make sure to rerun `nix-index` to rebuild the search index for `nix-locate`.

---

Windows Defender can slow down compilation times, make sure to go to Windows Defender and add in process exclusions for your compilers. But don't do it for your interpreters as they can be used for malicious things. This is now done inside the install.ps1. This will add exclusions to speed up compilation.

---

Manage xrandr profiles using `autorandr`. You can always setup your windows and then use `autorandr --save default`.
