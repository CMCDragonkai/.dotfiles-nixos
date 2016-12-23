#!/usr/bin/env powershell

#Requires -RunAsAdministrator

# Run this like: `powershell -ExecutionPolicy Unrestricted ./install.ps1`
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

function Append-Idempotent {

    param (
        [string]$InputString, 
        [string]$OriginalString, 
        [string]$Delimiter = '', 
        [bool]$CaseSensitive = $False
    )
    
    if ($CaseSensitive -and ($OriginalString -cnotmatch $InputString)) {
        $OriginalString + $Delimiter + $InputString
    } elseif (! $CaseSensitive -and ($OriginalString -inotmatch $InputString)) {
        $OriginalString + $Delimiter + $InputString
    } else {
        $OriginalString
    }

}

function ScheduleRebootTask {

    param (
        [string]$Name,
        [int]$Stage
    )
    
    # ScheduledTasks action syntax is similar to the syntax used for run.exe commands
    # For some reason the normal -File option of powershell.exe doesn't work in run.exe and hence also doesn't work in the task scheduler
    # So we use an alternative syntax to execute the script
    $Action = New-ScheduledTaskAction -Execute 'powershell.exe' -WorkingDirectory "$($PWD.Path)" -Argument (
        '-NoLogo -NoProfile -ExecutionPolicy Unrestricted -NoExit ' + 
        "`"& '${PSCommandPath}' -MainMirror '${MainMirror}' -PortMirror '${PortMirror}' -PortKey '${PortKey}' -InstallationDirectory '${InstallationDirectory}' -Stage ${Stage}`""
    )

    # Trigger the script only when the current user has logged on
    $Trigger = New-ScheduledTaskTrigger -AtLogOn -User "$([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)"
    
    # -RunLevel Highest will run the job with administrator privileges
    $Principal = New-ScheduledTaskPrincipal `
        -UserId "$([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)" `
        -LogonType Interactive `
        -RunLevel Highest
    
    $Settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -RunOnlyIfNetworkAvailable `
        -DontStopOnIdleEnd `
        -StartWhenAvailable

    Register-ScheduledTask `
        -TaskName "$Name$Stage" `
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
    
    # Copy the transparent.ico icon
    Copy-Item "${PSScriptRoot}\data\transparent.ico" "${env:SYSTEMROOT}\system32"
    Unblock-File -Path "${env:SYSTEMROOT}\system32\transparent.ico"

    # Install Powershell Help Files (we can use -?)
    Update-Help -Force

    # Import the registry file
    Start-Process -FilePath "$Env:windir\regedit.exe" -Wait -Verb RunAs -ArgumentList "import '${PSScriptRoot}\windows_registry.reg'"
    
    # Enabling Optional Windows Features, these may need a restart
    # Also we're piping the Get-* first, as these features may not be available on certain editions of Windows
    
    # Enable Telnet
    Get-WindowsOptionalFeature -Online -FeatureName TelnetClient | Enable-WindowsOptionalFeature -Online -All -NoRestart
    # Enable Windows Containers
    Get-WindowsOptionalFeature -Online -FeatureName Containers | Enable-WindowsOptionalFeature -Online -All -NoRestart
    # Enable Hyper-V hypervisor, this will prevent Virtualbox from running concurrently
    # However Hyper-V can be disabled at boot for when you need to use virtualbox
    # This is needed for Docker on Windows to run
    Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V | Enable-WindowsOptionalFeature -Online -All -NoRestart

    # Setup some Windows Environment Variables and Configuration
    
    # System variables
   
    # Make the `*.ps1` scripts executable without the `.ps1` extension
    # By default Windows will have set `.COM;.EXE;.BAT;.CMD` as path extensions
    [Environment]::SetEnvironmentVariable (
        "PATHEXT", 
        (Append-Idempotent ".PS1" $Env:PATHEXT ";" $False), 
        [System.EnvironmentVariableTarget]::Machine
    )
    [Environment]::SetEnvironmentVariable (
        "PATHEXT", 
        (Append-Idempotent ".PS1" $Env:PATHEXT ";" $False), 
        [System.EnvironmentVariableTarget]::Process
    )
    CMD /C 'assoc .ps1=Microsoft.PowerShellScript.1'
    CMD /C 'ftype Microsoft.PowerShellScript.1="%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" "%1"'
    
    # Directory to hold symlinks to Windows executables that is installed across users
    # This can be used for applications we install ourselves and for native installers in Chocolatey
    # It is however possible that native installers may pollute the PATH themselves
    # This is something to watch out for, always check out the environment variables in your control panel
    # Note that natively installed applications will need to be uninstalled via native uninstallers
    # Metadata can be cleaned by uninstalling them from Chocolatey if they were installed via Chocolatey
    # And of course any symlinks to the binaries that are placed within here
    # Note that you must use NTFS symlinks here or use CMD shims, not cygwin symlinks
    New-Item -ItemType Directory -Force -Path "${Env:ALLUSERSPROFILE}\bin"
    [Environment]::SetEnvironmentVariable (
        "PATH",
        (Append-Idempotent "${Env:ALLUSERSPROFILE}\bin" "$Env:Path" ";" $False),
        [System.EnvironmentVariableTarget]::Machine
    )
    [Environment]::SetEnvironmentVariable (
        "PATH",
        (Append-Idempotent "${Env:ALLUSERSPROFILE}\bin" "$Env:Path" ";" $False),
        [System.EnvironmentVariableTarget]::Process
    )
    
    # User variables

    # Home environment variables
    [Environment]::SetEnvironmentVariable ("HOME", $Env:UserProfile, [System.EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable ("HOME", $Env:UserProfile, [System.EnvironmentVariableTarget]::Process)
    
    # Disable Cygwin warning about Unix file paths
    [Environment]::SetEnvironmentVariable ("CYGWIN", "nodosfilewarning", [System.EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable ("CYGWIN", "nodosfilewarning", [System.EnvironmentVariableTarget]::Process)
    
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

    # Schedule the next stage of this script and reboot
    Unregister-ScheduledTask -TaskName "Dotfiles - 1" -Confirm:$false -ErrorAction SilentlyContinue
    ScheduleRebootTask -Name "Dotfiles - " -Stage 1

} elseif ($Stage -eq 1) {

    Unregister-ScheduledTask -TaskName "Dotfiles - 1" -Confirm:$false

    # Stop the Windows Native SSH Service due to Developer Tools
    Stop-Service -Name "SshBroker" -Force -Confirm:$false -ErrorAction SilentlyContinue
    # Disable both SSH service and the SSH proxy
    Set-Service -Name "SshProxy" -Status Stopped -StartupType Disabled -Confirm:$false -ErrorAction SilentlyContinue
    Set-Service -Name "SshBroker" -Status Stopped -StartupType Disabled -Confirm:$false -ErrorAction SilentlyContinue
    
    # Setup Windows Package Management
    
    # Update Package Management
    Import-Module PackageManagement
    Import-Module PowerShellGet
    # Nuget is needed for PowerShellGet
    Install-PackageProvider -Name Nuget -Force
    # Updating PowerShellGet updates PackageManagement
    Install-Module -Name PowerShellGet -Force
    # Update PackageManagement Explicitly to be Sure
    Install-Module -Name PackageManagement -Force
    # Reimport PackageManagement and PowerShellGet to take advantage of the new commands
    Import-Module PackageManagement -Force
    Import-Module PowerShellGet -Force

    # Install Package Providers
    # There are 2 Chocolatey Providers for now (one works or the other does)
    # PowerShellGet is also a package provider
    # We are not using the Chocolatey provider because it is very buggy
    # Install-PackageProvider –Name 'Chocolatey' -Force
    Install-PackageProvider -Name 'ChocolateyGet' -Force
    Install-PackageProvider -Name 'PowerShellGet' -Force
    
    # The ChocolateyGet bin path is "${Env:ChocolateyInstall}\bin"
    # It is automatically appended to the system PATH environment variable upon installation of the first package
    # The directory is populated for special packages, but won't necessarily be populated by native installers
    # The ChocolateyGet will also automatically install chocolatey package, making the choco commands available as well
    
    # Nuget doesn't register a package source by default
    Register-PackageSource -Name 'nuget' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' 

    # Acquire the Package Lists
    $WindowsPackages = (Get-Content "${PSScriptRoot}\windows_packages.txt" | Where-Object { 
        $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
    })

    # Install the Windows Packages
    foreach ($Package in $WindowsPackages) {

        $Package = $Package -split ','
        $Name = $Package[0].trim()
        $Version = $Package[1].trim()
        $Provider = $Package[2].trim()
        
        # the fourth parameter is optional completely, there's no need to even have a comma
        if ($Package.Length -eq 4) {
            $AdditionalArguments = $Package[3].trim()
        } else {
            $AdditionalArguments = ''
        }

        $InstallCommand = "Install-Package -Name '$Name' "

        if ($Version -and $Version -ne '*') {
            $InstallCommand += "-RequiredVersion '$Version' "
        }

        if ($Provider) {
            $InstallCommand += "-ProviderName '$Provider' "
        }

        if ($AdditionalArguments) {
            $InstallCommand += "-AdditionalArguments @'
            --installargs `"$AdditionalArguments`"
            '@ "
        }

        $InstallCommand += "-Force"
        
        Invoke-Expression "$InstallCommand"
        
    }
    
    # Special conditional packages are listed here
    
    if ((Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online).State -eq 'Enabled') {
    
        Install-Package -Name 'docker-for-windows' -ProviderName 'chocolateyget' -RequiredVersion '1.12.3.8488' -Force
    
    } else {
        
        Write-Host 'Microsoft Hyper V is not available on this computer. Instead of Docker for Windows, try: https://www.docker.com/products/docker-toolbox'
        Write-Host 'It requires manual installation.'
        
    }

    # Installing Cygwin Packages

    # Create the necessary directories

    New-Item -ItemType Directory -Force -Path "$InstallationDirectory/cygwin64"
    New-Item -ItemType Directory -Force -Path "$InstallationDirectory/cygwin64/packages"

    # Acquire Package Lists

    $MainPackages = (Get-Content "${PSScriptRoot}\cygwin_main_packages.txt" | Where-Object { 
        $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
    }) -Join ','
    $PortPackages = (Get-Content "${PSScriptRoot}\cygwin_port_packages.txt" | Where-Object { 
        $_.trim() -ne '' -and $_.trim() -notmatch '^#' 
    }) -Join ','

    # Main Packages

    if ($MainPackages) {
        Start-Process -FilePath "${PSScriptRoot}\.bin\cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
            "--quiet-mode",
            "--no-shortcuts",
            "--no-startmenu",
            "--no-desktop",
            "--arch x86_64",
            "--upgrade-also",
            "--delete-orphans",
            "--root '${InstallationDirectory}/cygwin64'",
            "--local-package-dir '${InstallationDirectory}/cygwin64/packages'",
            "--site '$MainMirror'",
            "--packages '$MainPackages'"
    }

    # Cygwin Port Packages

    if ($PortPackages) {
        Start-Process -FilePath "${PSScriptRoot}\.bin\cygwin-setup-x86_64.exe" -Wait -Verb RunAs -ArgumentList `
            "--quiet-mode",
            "--no-shortcuts",
            "--no-startmenu",
            "--no-desktop",
            "--arch x86_64",
            "--upgrade-also",
            "--delete-orphans",
            "--root '${InstallationDirectory}/cygwin64'",
            "--local-package-dir '${InstallationDirectory}/cygwin64/packages'",
            "--site '$PortMirror'",
            "--pubkey '$PortKey'",
            "--packages '$PortPackages'"
    }

    # Schedule a final reboot to start the Cygwin setup process
    Unregister-ScheduledTask -TaskName "Dotfiles - 2" -Confirm:$false -ErrorAction SilentlyContinue
    ScheduleRebootTask -Name "Dotfiles - " -Stage 2

} elseif ($Stage -eq 2) {

    Unregister-ScheduledTask -TaskName "Dotfiles - 2" -Confirm:$false

    # Use Carbon's Grant-Privilege feature to give us the ability to create Windows symbolic links
    # Because I am an administrator user, this doesn't give me unelevated access to creating native symlinks.
    # I still need to elevate to be able to create a symlink. This is caused by UAC filtering, which filters out the privilege.
    # See the difference in `whoami /priv` running elevated vs non-elevated in Powershell.
    # However if UAC is disabled, then the administrator user can create symlinks without elevating.
    # If I was a non-administrator user, then I would have the ability to create symlinks without any more work.
    # See: http://superuser.com/q/839580
    Import-Module 'Carbon'
    Grant-Privilege -Identity "$Env:UserName" -Privilege SeCreateSymbolicLinkPrivilege
    
    # Add the primary Cygwin bin paths to PATH before launching install.sh directly from Powershell
    # This is because the PATH is not been completely configured for Cygwin before install.sh runs
    [Environment]::SetEnvironmentVariable (
        "PATH",
        (Prepend-Idempotent "${InstallationDirectory}\usr\bin" "$Env:Path" ";" $False),
        [System.EnvironmentVariableTarget]::Process
    )
    [Environment]::SetEnvironmentVariable (
        "PATH",
        (Prepend-Idempotent "${InstallationDirectory}\usr\sbin" "$Env:Path" ";" $False),
        [System.EnvironmentVariableTarget]::Process
    )
    [Environment]::SetEnvironmentVariable (
        "PATH",
        (Prepend-Idempotent "${InstallationDirectory}\bin" "$Env:Path" ";" $False),
        [System.EnvironmentVariableTarget]::Process
    )
    [Environment]::SetEnvironmentVariable (
        "PATH",
        (Prepend-Idempotent "${InstallationDirectory}\sbin" "$Env:Path" ";" $False),
        [System.EnvironmentVariableTarget]::Process
    )

    Start-Process -FilePath "$InstallationDirectory\bin\bash.exe" -Wait -Verb RunAs -ArgumentList "${PSScriptRoot}\install.sh"

}
