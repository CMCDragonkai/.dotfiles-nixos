{ pkgs, username, inputs, ... }:

{
  imports = [ inputs.polykey-cli.homeModules.default ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "dcraw-9.28.0"
      "googleearth-pro-7.3.6.10201"
    ];
  };
  nixpkgs.overlays = [
    (self: super: {
      pkgsMaster = import inputs.nixpkgsMaster {
        system = self.system;
        config = super.config;
      };
    })
  ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    packages = with pkgs; [
      # Web
      firefox
      # Email
      thunderbird
      # System Management & Monitoring
      lnav
      smem
      ncdu
      htop
      atop
      iftop
      iptraf-ng
      nethogs
      iotop
      sysstat
      powertop
      stress-ng
      fio
      conky
      bench
      hyperfine
      glances
      gptfdisk
      # Keyboard
      teensy-loader-cli
      keymapp
      # Math
      bc
      # Shell and Environment Utilities
      file
      findutils
      redshift
      i3lock
      tree
      parallel
      asciinema
      asciinema-agg
      asciinema-scenario
      reptyr
      lsof
      pv
      mbuffer
      progress
      proot
      picocom
      kitty
      kitty.terminfo
      gnum4
      silver-searcher
      dex
      dunst
      libnotify
      hicolor-icon-theme
      adwaita-icon-theme
      nautilus
      dconf
      rlwrap
      trash-cli
      inotify-tools
      expect
      libcgroup
      criu
      appimage-run
      # Security
      libsecret
      seahorse
      polkit-kde-agent
      oathToolkit
      certbot
      pcsctools
      paperkey
      step-cli
      # Archive Management
      zip
      unzip
      gzip
      bzip2
      unrar
      xz
      dpkg
      rpmextract
      unetbootin
      # Nix
      nix-prefetch-scripts
      nix-index
      nix-bundle
      nix-diff
      # X Window and XMonad
      xdg-utils
      xdg-user-dirs
      dmenu
      xorg.xev
      xorg.xmessage
      xorg.xwininfo
      xorg.xdpyinfo
      xorg.xhost
      xdotool
      xclip
      xrectsel
      glxinfo
      hsetroot
      haskellPackages.xmobar
      feh
      autorandr
      arandr
      # Audio Video
      pavucontrol
      playerctl
      beets
      vlc
      mplayer
      # Network
      inetutils
      iputils
      mitmproxy
      nssTools
      mkcert
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
      charles
      nmap
      socat
      hans
      iodine
      udptunnel
      httptunnel
      pwnat
      sslh
      geoipWithDatabase
      iperf
      conntrack-tools
      openvpn
      autossh
      filezilla
      samba4
      netatalk
      awscli
      ngrok
      tigervnc
      remmina
      websocat
      signal-desktop
      # Devices
      libmtp
      gqrx
      # Fonts
      fira
      fira-mono
      fira-code
      corefonts
      # Documents
      libreoffice
      zathura
      ghostscriptX
      poppler_utils
      pdftk
      pandoc
      texlive.combined.scheme-small
      aspell
      aspellDicts.en
      monolith
      # Development
      (
        vscode-with-extensions.override {
          vscodeExtensions = (
            (with vscode-extensions; [
              vscodevim.vim
              jnoortheen.nix-ide
              ms-python.python
              ms-vscode.cpptools
              haskell.haskell
              golang.go
              eamodio.gitlens
              editorconfig.editorconfig
              kahole.magit
              zxh404.vscode-proto3
              redhat.vscode-yaml
              tamasfe.even-better-toml
              jock.svg
              bradlc.vscode-tailwindcss
              vspacecode.vspacecode
              vspacecode.whichkey
              bodil.file-browser
              dotenv.dotenv-vscode
              unifiedjs.vscode-mdx
              continue.continue
              github.vscode-github-actions
            ]) ++ vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "fuzzy-search";
                publisher = "jacobdufault";
                version = "0.0.3";
                sha256 = "0hvg4ac4zdxmimfwab1lzqizgq8bjfq6rksc9n7953m9gk6m5pd0";
              }
              {
                name = "vscode-edit-csv";
                publisher = "janisdd";
                version = "0.9.1";
                sha256 = "0b2bgz9r06ks2yaryg7s4dnxv5j1c1p87c3r49wj844w8rgk8xz5";
              }
            ]
          );
        }
      )
      gcc
      scc
      cachix
      vimHugeX
      patchelf
      dos2unix
      flyctl
      qemu
      libguestfs
      shellcheck
      universal-ctags
      global
      binwalk
      python3Packages.pygments
      man-pages
      man-pages-posix
      libcap.doc
      valgrind
      gdb
      lldb
      rr
      docker-compose
      runc
      ipmitool
      ipmiutil
      kubectl
      aws-iam-authenticator
      # R
      R
      # Python
      python3
      # Node
      nodejs
      nodePackages.node2nix
      # Go
      go
      gopls
      godef
      # Haskell
      ghc
      cabal2nix
      haskellPackages.pretty-show
      # Rust
      rustc
      cargo
      # Git
      git-lfs
      gitAndTools.gh
      gitAndTools.glab
      # Biscuit
      biscuit-cli
      steam-run
      # Media
      v4l-utils
      sox
      ffmpeg
      ffcast
      peek
      flameshot
      mediainfo
      yt-dlp
      davinci-resolve
      obs-studio
      darktable
      upscayl
      libwebp
      # Graphics
      dcraw
      drawpile
      graphicsmagick
      imagemagick
      perlPackages.ImageExifTool
      gimp
      inkscape
      libtiff
      # Graphs
      plantuml
      graphviz
      gnuplot
      dia
      # Data
      jq                      # json
      libxml2                 # xml
      xsv                     # csv
      hdf5                    # hdf5
      pup                     # html
      visidata                # spreadsheet
      # SQL
      schemaspy
      dbeaver-bin
      sqlite-interactive
      # GIS
      gdal
      proj
      qgis
      # Crypto
      mycrypto
      framesh
      # Android
      apktool
      # Wine
      wineWowPackages.stableFull
      winetricks
      # Proprietary (always fetch from master)
      pkgsMaster.skypeforlinux
      pkgsMaster.slack
      pkgsMaster.discord
      pkgsMaster.spotify
      pkgsMaster.zoom-us
      pkgsMaster.ledger-live-desktop
      pkgsMaster.googleearth-pro
    ];
  };
  programs = {
    home-manager.enable = true;
    chromium = {
      enable = true;
      extensions = [
        {
          # Vimium
          id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        }
        {
          # LastPass
          id = "hdokiejnpimakedhajhdlcegeplioahd";
        }
        {
          # React-Developer-Tools
          id = "fmkadmapgofadopljbjfkapdkoienihi";
        }
        {
          # ChatGPT Exporter
          id = "ilmdofdhpnhffldihboadndccenlnfll";
        }
        {
          # GitHub to Linear
          id = "hlambaminaoofejligodincejhcbljik";
        }
        {
          # SVG Navigator
          id = "pefngfjmidahdaahgehodmfodhhhofkl";
        }
      ];
    };
    polykey = {
      enable = true;
      passwordFilePath = "%h/.polykeypass";
      recoveryCodeOutPath = "%h/.polykeyrecovery";
    };
  };
}
