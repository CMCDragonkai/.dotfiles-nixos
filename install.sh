#!/usr/bin/env bash

shopt -s extglob

script_path=$(dirname "$(readlink -f "$0")")

# Common configuration files to be processed by m4 and put into ~
common_profile=(
    "$script_path/modules" 
    "$script_path/profile/.aws" 
    "$script_path/profile/.gnupg" 
    "$script_path/profile/.jupyter" 
    "$script_path/profile/.ssh" 
    "$script_path/profile/.vim" 
    "$script_path/profile/bin" 
    "$script_path/profile/.bash_env.m4" 
    "$script_path/profile/.bash_profile.m4" 
    "$script_path/profile/.bashrc.m4" 
    "$script_path/profile/.curlrc" 
    "$script_path/profile/.ghci" 
    "$script_path/profile/.gitconfig" 
    "$script_path/profile/.gitignore_global" 
    "$script_path/profile/.inputrc" 
    "$script_path/profile/.my.cnf" 
    "$script_path/profile/.nanorc" 
    "$script_path/profile/.netrc" 
    "$script_path/profile/.sqliterc" 
    "$script_path/profile/.vimrc" 
    "$script_path/profile/.zlogin.m4" 
    "$script_path/profile/.zshenv.m4" 
    "$script_path/profile/.zshrc.m4" 
)

# Linux specific configuration files to be processed by m4 and put into ~
linux_profile=(
    "$script_path/profile/.local" 
    "$script_path/profile/.nixpkgs" 
    "$script_path/profile/.xmonad" 
    "$script_path/profile/.Xmodmap" 
    "$script_path/profile/.Xresources" 
    "$script_path/profile/.pam_environment.m4" 
    "$script_path/profile/.xprofile.m4"
)

# Cygwin specific configuration files to be processed by m4 and put into ~
cygwin_profile=(
    "$script_path/profile/AppData" 
    "$script_path/profile/Documents" 
    "$script_path/profile/.src" 
    "$script_path/profile/.cmd_profile" 
    "$script_path/profile/.minttyrc" 
)

mkdir --parents "$script_path/build"

# Clear the build directory
find "$script_path/build" -mindepth 1 -maxdepth 1 -exec rm --recursive --force '{}' \;

cp --target-directory="$script_path/build" --recursive --update "${common_profile[@]}"

if [[ "$(uname -s)" == Linux* ]]; then

    # Linux configuraiton files to be processed by m4 and put into ~
    cp --target-directory="$script_path/build" --recursive --update "${linux_profile[@]}"
    
    # Remove useless files
    
    # The only Linux I use is NIXOS
    system='NIXOS'
    
    wintmp=''
    winsystmp=''

    # On Linux, we assume timezone was already setup on OS installation
    tz="$(cat /etc/zoneinfo)"
    tzdir='/etc/zoneinfo'

elif [[ $(uname -s) == CYGWIN* ]]; then

    # Cygwin configuration files to be processed by m4 and put into ~
    cp --target-directory="$script_path/build" --recursive --update "${cygwin_profile[@]}"
    
    # Remove useless files
    rm "$script_path/build/.src/.gitkeep"
    
    system='CYGWIN'
    
    wintmp="$(cmd /c 'ECHO %TMP%' | tr --delete '[:space:]')"
    winsystmp="$(cmd /c 'ECHO %SYSTEMROOT%' | tr --delete '[:space:]')\Temp"

    # Merge Windows User Temporary with Cygwin /tmp
    cat <<'EOF' >/etc/fstab
# /etc/fstab

none /cygdrive cygdrive binary,posix=0,user 0 0
none /tmp usertemp binary,posix=0 0 0
EOF
    
    # Acquire timezone information from Windows
    tz="$("$script_path/profile/bin/tz-windows-to-iana" "$(tzutil /l | grep --before-context=1 "$(tzutil /g)" | head --lines=1)")"
    
    if [ -f /usr/share/zoneinfo/"$tz" ]; then
        echo "$tz" > /etc/timezone
        ln --symbolic --force /usr/share/zoneinfo/"$tz" /etc/localtime
        ln --symbolic --force /usr/share/zoneinfo /etc/zoneinfo
        tzdir="/usr/share/zoneinfo"
    else 
        echo "Unable to acquire IANA timezone information, update the timezone matching script, or do it manually."
    fi

    # Change default shell to zsh
    # On Linux we could use chsh --shell
    cat <<'EOF' >/etc/nsswitch.conf
# /etc/nsswitch.conf

passwd: files db
group: files db
db_enum: cache builtin
db_home: windows
db_shell: /bin/zsh
db_gecos: windows
EOF
    
    # Setting up Cygserver requires first deleting the cygserver.conf
    # The service will be setup 
    rm --force /etc/cygserver.conf
    cygrunsrv --remove='cygserver' || true
    echo "yes" | cygserver-config
    cygrunsrv --start='cygserver'

    # Symlinking locale.h to xlocale.h (extended locale)
    # Note that xlocale.h is an Apple provided wrapper around locale.h
    # Cygwin obviously does not distribute such a header
    # Some libraries like numpy may expect xlocale.h, but we can just point them to the existing locale.h
    ln --symbolic /usr/include/locale.h /usr/include/xlocale.h
    
fi

# Note that `PH_` is our namespace meaning "PolyHack"
while IFS= read -r -d '' filepath; do 
    
    # Process to the filepath without the .m4 extension
    m4 \
    --include="$script_path/profile/includes" \
    --define=PH_SYSTEM="$system" \
    --define=PH_TZ="$tz" \
    --define=PH_TZDIR="$tzdir" \
    --define=PH_WINTMP="$wintmp" \
    --define=PH_WINSYSTMP="$winsystmp" \
    "$filepath" > "${filepath%.*}"

    # Remove the m4 template
    rm "$filepath"

done < <(find "$script_path/build" -name '*.m4' -not -path "$script_path/build/modules/*" -print0)

# Copy files from build into ~
cp --archive --update "$script_path/build/." "${HOME}/"

# Make ~/.ssh directory and subdirectories 700, but the files 600
# This requires wiping out any execute permissions first
chmod --recursive a-x ~/.ssh
chmod --recursive u=rwX,g=,o= ~/.ssh

# We can only perform installations after the profile is copied over
if [[ $(uname -s) == CYGWIN* ]]; then

    # Using python setuptools install both pip2 and pip3
    for e in /usr/bin/easy_install-*; do
        eval "$e pip"
    done

    # Install Python packages on Cygwin
    # Executables should be preferably Python 3, and will be installed in ~/.local/bin
    pip2 install --requirement "$script_path/pip2_requirements.txt"
    pip3 install --requirement "$script_path/pip3_requirements.txt"
    
    # Install via the source installation scripts
    # All of these are Makefiles with install and uninstall targets
    for dir in "$script_path"/source_installation_scripts/*/; do
        make --directory="$dir" install
    done

    # Finally since the zip package is not a git repository, we shall clone the repository to HOME directory
    rm --recursive --force "$HOME/.dotfiles"
    git clone --recursive https://github.com/CMCDragonkai/.dotfiles.git "$HOME"

fi
