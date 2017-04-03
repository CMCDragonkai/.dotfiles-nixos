{ selfPkgs }: {
    packageOverrides = superPkgs:
        {
          env-all = superPkgs.buildEnv {
                name = "env-all";
                paths = with selfPkgs; [
                    # Fonts
                    fira fira-mono fira-code dejavu_fonts
                    # Web
                    firefox chromium
                    # Data Science
                    sqlite-interactive sqlite3_analyzer jq goPackages.json2csv
                    gnuplot sc-im python27Packages.csvkit go-pup
                    # Documents and Graphs
                    zathura libreoffice ghostscriptX
                    pandoc plantuml graphviz
                    # System Management & Monitoring
                    lnav smem numactl ncdu htop atop iftop iptraf iotop conky
                    python35packages.glances
                    # Math
                    R bc synergy
                    # Shell Utilities
                    file findutils physlock kde5.konsole tree parallel asciinema
                    reptyr fuser lsof rmlint pv cv proot lsof picocom
                    kdeApplications.konsole
                    # Security
                    keybase vault gnupg plasma5.polkit-kde-agent certbot
                    # Archive Management
                    zip unzip gzip bzip2 lzma
                    # Network
                    openssl putty wget httpie aria mailutils bind
                    rsync wireshark nmap ncat socat
                    hans iodine udptunnel httptunnel pwnnat
                    caddy ngrok geoipWithDatabase iperf
                    # Storage
                    nfs-utils sambaFull netatalk dropbox awscli
                    # Development
                    nix-repl binutils nix-prefetch-scripts
                    man-pages man-pages.docdev libcap_manpages
                    nix-repl emacs vim tmux vagrant
                    python35packages.httpbin binwalk-full
                    docker gdb lldb rr
                    # Chat
                    weechat skype slack
                    # X Window and XMonad
                    xdg_utils xdg-users-dirs xdotool dmenu
                    xorg.xmessage xorg.xwininfo xorg.xdpyinfo
                    xdotool xclip hsetroot
                    # Media
                    ffmpeg graphicsmagick sox ponymix python35Packages.youtube-dl
                    beets feh imagemagick graphicsmagick vlc mplayer v4l_utils
                    mediainfo perlPackages.ImageExifTool dcraw
                    # Radio
                    gnuradio-with-packages gqrx
                    # Gaming
                    steam
                ];
            };
        };

    allowUnfree = true;
    pulseaudio = true;

    firefox = {
        enableAdobeFlash = true;
        enableAdobeReader = true;
    };

    chromium = {
        enablePepperFlash = true;
        pulseSupport = true;
        enableNaCl = true;
    };

}
