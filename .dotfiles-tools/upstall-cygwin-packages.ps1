#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [string]$MainMirror = "http://mirrors.kernel.org/sourceware/cygwin", 
    [string]$InstallationDirectory = "$Env:SystemDrive",
    [switch]$Force
)

# Create the necessary directories

New-Item -ItemType Directory -Force -Path "$InstallationDirectory\cygwin64" >$null
New-Item -ItemType Directory -Force -Path "$InstallationDirectory\cygwin64\packages" >$null

# Acquire Package Lists

$MainPackages = (Get-Content "${PSScriptRoot}\..\.dotfiles-config\cygwin_main_packages.txt" | Where-Object {
    $_.trim() -ne '' -and $_.trim() -notmatch '^#'
}) -Join ','

# Main Packages

if ($MainPackages) {

    if ($Force) {

        echo "Cleanly installing Main Packages"

        Start-Process -FilePath "${PSScriptRoot}\..\bin\cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
            "--quiet-mode",
            "--download",
            "--local-install",
            "--no-shortcuts",
            "--no-startmenu",
            "--no-desktop",
            "--arch x86_64",
            "--upgrade-also",
            "--delete-orphans",
            "--root `"${InstallationDirectory}\cygwin64`"",
            "--local-package-dir `"${InstallationDirectory}\cygwin64\packages`"",
            "--site `"$MainMirror`"",
            "--packages `"$MainPackages`""

    } else {

        echo "Installing Main Packages"

        Start-Process -FilePath "${PSScriptRoot}\..\bin\cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
            "--quiet-mode",
            "--download",
            "--local-install",
            "--no-shortcuts",
            "--no-startmenu",
            "--no-desktop",
            "--arch x86_64",
            "--upgrade-also",
            "--root `"${InstallationDirectory}\cygwin64`"",
            "--local-package-dir `"${InstallationDirectory}\cygwin64\packages`"",
            "--site `"$MainMirror`"",
            "--packages `"$MainPackages`""

    }

}
