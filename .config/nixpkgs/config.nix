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
                      bodil.file-browser
                      kahole.magit
                      octref.vetur
                      zxh404.vscode-proto3
                      redhat.vscode-yaml
                      matklad.rust-analyzer
                      tamasfe.even-better-toml
                      jock.svg
                    ]) ++ vscode-utils.extensionsFromVscodeMarketplace [
                      {
                        name = "copilot";
                        publisher = "GitHub";
                        version = "1.56.7152";
                        sha256 = "00v8q0w0wx0ddynjckaqy22rddp744z5d2a1sc2j7zsqqm6jyqgm";
                      }
                      {
                        name = "vspacecode";
                        publisher = "VSpaceCode";
                        version = "0.10.9";
                        sha256 = "01d43dcd5293nlp6vskdv85h0qr8xlq8j9vdzn0vjqr133c05anp";
                      }
                      {
                        name = "whichkey";
                        publisher = "VSpaceCode";
                        version = "0.11.3";
                        sha256 = "0zix87vl2rig8wn3f6f3n6zdi0c61za3lw7xgm28sjhwwb08wxiy";
                      }
                      {
                        name = "fuzzy-search";
                        publisher = "jacobdufault";
                        version = "0.0.3";
                        sha256 = "0hvg4ac4zdxmimfwab1lzqizgq8bjfq6rksc9n7953m9gk6m5pd0";
                      }
                      {
                        name = "vscode-typescript-next";
                        publisher = "ms-vscode";
                        version = "4.7.20220327";
                        sha256 = "1w4j48fwci5ylmvn4sc4l8c1h3q3xidhqb82zj6lk0ml5ag0zin7";
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
              gocode
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
            ];
          };
          media = buildEnv {
            name = "env-media";
            meta.priority = 10;
            paths = [
              v4l_utils
              sox
              ffmpeg
              ffcast
              peek
              flameshot
              python3Packages.youtube-dl
              mediainfo
              # olive-editor
              obs-studio
              darktable
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
              spotify
              zoom-us
              ledger-live-desktop
              googleearth-pro
            ];
          };
        };
      };
}
