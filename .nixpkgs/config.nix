# Local User Nix `config.nix` (located in `~/.nixpkgs/config.nix`, or specified by NIXPKGS_CONFIG)
# This attribute set/function returning attribute set is merged with the system `nixpkgs.config` attribute set.
# A package here is just an alias, there's an implicit assumption as to what actual package these names refer to.
# There's no reification of the package set hash, nor the package hash.
# Which means this is half the configuration (less than half), the rest of the required configuration is 
# in whatever is considered pkgs.
# We need to make this reified.
# We must make these content addressable dependencies.
# We have these things called `super` and `self` reminicient of OOP inheritance
# `super` always refers to the non-overridden packages (parent packages, while `self` refers to the overridden packages (child packages that inherit and override parent packages)
# How did this guy get home configuration into nixpkgs? https://github.com/kamilchm/.nixpkgs/blob/master/config.nix
# Also look: http://kkovacs.eu/cool-but-obscure-unix-tools
# Also consider packaging Manager with http://anderspapitto.com/posts/2015-02-28-deb-installation-nixos.html
# and http://sandervanderburg.blogspot.com.au/2013/09/composing-fhs-compatible-chroot.html
# It all makes sense now. Except manager doesn't have archive upstream URLs.
# 3 granularities:
# System Profile (system has 1 timeline, either go forward or backwards, don't fork profiles)
# User Profile (don't fork profiles, it gets difficult to understand with how it interacts with GC and rollbacks)
# Shell.nix (supersedes myEnvFun)
# However explore what this means: http://blog.matejc.com/blogs/myblog/control-your-packages-with-nix-environments/
# I need to test this out: http://sandervanderburg.blogspot.com.au/2013/09/managing-user-environments-with-nix.html
# And when this all works, publish another blog article on blog addressing content-addressed dependencies for NixOS
# pkgs is the fully configured packages, after overrides (supplied by pkgs/top-level/all-packages.nix)
{ selfPkgs }: { 

    # We can create custom package overrides for the user environment
    # We use this ability to define virtual packages that represent a package subset to install together

    packageOverrides = superPkgs: # super is the package set with overrides
        { 
            env-all = superPkgs.buildEnv { # make sure to use the non-overridden buildEnv 
                name = "env-all";
                paths = with selfPkgs; [ # allows packages here to install overridden packages
                    # Web
                    firefox 
                    chromium 
                    # Data Science 
                    sqlite-interactive # personal database
                    sqlite3_analyzer # analysers statistics about sqlite databases
                    jq 
                    goPackages.json2csv 
                    gnuplot 
                    sc-im # console spreadsheet
                    # csvkit # doesn't exist!
                    # Documents 
                    zathura 
                    libreoffice 
                    sc-im # console spreed sheet
                    # Secrets 
                    keybase 
                    pass 
                    qtpass 
                    # Network 
                    mailutils # command line emailing (not mutt)
                    httpie # better than curl for JSON 
                    bind # dns
                    rsync # file transfer 
                    aria # download management including bittorrent
                    wireshark # packet analysis analysis
                    nmap # network scanner including nping packet generator
                    ncat # replaces netcat and socat
                    socat # still need socat for obscure protocols (rs232 and tun) 
                    hans # ipv4 over icmp (bypass firewall) 
                    iodine # ipv4 over dns (bypass firewall) 
                    udptunnel # tcp/ip over udp (bypass firewall) 
                    httptunnel # tcp/ip over http (bypass firewall) 
                    pwnnat # ip through NAT (bypass NAT) 
                    caddy # simple http server 
                    ngrok # simple local tunnel 
                    picocom # rs232 embedded terminal emulator
                    python35Packages.youtube-dl # download media from media sites
                    speedtest-cli # use speedtest.net to test internet bandwidth 
                    geoipWithDatabase # geolocate IPs
                    iperf # test internet performance
                    # Archive Management
                    zip 
                    unzip 
                    # peazip # doesn't exist!
                    # System Management 
                    kde5.konsole 
                    kde4.ksystemlog # try this for visual system log analysis 
                    lnav # ncurses log viewer, no direct support for journalctl (but we can pipe and send syslog)
                    goaccess # web log analyzer, consider something that centralises log analysis later on 
                    smem # better than ps for memory reporting 
                    htop # better than top 
                    conky # local system monitoring 
                    proot # user space chroot 
                    synergy # share a mouse between multiple computers 
                    ncdu # file disk analyser
                    # Shell Utilities 
                    tree 
                    parallel 
                    asciinema 
                    reptyr 
                    fuser 
                    lsof 
                    rmlint 
                    pv 
                    cv 
                    # Math 
                    bc # for simple math calculations
                    R # for simple stats calculations
                    # Development 
                    nix-prefetch-scripts 
                    nix-repl 
                    emacs 
                    vim 
                    sage 
                    tmux 
                    vagrant 
                    binutils 
                    python35packages.httpbin # check if this works, it can be a local mock HTTP server! 
                    # gdb  # use shell.nix instead  
                    # lldb # use shell.nix instead 
                    # rr # use shell.nix instead 
                    # Writing, Graphing, Drawing 
                    pandoc 
                    plantuml 
                    graphviz 
                    # Chat 
                    weechat 
                    # Calculator 
                    qalculate-gtk 
                    # X
                    xorg.xwininfo # information on the display windows
                    xorg.xdpyinfo # information on the display devices
                    xdotool # for X server automation
                    # Pulseaudio 
                    ponymix # CLI control (probably better than pactl, not as powerful as pacmd)
                    pavucontrol # GUI control
                    # Windows Management
                    hsetroot # to set background wallpaper
                    # Media 
                    feh # image viewer
                    imagemagick # used by feh for SVG viewing
                    vlc # standard media player
                    mplayer # a more fleixble media player, also has mencoder
                    pavucontrol # pulseaudio GUI control 
                    graphicsmagick # swiss army knife for image processing 
                    ffmpeg # swiss army knife for video processing
                    sox # swiss army knife for sound processing
                    v4l_utils # utilities for interacting with video capture 
                    mediainfo # better than ffprobe
                    dcraw # process RAW images
                    # Radio 
                    gnuradio-with-packages # software defined radio 
                    gqrx # GUI SDR receiver
                    # Gaming 
                    steam 
                    # File & Folder Exploration
                    kde5.dolphin 
                    kde5.dolphin-plugins 
                    kde5.ffmpegthumbs 
                    kde5.kdegraphics-thumbnailers 
                    # File Synchronisation
                    dropbox 
                    dropbox-cli 
                ];
            };
        };

    # Global package options 

    allowUnfree = true; # allow unfree packages
    pulseaudio = true; # allow pulseaudio to be built into packages

    # Package specific options
    # iced tea is an opensource JRE

    firefox = {
        enableGeckoMediaPlayer = true;
        enableAdobeFlash = true;
        icedtea = true;
        enableAdobeReader = true;
    };

    chromium = {
        enablePepperFlash = true;
        enablePepperPDF = true;
        icedtea = true;
        pulseSupport = true;
        enableNaCl = true;
    };

}