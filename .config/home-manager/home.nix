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
      kdePackages.polkit-kde-agent-1
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
      affine
      gcc
      scc
      cachix
      vimHugeX
      patchelf
      dos2unix
      flyctl
      quickemu
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
      radicle-node
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
      # davinci-resolve
      obs-studio
      # darktable
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
      yed
      # Data
      jq                      # json
      libxml2                 # xml
      xan                     # csv
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
    brave = {
      enable = true;
    };
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        userSettings = {
          "vim.easymotion" = true;
          "vim.useSystemClipboard" = false;
          "vim.normalModeKeyBindingsNonRecursive" = [
            {
              before = [ "<space>" ];
              commands = [ "vspacecode.space" ];
            }
            {
              before = [ "," ];
              commands = [
                "vspacecode.space"
                { command = "whichkey.triggerKey"; args = "m"; }
              ];
            }
          ];
          "vim.visualModeKeyBindingsNonRecursive" = [
            {
              before = [ "<space>" ];
              commands = [ "vspacecode.space" ];
            }
            {
              before = [ "," ];
              commands = [
                "vspacecode.space"
                { command = "whichkey.triggerKey"; args = "m"; }
              ];
            }
          ];
          "editor.fontFamily" = "Fira Code, DejaVu Sans Mono, monospace";
          "editor.fontLigatures" = true;
          "editor.minimap.enabled" = false;
          "editor.lineNumbers" = "relative";
          "js/ts.implicitProjectConfig.experimentalDecorators" = true;
          "editor.fontSize" = 16;
          "explorer.confirmDragAndDrop" = false;
          "editor.renderWhitespace" = "all";
          "terminal.integrated.tabs.enabled" = true;
          "debug.javascript.autoAttachFilter" = "onlyWithFlag";
          "workbench.startupEditor" = "none";
          "telemetry.telemetryLevel" = "crash";
          "files.associations" = {
            ".env" = "dotenv";
            ".env*" = "dotenv";
            "string" = "cpp";
            "cstdint" = "cpp";
            "iostream" = "cpp";
            "cstdlib" = "cpp";
            "cstddef" = "cpp";
            "ranges" = "cpp";
            "flake.lock" = "json";
          };
          "redhat.telemetry.enabled" = false;
          "editor.inlineSuggest.enabled" = true;
          "editor.inlayHints.enabled" = "off";
          "explorer.confirmDelete" = false;
          "git.openRepositoryInParentFolders" = "never";
          "editor.tokenColorCustomizations" = {
            "[*Light*]" = {
              textMateRules = [
                {
                  scope = "ref.matchtext";
                  settings = { foreground = "#000"; };
                }
              ];
            };
            "[*Dark*]" = {
              textMateRules = [
                {
                  scope = "ref.matchtext";
                  settings = { foreground = "#fff"; };
                }
              ];
            };
            textMateRules = [
              {
                scope = "keyword.other.dotenv";
                settings = { foreground = "#FF000000"; };
              }
            ];
          };
          "editor.rulers" = [ 80 ];
          "dotenv.enableAutocloaking" = true;
          # vspacecode overrides
          "vspacecode.bindingOverrides" = [
            {
              keys = "a";
              name = "AI Commands";
              type = "bindings";
              bindings = [
                {
                  key = "l";
                  name = "Continue: Add Highlighted Code to Context";
                  type = "command";
                  command = "continue.focusContinueInput";
                }
                {
                  key = "L";
                  name = "Continue: Add Highlighted Code to Context (No Clear)";
                  type = "command";
                  command = "continue.focusContinueInputWithoutClear";
                }
                {
                  key = "i";
                  name = "Continue: Generate Code";
                  type = "command";
                  command = "continue.quickEdit";
                }
              ];
            }
          ];
          "continue.enableTabAutocomplete" = false;
          "continue.telemetryEnabled" = false;
          "continue.showInlineTip" = false;
          "yaml.schemas" = {
            "file:///home/cmcdragonkai/.vscode-oss/extensions/Continue.continue/config-yaml-schema.json" = [
              ".continue/**/*.yaml"
            ];
          };
        };
        keybindings = [
          {
            key = "space";
            command = "vspacecode.space";
            when = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
          }
          {
            key = "space";
            command = "vspacecode.space";
            when = "sideBarFocus && !inputFocus && !whichkeyActive";
          }
          # Vim / Magit tweaks
          {
            key = "tab";
            command = "extension.vim_tab";
            when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
          }
          {
            key = "tab";
            command = "-extension.vim_tab";
            when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
          }
          {
            key = "x";
            command = "magit.discard-at-point";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          { key = "k"; command = "-magit.discard-at-point"; }
          {
            key = "-";
            command = "magit.reverse-at-point";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          { key = "v"; command = "-magit.reverse-at-point"; }
          {
            key = "shift+-";
            command = "magit.reverting";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          { key = "shift+v"; command = "-magit.reverting"; }
          {
            key = "shift+o";
            command = "magit.resetting";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
          }
          { key = "shift+x"; command = "-magit.resetting"; }
          { key = "x"; command = "-magit.reset-mixed"; }
          { key = "ctrl+u x"; command = "-magit.reset-hard"; }
          { key = "y"; command = "-magit.show-refs"; }
          {
            key = "y";
            command = "vspacecode.showMagitRefMenu";
            when = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
          }
          # Quick open navigation
          { key = "ctrl+j"; command = "workbench.action.quickOpenSelectNext"; when = "inQuickOpen"; }
          { key = "ctrl+k"; command = "workbench.action.quickOpenSelectPrevious"; when = "inQuickOpen"; }
          # Suggestions widget
          {
            key = "ctrl+j"; command = "selectNextSuggestion";
            when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "ctrl+k"; command = "selectPrevSuggestion";
            when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          {
            key = "ctrl+l"; command = "acceptSelectedSuggestion";
            when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
          }
          # Parameter hints
          {
            key = "ctrl+j"; command = "showNextParameterHint";
            when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
          }
          {
            key = "ctrl+k"; command = "showPrevParameterHint";
            when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
          }
          # File browser (extension)
          { key = "ctrl+h"; command = "file-browser.stepOut"; when = "inFileBrowser"; }
          { key = "ctrl+l"; command = "file-browser.stepIn"; when = "inFileBrowser"; }
          # Code action menu
          { key = "ctrl+j"; command = "selectNextCodeAction"; when = "codeActionMenuVisible"; }
          { key = "ctrl+k"; command = "selectPrevCodeAction"; when = "codeActionMenuVisible"; }
          { key = "ctrl+l"; command = "acceptSelectedCodeAction"; when = "codeActionMenuVisible"; }
        ];
        extensions = (
          (with pkgs.vscode-extensions; [
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
          ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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

      };
    };
    polykey = {
      enable = true;
      passwordFilePath = "%h/.polykeypass";
      recoveryCodeOutPath = "%h/.polykeyrecovery";
    };
  };
}
