{
  allowUnfree = true;
  pulseaudio = true;
  chromium = {
    pulseSupport = true;
  };
  permittedInsecurePackages = [
    "dcraw-9.28.0"
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
              (
                vscode-with-extensions.override {
                  vscodeExtensions = (
                    (with vscode-extensions; [
                      vscodevim.vim
                      jnoortheen.nix-ide
                      ms-python.python
                      ms-vscode.cpptools
                      haskell.haskell
                      golang.Go
                    ]) ++ vscode-utils.extensionsFromVscodeMarketplace [
                      {
                        name = "nix-env-selector";
                        publisher = "arrterian";
                        version = "1.0.6";
                        sha256 = "19k60nrhimwf61ybnn1qqb0n0zh2wdr8pp1x5bla9r76hz5srqdl";
                      }
                      {
                        name = "vspacecode";
                        publisher = "VSpaceCode";
                        version = "0.9.0";
                        sha256 = "1rhn5avb4icw3930n5bn9qqm7xrpasm87lv2is2k72ks3nxmhsid";
                      }
                      {
                        name = "whichkey";
                        publisher = "VSpaceCode";
                        version = "0.8.4";
                        sha256 = "0bhx3r08rw9b9gw5pmhyi1g8cb1bb2xmhwg4vpikfkbrs8a30bvi";
                      }
                      {
                        name = "EditorConfig";
                        publisher = "EditorConfig";
                        version = "0.16.4";
                        sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
                      }
                      {
                        name = "file-browser";
                        publisher = "bodil";
                        version = "0.2.10";
                        sha256 = "1gw46sq49nm85i0mnbrlnl0fg09qi72fqsl46wgd16zf86djyvj5";
                      }
                      {
                        name = "fuzzy-search";
                        publisher = "jacobdufault";
                        version = "0.0.3";
                        sha256 = "0hvg4ac4zdxmimfwab1lzqizgq8bjfq6rksc9n7953m9gk6m5pd0";
                      }
                      {
                        name = "magit";
                        publisher = "kahole";
                        version = "0.6.6";
                        sha256 = "0gimkq3jihdikh2bdk9ljv7hc4rn92zsshf5awykd8pa0la8gxsh";
                      }
                      {
                        name = "vetur";
                        publisher = "octref";
                        version = "0.33.1";
                        sha256 = "1iq2h87j7dr4vf9zgzihd5q4d95grc0iirz68az5dnvy19nvfv57";
                      }
                      {
                        name = "vscode-typescript-next";
                        publisher = "ms-vscode";
                        version = "4.3.20210317";
                        sha256 = "0rc2pxj2x0afygbz2l8dbmhm9lgc4xz54crf1plnmiip78rnmz9g";
                      }
                      {
                        name = "vscode-proto3";
                        publisher = "zxh404";
                        version = "0.5.3";
                        sha256 = "1piih7q2fp81hh356h10xi0v0xvicc9698yp9hj7c08xws3s4i51";
                      }
                    ]
                  );
                }
              )
              gcc
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
              teams
            ];
          };
        };
      };
}
