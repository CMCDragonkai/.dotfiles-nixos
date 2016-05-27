#!/usr/bin/env powershell

# Run this in Administrator Mode
# Works in Windows 10 and Up

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

# We need to first setup Windows before setting up Cygwin

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

# We must have this enabled before any of our package automation will work
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

# Change the default folder view options (this might require an explorer restart)
$FolderOptions = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $FolderKey Hidden 1                       # Show hidden files, folders and drives
Set-ItemProperty $FolderKey HideFileExt 0                  # Don't hide file extensions
Set-ItemProperty $FolderKey HideDrivesWithNoMedia 0        # Don't hide empty drives
Set-ItemProperty $FolderKey HideMergeConflicts 0           # Don't hide folder merge conflicts
Set-ItemProperty $FolderKey DontUsePowerShellOnWinX 0      # Replace CMD with Powershell on the start menu
Set-ItemProperty $FolderKey FolderContentsInfoTip 1        # Display file size information in folder tips 
Set-ItemProperty $FolderKey ShowSuperHidden 0              # Do hide protected OS files
Set-ItemProperty $FolderKey PersistBrowsers 1              # Remember opened explorer windows
Set-ItemProperty $FolderKey ShowEncryptCompressedColor 0   # Don't highlight files when compressed or encrypted
Set-ItemProperty $FolderKey AutoCheckSelect 1              # Enable checkboxes for selection
Set-ItemProperty $FolderKey LaunchTo 1                     # By default make folder explorer open to the PC
Set-ItemProperty $FolderKey NavPaneExpandToCurrentFolder 1 # Show the open folder on the nav panel
Set-ItemProperty $FolderKey NavPaneShowAllFolders 1        # Show all folders in nav panel
$FolderOptions = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'
Set-ItemProperty $FolderKey FullPath 1                     # Always show full path on the title bar

# Install Powershell Help Files (we can use -?)
Update-Help -Force

# Import Windows Package Management (a.k.a. OneGet)
Import-Module PackageManagement

# Install Package Providers
Install-PackageProvider -Name 'NuGet' -Force
Install-PackageProvider –Name 'Chocolatey' -Force
Install-PackageProvider -Name 'PowerShellGet' -Force

# Nuget doesn't register a package source by default
Register-PackageSource -Name 'nuget' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' 

# Acquire the Package Lists
$WindowsPackages = (Get-Content "./windows_packages.txt" | Where-Object { 
    $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
})

# Install the Windows Packages
foreach ($Package in $WindowsPackages) {

    $Package = $Package -split ','
    $Name = $Package[0].trim()
    $Version = $Package[1].trim()
    $Provider = $Package[2].trim()

    $InstallCommand = "Install-Package -Name '$Name' "

    if ($Version -and $Version -ne '*') {
        $InstallCommand += "-RequiredVersion '$Version' "
    }

    if ($Provider) {
        $InstallCommand += "-ProviderName '$Provider' "
    }

    $InstallCommand += "-Force"

    Invoke-Expression "$InstallCommand"
    
}

if ($ChocolateyPackages) {

    foreach ()

    Install-Package -Name 'carbon' -RequiredVersion '2.2.0' -ProviderName 'chocolatey' -Force

}

# Create the necessary directories

New-Item -ItemType Directory -Force -Path "$InstallationDirectory/cygwin64"
New-Item -ItemType Directory -Force -Path "$InstallationDirectory/cygwin64/packages"

# Acquire Package Lists

$MainPackages = (Get-Content "./cygwin_main_packages.txt" | Where-Object { 
    $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
}) -Join ','
$PortPackages = (Get-Content "./cygwin_port_packages.txt" | Where-Object { 
    $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
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



# Installing Windows Specific Applications
# This should be replaced with using Chocolatey...
# Depends if Cygwin and Cygwin packages can be managed with Chocolatey as well

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