{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
    oath-toolkit
    certbot
    pcsc-tools
    paperkey
    step-cli
    jose
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
    nixfmt
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
    mesa-demos
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
    aria2
    mailutils
    bind
    ldns
    kubo
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
    kdePackages.okular
    libreoffice
    zathura
    ghostscriptX
    poppler-utils
    pdftk
    pandoc
    pyhanko-cli
    # This is math/LaTeX + XeTeX + MetaPost + mainstream european languages 
    # and some standard fonts and recommended tools
    texlive.combined.scheme-small
    aspell
    aspellDicts.en
    monolith
    affine
    gcc
    scc
    cachix
    vim-full
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
    rust-analyzer
    # Git
    git-lfs
    gh
    glab
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
    freecad
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
    pkgsMaster.wechat
    pkgsMaster.telegram-desktop
    pkgsMaster.masterpdfeditor
  ];
}