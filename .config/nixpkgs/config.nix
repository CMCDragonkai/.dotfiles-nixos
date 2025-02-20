{
  allowUnfree = true;
  pulseaudio = true;
  chromium = {
    pulseSupport = true;
  };
  permittedInsecurePackages = [
    "dcraw-9.28.0"
    "googleearth-pro-7.3.4.8248"
    "qtwebkit-5.212.0-alpha4"
  ];
  packageOverrides = pkgs:
    with pkgs;
    let
      pkgsMaster = import
        (
          builtins.fetchTarball
          https://github.com/NixOS/nixpkgs/archive/master.tar.gz
        ) {};
    in
      {
        # all qt applications have to be part of the same buildEnv
        # they rely on shared libraries that is shared across all packages
        # default priority is 5, we set these to be lower priority
        # and when there's a conflict, increment by 10
        env = {
          base = buildEnv {
            name = "env-base";
            meta.priority = 10;
            paths = [
              # Web
              firefox
              chromium
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
              rmlint
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
              gnome3.adwaita-icon-theme
              gnome3.nautilus
              dconf
              rlwrap
              trash-cli
              inotify-tools
              expect
              libcgroup
              criu
              appimage-run
              # Security
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
              lzma
              dpkg
              rpmextract
              unetbootin
              # Nix
              nix-prefetch-scripts
              nix-index
              nix-bundle
              nix-diff
              # X Window and XMonad
              xdg_utils
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
            ];
          };
          network = buildEnv {
            name = "env-network";
            meta.priority = 10;
            paths = [
              (lib.lowPrio inetutils)
              iputils
              mitmproxy
              nssTools
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
            ];
          };
          devices = buildEnv {
            name = "env-devices";
            meta.priority = 20;
            paths = [
              libmtp
              gmtp
              gqrx
            ];
          };
          fonts = buildEnv {
            name = "env-fonts";
            meta.priority = 10;
            paths = [
              fira
              fira-mono
              fira-code
              corefonts
            ];
          };
          documents = buildEnv {
            name = "env-documents";
            meta.priority = 10;
            paths = [
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
            ];
          };
          development = buildEnv {
            name = "env-development";
            meta.priority = 20;
            paths = [
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
                      octref.vetur
                      zxh404.vscode-proto3
                      redhat.vscode-yaml
                      rust-lang.rust-analyzer
                      tamasfe.even-better-toml
                      jock.svg
                      arrterian.nix-env-selector
                      bradlc.vscode-tailwindcss
                      vspacecode.vspacecode
                      vspacecode.whichkey
                      bodil.file-browser
                      dotenv.dotenv-vscode
                      unifiedjs.vscode-mdx
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
              python3Packages.binwalk-full
              python3Packages.pygments
              man-pages
              posix_man_pages
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
            ];
          };
          media = buildEnv {
            name = "env-media";
            meta.priority = 10;
            paths = [
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
              mkchromecast
            ];
          };
          graphics = buildEnv {
            name = "env-graphics";
            meta.priority = 10;
            paths = [
              dcraw
              drawpile
              graphicsmagick
              imagemagick
              perlPackages.ImageExifTool
              gimp
              inkscape
              libtiff
            ];
          };
          graphs = buildEnv {
            name = "env-graphs";
            meta.priority = 10;
            paths = [
              plantuml
              graphviz
              gnuplot
              dia
            ];
          };
          data = buildEnv {
            name = "env-data";
            meta.priority = 10;
            paths = [
              jq                      # json
              libxml2                 # xml
              xsv                     # csv
              hdf5                    # hdf5
              hdfview
              pup                     # html
              visidata                # spreadsheet
            ];
          };
          sql = buildEnv {
            name = "env-sql";
            meta.priority = 10;
            paths = [
              schemaspy
              dbeaver
              sqlite-interactive
            ];
          };
          gis = buildEnv {
            name = "env-gis";
            meta.priority = 20;
            paths = [
              gdal
              proj
              qgis
            ];
          };
          crypto = buildEnv {
            name = "env-crypto";
            meta.priority = 30;
            paths = [
              mycrypto
              bisq-desktop
              framesh
            ];
          };
          android = buildEnv {
            name = "env-android";
            meta.priority = 10;
            paths = [
              apktool
              python3Packages.gplaycli
            ];
          };
          wine = buildEnv {
            name = "env-wine";
            meta.priority = 10;
            paths = [
              wineWowPackages.stableFull
              winetricks
            ];
          };
          # proprietary applications tend to expire quickly
          # so we need to follow master for these
          proprietary = with pkgsMaster; buildEnv {
            name = "env-proprietary";
            meta.priority = 20;
            paths = [
              masterpdfeditor
              skypeforlinux
              slack
              discord
              spotify
              zoom-us
              ledger-live-desktop
              googleearth-pro
            ];
          };
        };
      };
}
