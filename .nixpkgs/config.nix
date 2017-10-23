{
  packageOverrides = superPkgs:
  with superPkgs;
  {
    # python environment with python packages
    # used for IDE integration & experiments
    pythonEnv = with pkgs; buildEnv {
      name = "pythonEnv";
      paths = [
        (with python27Packages; python.buildEnv.override {
          extraLibs = [
            setuptools
          ];
        })
        (with python35Packages; python.buildEnv.override {
          extraLibs = [
            setuptools
            jedi
            flake8
            isort
            yapf
            pytest
            numpy
          ];
        })
      ];
    };
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
        jq
        gnuplot
        sc-im
        python27Packages.csvkit
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
        python35Packages.glances
        # Keyboard
        teensy-loader-cli
        # Math
        R
        bc
        # Shell and Environment Utilities
        file
        findutils
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
        platinum-searcher
        dex
        hicolor_icon_theme
        numix-gtk-theme
        gnome3.nautilus
        gnome3.dconf
        rlwrap
        trash-cli
        synergy
        # Security
        plasma5.polkit-kde-agent
        keybase
        certbot
        keepass
        # Archive Management
        zip
        unzip
        gzip
        bzip2
        lzma
        # Network
        openssl
        putty
        wget
        httpie
        aria
        mailutils
        bind
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
        # Storage
        nfs-utils
        samba4
        netatalk
        dropbox-cli
        awscli
        unetbootin
        # Development
        emacs
        vimHugeX
        tmux
        nix-repl
        nix-prefetch-scripts
        python35Packages.binwalk-full
        binutils
        patchelf
        dos2unix
        qemu
        vagrant
        man-pages
        posix_man_pages
        libcap_manpages
        valgrind
        gdb
        lldb
        rr
        # IDE dependencies
        pythonEnv
        nodePackages.tern
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
        python35Packages.youtube-dl
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
