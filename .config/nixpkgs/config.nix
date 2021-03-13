{
  allowUnfree = true;
  pulseaudio = true;
  chromium = {
    pulseSupport = true;
  };
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
              ag
              dex
              dunst
              libnotify
              hicolor_icon_theme
              gnome3.adwaita-icon-theme
              gnome3.nautilus
              gnome3.dconf
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
              keybase-gui
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
              # Chat
              weechat
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
              (lib.lowPrio nmap-graphical)
              ncat
              socat
              hans
              iodine
              udptunnel
              httptunnel
              pwnat
              sslh
              geoipWithDatabase
              iperf
              conntrack_tools
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
              gnuradio-with-packages
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
              gcc
              cachix
              emacs
              vimHugeX
              tmux
              patchelf
              dos2unix
              qemu
              #libguestfs
              shellcheck
              universal-ctags
              global
              python3Packages.binwalk-full
              python3Packages.pygments
              man-pages
              posix_man_pages
              libcap_manpages
              valgrind
              gdb
              lldb
              rr
              docker_compose
              runc
              ipmitool
              ipmiutil
              kubectl
              aws-iam-authenticator
              # R
              R
              # Rust
              rustracer
              # Python
              (
                with python3Packages;
                python.buildEnv.override {
                  extraLibs = [
                    setuptools
                    jedi
                    flake8
                    isort
                  ];
                }
              )
              autoflake
              # Node
              nodejs
              nodePackages.tern
              nodePackages.node2nix
              nodePackages.typescript
              nodePackages.prettier
              nodePackages.eslint
              # Go
              go
              gocode
              godef
              # Haskell
              ghc
              cabal2nix
              haskellPackages.pretty-show
              haskellPackages.stylish-haskell
              haskellPackages.brittany
              haskellPackages.hlint
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
              olive-editor
              obs-studio
              obs-v4l2sink
              darktable
            ];
          };
          graphics = buildEnv {
            name = "env-graphics";
            meta.priority = 10;
            paths = [
              #dcraw
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
              go-pup                  # html
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
              electrum
              ledger-live-desktop
            ];
          };
          gaming = buildEnv {
            name = "env-gaming";
            meta.priority = 10;
            paths = [
              steam
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
          # proprietary applications tend to expire quickly
          # so we need to follow master for these
          proprietary = with pkgsMaster; buildEnv {
            name = "env-proprietary";
            meta.priority = 20;
            paths = [
              masterpdfeditor
              skype
              slack
              spotify
              zoom-us
              googleearth
            ];
          };
        };
      };
}
