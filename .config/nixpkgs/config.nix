{
  allowUnfree = true;
  pulseaudio = true;
  chromium = {
    pulseSupport = true;
    enableNaCl = true;
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
        env = {
          base = buildEnv {
            name = "env-base";
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
              iptraf
              nethogs
              iotop
              sysstat
              powertop
              stress-ng
              fio
              conky
              bench
              hyperfine
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
              # Security
              plasma5.polkit-kde-agent
              oathToolkit
              certbot
              keepass
              keybase-gui
              pcsctools
              paperkey
              # Archive Management
              zip
              unzip
              gzip
              bzip2
              unrar
              lzma
              dpkg
              rpmextract
              # Network
              mitmproxy
              openssl
              putty
              wget
              httpie
              aria
              mailutils
              bind
              ldns
              ipfs
              nodePackages_8_x.dat
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
              openvpn
              autossh
              # Storage
              filezilla
              samba4
              netatalk
              awscli
              unetbootin
              # Nix
              nix-prefetch-scripts
              nix-index
              nix-bundle
              vulnix
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
              xdotool
              xclip
              xrectsel
              hsetroot
              haskellPackages.xmobar
              feh
              autorandr
              # Media
              pavucontrol
              kdeApplications.spectacle
              playerctl
              v4l_utils
              vlc
              ffmpeg
              obs-studio
              sox
              mplayer
              beets
              ffcast
              peek
              mediainfo
              python36Packages.youtube-dl
              # Radio
              gnuradio-with-packages
              gqrx
            ];
          };
          fonts = buildEnv {
            name = "env-fonts";
            paths = [
              fira
              fira-mono
              fira-code
              corefonts
            ];
          };
          documents = buildEnv {
            name = "env-documents";
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
            paths = [
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
              haskellPackages.pretty-show
              haskellPackages.stylish-haskell
              haskellPackages.brittany
              haskellPackages.hlint
            ];
          };
          graphics = buildEnv {
            name = "env-graphics";
            paths = [
              dcraw
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
            paths = [
              plantuml
              graphviz
              gnuplot
              dia
            ];
          };
          data = buildEnv {
            name = "env-data";
            paths = [
              jq                      # json
              libxml2                 # xml
              python36Packages.csvkit # csv
              hdf5                    # hdf5
              hdfview
              go-pup                  # html
              visidata                # spreadsheet
            ];
          };
          sql = buildEnv {
            name = "env-sql";
            paths = [
              schemaspy
              dbeaver
              sqlite-interactive
              sqlite3_analyzer
            ];
          };
          gis = buildEnv {
            name = "env-gis";
            paths = [
              gdal
              proj
              qgis
            ];
          };
          crypto = buildEnv {
            name = "env-crypto";
            paths = [
              electrum
            ];
          };
          gaming = buildEnv {
            name = "env-gaming";
            paths = [
              steam
            ];
          };
          android = buildEnv {
            name = "env-android";
            paths = [
              libmtp
              go-mtpfs
              apktool
              python36Packages.gplaycli
            ];
          };
          # proprietary applications tend to expire quickly
          # so we need to follow master for these
          proprietary = with pkgsMaster; buildEnv {
            name = "env-proprietary";
            paths = [
              masterpdfeditor
              skype
              slack
              spotify
            ];
          };
        };
      };
}
