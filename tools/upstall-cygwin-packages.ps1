#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [string]$MainMirror = "http://mirrors.kernel.org/sourceware/cygwin", 
    [string]$PortMirror = "ftp://ftp.cygwinports.org/pub/cygwinports", 
    [string]$PortKey = "http://cygwinports.org/ports.gpg", 
    [string]$InstallationDirectory = "$Env:UserProfile"
)

# Create the necessary directories

New-Item -ItemType Directory -Force -Path "$InstallationDirectory\cygwin64" >$null
New-Item -ItemType Directory -Force -Path "$InstallationDirectory\cygwin64\packages" >$null

# Acquire Package Lists

$MainPackages = (Get-Content "${PSScriptRoot}\..\cygwin_main_packages.txt" | Where-Object { 
    $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
}) -Join ','
$PortPackages = (Get-Content "${PSScriptRoot}\..\cygwin_port_packages.txt" | Where-Object { 
    $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
}) -Join ','

# Main Packages

if ($MainPackages) {
    Start-Process -FilePath "${PSScriptRoot}\..\profile\bin\cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
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
}

# Cygwin Port Packages (make sure not to --delete-orphans) or else it will wipeout the original packages

if ($PortPackages) {
    Start-Process -FilePath "${PSScriptRoot}\..\profile\bin\cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
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
        "--site `"$PortMirror`"",
        "--pubkey `"$PortKey`"",
        "--packages `"$PortPackages`""
}