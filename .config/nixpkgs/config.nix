{
  packageOverrides = superPkgs:
  with superPkgs;
  {
    # python environment with python packages
    # used for IDE integration & experiments
    env-all = with pkgs; buildEnv {
      name = "env-all";
      paths = [
        # Fonts
        fira
        fira-mono
        fira-code
        dejavu_fonts
        # Web
        firefox
        chromium
        # Email
        thunderbird
        # Data Science
        sqlite-interactive
        sqlite3_analyzer
        sc-im
        gnuplot
        jq
        python36Packages.csvkit
        basex
        libxml2
        go-pup
        gdal
        proj
        qgis
        # Documents and Graphs
        zathura
        libreoffice
        ghostscriptX
        pandoc
        plantuml
        graphviz
        aspell
        aspellDicts.en
        pdftk
        dia
        # System Management & Monitoring
        lnav
        smem
        ncdu
        htop
        atop
        iftop
        iptraf
        iotop
        conky
        python36Packages.glances
        # Keyboard
        teensy-loader-cli
        # Math
        R
        bc
        # Shell and Environment Utilities
        file
        findutils
        redshift
        i3lock
        tree
        parallel
        asciinema
        reptyr
        lsof
        rmlint
        pv
        cv
        proot
        lsof
        picocom
        kdeApplications.konsole
        gnum4
        ag
        dex
        hicolor_icon_theme
        numix-gtk-theme
        gnome3.nautilus
        gnome3.dconf
        rlwrap
        trash-cli
        inotify-tools
        synergy
        # Security
        plasma5.polkit-kde-agent
        keybase
        oathToolkit
        certbot
        keepass
        # Archive Management
        zip
        unzip
        gzip
        bzip2
        lzma
        dpkg
        # Network
        openssl
        putty
        wget
        httpie
        aria
        mailutils
        bind
        ldns
        ipfs
        rsync
        wireshark
        nmap
        ncat
        socat
        hans
        iodine
        udptunnel
        httptunnel
        pwnat
        ngrok
        sslh
        geoipWithDatabase
        iperf
        conntrack_tools
        nethogs
        openvpn
        # Storage
        nfs-utils
        samba4
        netatalk
        dropbox-cli
        awscli
        unetbootin
        # Nix
        nix-repl
        nix-prefetch-scripts
        nix-index
        vulnix
        # Development
        emacs
        vimHugeX
        tmux
        binutils
        patchelf
        dos2unix
        qemu
        vagrant
        universal-ctags
        global
        python36Packages.binwalk-full
        python36Packages.pygments
        man-pages
        posix_man_pages
        libcap_manpages
        valgrind
        gdb
        lldb
        rr
        # Android
        libmtp
        go-mtpfs
        apktool
        python27Packages.gplaycli
        # IDE dependencies
        python36Packages.jedi
        python36Packages.flake8
        python36Packages.isort
        python36Packages.yapf
        python36Packages.pytest
        nodePackages.tern
        nodePackages.js-beautify
        rustracer
        go
        gocode
        godef
        # Chat
        weechat
        skype
        slack
        # X Window and XMonad
        xdg_utils
        xdg-user-dirs
        dmenu
        xorg.xev
        xorg.xmessage
        xorg.xwininfo
        xorg.xdpyinfo
        xdotool
        xclip
        hsetroot
        haskellPackages.xmobar
        # Media
        pavucontrol
        kdeApplications.spectacle
        vlc
        mplayer
        playerctl
        spotify
        beets
        ffcast
        ffmpeg
        feh
        sox
        graphicsmagick
        imagemagick
        v4l_utils
        mediainfo
        python36Packages.youtube-dl
        perlPackages.ImageExifTool
        dcraw
        # Radio
        gnuradio-with-packages
        gqrx
        # Gaming
        steam
        flightgear
        # Finance
        electrum
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
