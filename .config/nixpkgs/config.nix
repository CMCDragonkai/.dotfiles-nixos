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
        sc-im
        gnuplot
        jq
        python27Packages.csvkit
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
        yed
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
        python35Packages.binwalk-full
        binutils
        patchelf
        dos2unix
        qemu
        vagrant
        universal-ctags
        global
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
        apktool
        python27Packages.gplaycli
        # IDE dependencies
        pythonEnv
        nodePackages.tern
        nodePackages.js-beautify
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
