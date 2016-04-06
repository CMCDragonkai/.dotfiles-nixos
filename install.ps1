#!/usr/bin/env powershell

param (
    [string]$MainMirror = "http://mirrors.kernel.org/sourceware/cygwin", 
    [string]$PortMirror = "ftp://ftp.cygwinports.org/pub/cygwinports", 
    [string]$PortKey = "http://cygwinports.org/ports.gpg", 
    [string]$InstallationDirectory = "$Env:UserProfile"
)

# Utility Functions

function Prepend-Idempotent {

    param (
        [string]$InputString, 
        [string]$OriginalString, 
        [string]$Delimiter = '', 
        [bool]$CaseSensitive = $False
    )

    if ($CaseSensitive -and ($OriginalString -cnotmatch $InputString)) {
        $InputString + $Delimiter + $OriginalString
    } elseif (! $CaseSensitive -and ($OriginalString -inotmatch $InputString)) {
        $InputString + $Delimiter + $OriginalString
    } else {
        $OriginalString
    }

}

# Create the necessary directories

New-Item -ItemType Directory -Force -Path "$InstallationDirectory/cygwin64"
New-Item -ItemType Directory -Force -Path "$InstallationDirectory/cygwin64/packages"

# Acquire Package Lists

$MainPackages = (Get-Content "./cygwin_main_packages.txt" | Where-Object { 
    $_.trim() -ne '' -or $_.trim() -notmatch '^#' 
}) -Join ','
$PortPackages = (Get-Content "./cygwin_port_packages.txt" | Where-Object { 
    $_.trim() -ne '' -or $_.trim() -notmatch '^#' 
}) -Join ','

# Main Packages

if ($MainPackages) {
    Start-Process -FilePath "./.bin/cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
        "
            --quiet-mode 
            --no-shortcuts 
            --no-startmenu 
            --no-desktop 
            --arch x86_64 
            --upgrade-also 
            --delete-orphans 
            --root `"$InstallationDirectory/cygwin64`" 
            --local-package-dir `"$InstallationDirectory/cygwin64/packages`" 
            --site `"$MainMirror`" 
            --packages `"$MainPackages`"
        "
}

# Cygwin Port Packages

if ($PortPackages) {
    Start-Process -FilePath "./.bin/cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
        "
            --quiet-mode 
            --no-shortcuts 
            --no-startmenu 
            --no-desktop 
            --arch x86_64 
            --upgrade-also 
            --delete-orphans 
            --root `"$InstallationDirectory/cygwin64`" 
            --local-package-dir `"$InstallationDirectory/cygwin64/packages`" 
            --site `"$PortMirror`" 
            --pubkey `"$PortKey`" 
            --packages `"$PortPackages`"
        "
}

# Setup some Windows Environment Variables and Configuration

[Environment]::SetEnvironmentVariable ("HOME", $Env:UserProfile, [System.EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable ("HOME", $Env:UserProfile, [System.EnvironmentVariableTarget]::Process)

# Make the `*.ps1` scripts executable without the `.ps1` extension
# By default Windows will have set `.COM;.EXE;.BAT;.CMD` as path extensions

[Environment]::SetEnvironmentVariable (
    "PATHEXT", 
    (Prepend-Idempotent ".PS1" $Env:PATHEXT ";" $False), 
    [System.EnvironmentVariableTarget]::System
)
[Environment]::SetEnvironmentVariable (
    "PATHEXT", 
    (Prepend-Idempotent ".PS1" $Env:PATHEXT ";" $False), 
    [System.EnvironmentVariableTarget]::Process
)
CMD /C 'assoc .ps1=Microsoft.PowerShellScript.1'
CMD /C 'ftype Microsoft.PowerShellScript.1="%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" "%1"'
Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Installing Windows Specific Applications

# ConEmu
& {
    Set Ver "alpha"; 
    Set Dst "$InstallationDirectory/ConEmu"
    Set Lnk $False 
    Set Run $False
    Set Xml './.ConEmu.xml'
    Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://conemu.github.io/install2.ps1'))
}

# Close the PowerShell, and Open ConEmu to Mintty and ZSH, while executing `./install.sh` from ZSH using Mintty
# Not sure it can work, Bash would use exec for such a purpose.
# It's simple, all you do is run `Start-Process` without `-Wait`, and then just close PowerShell using Exit
# But won't this destroy all the information about the installation? Perhaps we should not Exit directly.