#!/usr/bin/env powershell

# Run this in Administrator Mode PowerShell
# `powershell -ExecutionPolicy Unrestricted ./install.ps1`
# Works in Windows 10 and Up

param (
    [string]$MainMirror = "http://mirrors.kernel.org/sourceware/cygwin", 
    [string]$PortMirror = "ftp://ftp.cygwinports.org/pub/cygwinports", 
    [string]$PortKey = "http://cygwinports.org/ports.gpg", 
    [string]$InstallationDirectory = "$Env:UserProfile", 
    [int]$Stage = 0
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

function Get-ScriptPath {
    Split-Path $Script:MyInvocation.MyCommand.Path
}

function ScheduleRebootTask {

    param (
        [string]$Name
        [int]$Stage
    )

    # this needs to be changed to schedule the task to powershell.exe
    # to run the -File (Get-ScriptPath)

    $Action = New-ScheduledTaskAction -Execute (Get-ScriptPath) -Argument (
            "-MainMirror ${MainMirror} " + 
            "-PortMirror ${PortMirror} " + 
            "-PortKey ${PortKey} " + 
            "-InstallationDirectory ${InstallationDirectory}" + 
            "-Stage ${Stage}"
        )

    $Trigger = New-ScheduledTaskTrigger -AtLogOn
    
    $Principal = New-ScheduledTaskPrincipal `
        -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) `
        -LogonType Interactive `
        -RunLevel Highest
    
    $Settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -RunOnlyIfNetworkAvailable `
        -DontStopOnIdleEnd `
        -StartWhenAvailable

    Register-ScheduledTask `
        -TaskName "$Name $Stage" `
        -TaskPath "\" `
        -Action $Action `
        -Trigger $Trigger `
        -Principal $Principal `
        -Settings $Settings `
        -Force

    Restart-Computer

}

# We need to first setup Windows before setting up Cygwin (requiring a reboot)
# We need to make sure the reboot results in a powershell terminal still running (upon logon)
# Switch to using Powershell Terminal Directly
if ($Stage -eq 0) {

    Write-Host "Before you continue the installation, you should switch on NTFS compression on your drive"
    Read-Host "Press any Key to Continue"

    # Allow Powershell scripts to be executable
    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

    # Install Powershell Help Files (we can use -?)
    Update-Help -Force

    # Import the registry file
    Start-Process $Env:windir\regedit.exe import "./windows_registry.reg"

    # Setup some Windows Environment Variables and Configuration

    # Home environment variables
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

    # Setup firewall to accept pings for Domain and Private networks but not from Public networks
    Set-NetFirewallRule `
        -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" `
        -Enabled True `
        -Action "Allow" `
        -Profile "Domain,Private"

    Set-NetFirewallRule `
        -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" `
        -Enabled True `
        -Action "Allow" `
        -Profile "Domain,Private"

    # Setup firewall to accept connections from 55555 in Domain and Private networks
    Remove-NetFirewallRule -DisplayName "Polyhack - Private Development Port (TCP-In)" -ErrorAction SilentlyContinue
    Remove-NetFirewallRule -DisplayName "Polyhack - Private Development Port (UDP-In)" -ErrorAction SilentlyContinue
    New-NetFirewallRule `
        -DisplayName "Private Development Port (TCP-In)" `
        -Direction Inbound `
        -EdgeTraversalPolicy Allow `
        -Protocol TCP `
        -LocalPort 55555 `
        -Action Allow `
        -Profile "Domain,Private" `
        -Enabled True
    New-NetFirewallRule `
        -DisplayName "Private Development Port (UDP-In)" `
        -Direction Inbound `
        -EdgeTraversalPolicy Allow `
        -Protocol UDP `
        -LocalPort 55555 `
        -Action Allow `
        -Profile "Domain,Private" `
        -Enabled True

    # Port 22 for Cygwin SSH
    Remove-NetFirewallRule -DisplayName "Polyhack - SSH (TCP-In)" -ErrorAction SilentlyContinue
    New-NetFirewallRule `
        -DisplayName "Polyhack - SSH (TCP-In)" `
        -Direction Inbound `
        -EdgeTraversalPolicy Allow `
        -Protocol TCP `
        -LocalPort 22 `
        -Action Allow `
        -Profile "Domain,Private" `
        -Program "${InstallationDirectory}\cygwin64\usr\sbin\sshd.exe" `
        -Enabled True

    # Port 80 for HTTP, but blocked by default (switch it on when you need to)
    Remove-NetFirewallRule -DisplayName "Polyhack - HTTP (TCP-In)" -ErrorAction SilentlyContinue
    New-NetFirewallRule `
        -DisplayName "Polyhack - HTTP (TCP-In)" `
        -Direction Inbound `
        -EdgeTraversalPolicy Allow `
        -Protocol TCP `
        -LocalPort 80 `
        -Action Block `
        -Enabled True

    # Reboot
    ScheduleRebootTask -Name "Dotfiles - " -Stage 1

} elseif ($Stage -eq 1) {

    Unregister-ScheduledTask -TaskName "Dotfiles - 1" -TaskPath "\" -Confirm:$false

    # Stop the Windows Native SSH Service due to Developer Tools
    Stop-Service -Name "SshBroker" -Force -Confirm:$false -ErrorAction SilentlyContinue
    # Disable both SSH service and the SSH proxy
    Set-Service -Name "SshProxy" -Status Stopped -StartupType Disabled -Confirm:$false -ErrorAction SilentlyContinue
    Set-Service -Name "SshBroker" -Status Stopped -StartupType Disabled -Confirm:$false -ErrorAction SilentlyContinue

    # Import Windows Package Management (a.k.a. OneGet)
    Import-Module PackageManagement

    # Install Package Providers
    Install-PackageProvider -Name 'NuGet' -Force
    Install-PackageProvider –Name 'Chocolatey' -Force
    Install-PackageProvider -Name 'ChocolateyGet' -Force
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

    # Installing Cygwin Packages

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

    # Schedule a final reboot to start the Cygwin setup process
    ScheduleRebootTask -Name "Dotfiles - " -Stage 2

} elseif ($Stage -eq 2) {

    Unregister-ScheduledTask -TaskName "Dotfiles - 2" -TaskPath "\" -Confirm:$false

    # Run the Cygwin process
    # Open ConEmu to Mintty and ZSH
    # Execute `./install.sh` from ZSH
    # Use Start-Process without -Wait
    # or don't exit immediately so you can watch stuff..

}