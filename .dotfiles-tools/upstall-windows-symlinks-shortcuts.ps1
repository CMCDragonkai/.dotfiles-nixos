#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# Directory to hold NTFS symlinks and Windows shortcuts to Windows executables installed in the local profile
# This means ~/Users/AppData/Local/bin
# The roaming profile should not be used for application installation because applications are architecture specific
New-Item -ItemType Directory -Force -Path "${Env:LOCALAPPDATA}\bin" >$null

# Directory to hold NTFS symlinks and Windows shortcuts to Windows executables installed globally
# This means C:/ProgramData/bin
# This can be used for applications we install ourselves and for native installers in Chocolatey
# Native installers are those that are not "*.portable" installations
New-Item -ItemType Directory -Force -Path "${Env:ALLUSERSPROFILE}\bin" >$null

# Chrome App shortcuts will be places in $LOCALAPPDATA/bin because the icons are supplied in the LOCALAPPDATA
$ChromePath = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe" -ErrorAction SilentlyContinue).'(Default)'

if ($ChromePath) {

    $WshShell = New-Object -ComObject WScript.Shell

    $ChromeApps = (Get-Content "${PSScriptRoot}\..\.dotfiles-config\chrome_apps.txt" | Where-Object {
        $_.trim() -ne '' -and $_.trim() -notmatch '^#'
    })

    foreach ($App in $ChromeApps) {

        $App = $App -split ','
        $Name = $App[0].trim()
        $Url = [System.Uri]"$($App[1].trim())"

        try {

            New-Item -ItemType Directory -Force -Path "${Env:LOCALAPPDATA}\Google\Chrome\User Data\Default\Web Applications\$($Url.Host)\$($Url.Scheme)_80" >$null
            Copy-Item -Force "${PSScriptRoot}\..\.dotfiles-data\${Name}.ico" "${Env:LOCALAPPDATA}\Google\Chrome\User Data\Default\Web Applications\$($Url.Host)\$($Url.Scheme)_80\${Name}.ico"
            Unblock-File -Path "${Env:LOCALAPPDATA}\Google\Chrome\User Data\Default\Web Applications\$($Url.Host)\$($Url.Scheme)_80\${Name}.ico"
            $Shortcut = $WshShell.CreateShortcut("${Env:LOCALAPPDATA}\bin\${Name}.lnk")
            $Shortcut.TargetPath = "$ChromePath"
            $Shortcut.Arguments = "--app=$($Url.OriginalString)"
            $Shortcut.WorkingDirectory = "$(Split-Path "$ChromePath" -Parent)"
            $ShortCut.IconLocation = "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Web Applications\$($Url.Host)\$($Url.Scheme)_80\${Name}.ico"
            $Shortcut.Save()

        } catch {

            echo "Could not create Chrome App shortcut for ${Url.OriginalString} because ${_}"

        }

    }

} else {

    echo "Could not find path to chrome.exe, therefore could not setup Chrome app shortcuts"

}

# Setup any NTFS symlinks required for natively and globally installed applications
# These will be installed into $ALLUSERSPROFILE\bin
# This is only required if the installation process did not add a launcher into $ChocolateyInstall\bin
$GlobalSymlinkMapping = (Get-Content "${PSScriptRoot}\..\.dotfiles-config\windows_global_symlink_mapping.txt" | Where-Object {
    $_.trim() -ne '' -and $_.trim() -notmatch '^#'
})

foreach ($Map in $GlobalSymlinkMapping) {

    $Map = $Map -split ','
    $Link = $Map[0].trim()
    $Target = $Map[1].trim()

    # expand MSDOS environment variables
    $Target = [System.Environment]::ExpandEnvironmentVariables("$Target")
    if (Test-Path "$Target" -PathType Leaf) {
        New-Item -ItemType SymbolicLink -Force -Path "${Env:ALLUSERSPROFILE}\bin\${Link}" -Value "$Target" >$null
    } else {
        echo "Symbolic link target could not be found: ${Target}"
    }

}

# Setup any NTFS symlinks required for locally installed applications
# These will be installed into $LOCALAPPDATA\bin
$LocalSymlinkMapping = (Get-Content "${PSScriptRoot}\..\.dotfiles-config\windows_local_symlink_mapping.txt" | Where-Object {
    $_.trim() -ne '' -and $_.trim() -notmatch '^#'
})

foreach ($Map in $LocalSymlinkMapping) {

    $Map = $Map -split ','
    $Link = $Map[0].trim()
    $Target = $Map[1].trim()

    # expand MSDOS environment variables
    $Target = [System.Environment]::ExpandEnvironmentVariables("$Target")
    if (Test-Path "$Target" -PathType Leaf) {
        New-Item -ItemType SymbolicLink -Force -Path "${Env:LOCALAPPDATA}\bin\${Link}" -Value "$Target" >$null
    } else {
        echo "Symbolic link target could not be found: ${Target}"
    }

}
