{
    packageOverrides = superPkgs:
        with superPkgs; {
          env-all = with pkgs; buildEnv {
                name = "env-all";
                paths = [
                    # Fonts
                    fira fira-mono fira-code dejavu_fonts
                    # Web
                    firefox chromium
                    # Data Science
                    sqlite-interactive sqlite3_analyzer jq
                    gnuplot sc-im python27Packages.csvkit go-pup
                    # Documents and Graphs
                    zathura libreoffice ghostscriptX
                    pandoc plantuml graphviz
                    # System Management & Monitoring
                    lnav smem ncdu htop atop iftop iptraf iotop conky
                    python35Packages.glances
                    # Math
                    R bc synergy
                    # Shell Utilities
                    file findutils i3lock tree parallel asciinema
                    reptyr lsof rmlint pv cv proot lsof picocom
                    kdeApplications.konsole gnum4 platinum-searcher
                    hicolor_icon_theme numix-gtk-theme gnome3.nautilus
                    gnome3.dconf
                    # Security
                    keybase vault gnupg plasma5.polkit-kde-agent certbot keepass
                    # Archive Management
                    zip unzip gzip bzip2 lzma
                    # Network
                    openssl putty wget httpie aria mailutils bind
                    rsync wireshark nmap ncat socat
                    hans iodine udptunnel httptunnel pwnat
                    caddy ngrok geoipWithDatabase iperf
                    conntrack_tools
                    # Storage
                    nfs-utils samba4 netatalk dropbox-cli awscli
                    # Development
                    nix-repl binutils nix-prefetch-scripts
                    man-pages posix_man_pages libcap_manpages
                    nix-repl emacs vim tmux vagrant
                    python35Packages.httpbin python35Packages.binwalk-full
                    docker gdb lldb rr nodePackages.tern
                    # Chat
                    weechat skype slack
                    # X Window and XMonad
                    xdg_utils xdg-user-dirs xdotool dmenu
                    xorg.xmessage xorg.xwininfo xorg.xdpyinfo
                    xdotool xclip hsetroot
                    # Media
                    ffmpeg graphicsmagick sox pavucontrol ffcast
                    python35Packages.youtube-dl beets feh imagemagick graphicsmagick
                    vlc mplayer v4l_utils mediainfo perlPackages.ImageExifTool dcraw spotify
                    # Radio
                    gnuradio-with-packages gqrx
                    # Gaming
                    steam
                ];
            };
        };

    allowUnfree = true;
    pulseaudio = true;

    chromium = {
        pulseSupport = true;
        enableNaCl = true;
    };

}
