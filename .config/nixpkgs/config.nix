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
        hdf5
        # Documents and Graphs
        libreoffice
        zathura
        ghostscriptX
        poppler_utils
        pdftk
        pandoc
        plantuml
        graphviz
        dia
        aspell
        aspellDicts.en
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
        oathToolkit
        certbot
        keepass
        keybase
        pcsctools
        paperkey
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
        filezilla
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
        shellcheck
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
        docker_compose
        runc
        # Android
        libmtp
        go-mtpfs
        apktool
        python27Packages.gplaycli
        # IDE dependencies
        (
          with python36Packages;
          python.buildEnv.override {
            extraLibs = [
              setuptools
              jedi
              flake8
              isort
              yapf
              pytest
            ];
          }
        )
        nodePackages.tern
        nodePackages.js-beautify
        rustracer
        go
        gocode
        godef
        haskellPackages.stylish-haskell
        haskellPackages.pretty-show
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
        gimp
        graphicsmagick
        imagemagick
        libtiff
        v4l_utils
        mediainfo
        python36Packages.youtube-dl
        perlPackages.ImageExifTool
        dcraw
        zbar
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
