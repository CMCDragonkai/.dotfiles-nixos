#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [ValidateLength(2, 15)][string]$ComputerName = "POLYHACK-" + "$(-join ((65..90) | Get-Random -Count 5 | % {[char]$_}))", 
    [string]$MainMirror = "http://mirrors.kernel.org/sourceware/cygwin", 
    [string]$PortMirror = "ftp://ftp.cygwinports.org/pub/cygwinports", 
    [string]$PortKey = "http://cygwinports.org/ports.gpg", 
    [string]$InstallationDirectory = "$Env:UserProfile", 
    [string]$LogPath = $null, 
    [int]$Stage = 0
)

if ($LogPath) {
    Start-Transcript -Path "$LogPath" -Append
}

# Utility Functions

function Append-Idempotent {

    # the delimiter is expected to be just 1 character
    param (
        [string]$InputString, 
        [string]$OriginalString, 
        [string]$Delimiter = '', 
        [bool]$CaseSensitive = $false
    )

    if ($CaseSensitive -and ("$OriginalString" -cnotlike "*${InputString}*")) {

        "$OriginalString".TrimEnd("$Delimiter") + "$Delimiter" + "$InputString".TrimStart("$Delimiter")

    } elseif (! $CaseSensitive -and ("$OriginalString" -inotlike "*${InputString}*")) {
        
        "$OriginalString".TrimEnd("$Delimiter") + "$Delimiter" + "$InputString".TrimStart("$Delimiter")

    } else {

        "$OriginalString"
    
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
        "`"& '${PSCommandPath}' -MainMirror '${MainMirror}' -PortMirror '${PortMirror}' -PortKey '${PortKey}' -InstallationDirectory '${InstallationDirectory}' -LogPath '${LogPath}' -Stage ${Stage}`""
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

    if ($LogPath) {
        Stop-Transcript
    }

    Restart-Computer

}

# Bootstrap the computer!

if ($Stage -eq 0) {

    Write-Host "Before you continue the installation, you should RAID with Storage Spaces, switch on NTFS compression, and encrypt with Bitlocker on your drive(s)."
    Read-Host "Enter to continue"
    
    # Copy the transparent.ico icon
    Copy-Item "${PSScriptRoot}\data\transparent.ico" "${Env:SYSTEMROOT}\system32"
    Unblock-File -Path "${Env:SYSTEMROOT}\system32\transparent.ico"

    # Install Powershell Help Files (so we can use -?)
    Update-Help

    # Import the registry file
    Start-Process -FilePath "$Env:SystemRoot\system32\reg.exe" -Wait -Verb RunAs -ArgumentList "IMPORT `"${PSScriptRoot}\windows_registry.reg`""
    
    # Enable Telnet
    Get-WindowsOptionalFeature -Online -FeatureName TelnetClient | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null
    # Enable .NET Framework 3.5, 3.0 and 2.0
    # This is required for some legacy applications and CUDA applications
    Get-WindowsOptionalFeature -Online -FeatureName NetFx3 | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null
    # Enable Windows Containers
    Get-WindowsOptionalFeature -Online -FeatureName Containers | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null
    # Enable Hyper-V hypervisor, this will prevent Virtualbox from running concurrently
    # However Hyper-V can be disabled at boot for when you need to use virtualbox
    # This is needed for Docker on Windows to run
    Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V | Enable-WindowsOptionalFeature -Online -All -NoRestart >$null
    
    # Allow Powershell scripts to be executable
    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
    
    # System variables
   
    # Make the `*.ps1` scripts executable without the `.ps1` extension
    # By default Windows will have set `.COM;.EXE;.BAT;.CMD` as path extensions
    [Environment]::SetEnvironmentVariable(
        "PATHEXT", 
        (Append-Idempotent ".PS1" "$Env:PATHEXT" ";" $False), 
        [System.EnvironmentVariableTarget]::Machine
    )
    [Environment]::SetEnvironmentVariable(
        "PATHEXT", 
        (Append-Idempotent ".PS1" "$Env:PATHEXT" ";" $False), 
        [System.EnvironmentVariableTarget]::Process
    )
    CMD /C 'assoc .ps1=Microsoft.PowerShellScript.1' >$null
    CMD /C 'ftype Microsoft.PowerShellScript.1="%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" "%1"' >$null
    
    # Make Windows Shortcuts `*.lnk` executable without the `.lnk` extension
    [Environment]::SetEnvironmentVariable(
        "PATHEXT", 
        (Append-Idempotent ".LNK" "$Env:PATHEXT" ";" $False), 
        [System.EnvironmentVariableTarget]::Machine
    )
    [Environment]::SetEnvironmentVariable(
        "PATHEXT", 
        (Append-Idempotent ".LNK" "$Env:PATHEXT" ";" $False), 
        [System.EnvironmentVariableTarget]::Process
    )
    
    # User variables

    # Home environment variables
    [Environment]::SetEnvironmentVariable("HOME", $Env:UserProfile, [System.EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("HOME", $Env:UserProfile, [System.EnvironmentVariableTarget]::Process)
    
    # Disable Cygwin warning about Unix file paths
    [Environment]::SetEnvironmentVariable("CYGWIN", "nodosfilewarning", [System.EnvironmentVariableTarget]::User)
    [Environment]::SetEnvironmentVariable("CYGWIN", "nodosfilewarning", [System.EnvironmentVariableTarget]::Process)
    
    # Setup windows firewall
    & "${PSScriptRoot}\tools\set-firewall.ps1" -InstallationDirectory "$InstallationDirectory"

    # Change power settings for the current plan
    & "${PSScriptRoot}\tools\set-power.ps1"

    # Rename the computer to the new name just before a restart
    Rename-Computer -NewName "$ComputerName" -Force >$null 2>&1

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
    
    # Remove useless profile folders
    Remove-Item "${Env:UserProfile}\Contacts" -Recurse -Force
    Remove-Item "${Env:UserProfile}\Favorites" -Recurse -Force
    Remove-Item "${Env:UserProfile}\Links" -Recurse -Force

    # Uninstall Useless Applications
    $AppsToBeUninstalled = @(
        'Microsoft.3DBuilder' 
        'Microsoft.WindowsFeedbackHub' 
        'Microsoft.MicrosoftOfficeHub' 
        'Microsoft.MicrosoftSolitaireCollection*'
        'Microsoft.BingFinance' 
        'Microsoft.BingNews' 
        'Microsoft.SkypeApp' 
        'Microsoft.BingSports' 
        'Microsoft.Office.Sway' 
        'Microsoft.XboxApp' 
        'Microsoft.MicrosoftStickyNotes' 
        'Microsoft.ConnectivityStore' 
        'Microsoft.CommsPhone' 
        'Microsoft.WindowsPhone' 
        'Microsoft.OneConnect' 
        'Microsoft.People' 
        'Microsoft.Appconnector' 
        'Microsoft.Getstarted' 
        'Microsoft.WindowsMaps' 
        'Microsoft.ZuneMusic' 
        'Microsoft.Freshpaint' 
        'Flipboard.Flipboard' 
        '9E2F88E3.Twitter' 
        'king.com.CandyCrushSodaSaga' 
        'Drawboard.DrawboardPDF' 
        'Facebook.Facebook' 
    )
    
    foreach ($App in $AppsToBeUninstalled) {
        Get-AppxPackage -AllUsers -Name "$App" | Remove-AppxPackage -Confirm:$false
        Get-AppxProvisionedPackage -Online | Where DisplayName -EQ "$App" | Remove-AppxProvisionedPackage -Online
    }
    
    # Setup Windows Package Management
    & "${PSScriptRoot}\tools\upstall-windows-packages.ps1" -Force

    # Setup Chrome App Shortcuts and Symlinks to Native Packages
    & "${PSScriptRoot}\tools\upstall-windows-symlinks-shortcuts.ps1"

    # Installing Cygwin Packages
    & "${PSScriptRoot}\tools\upstall-cygwin-packages.ps1" -MainMirror "$MainMirror" -PortMirror "$PortMirror" -PortKey "$PortKey" -InstallationDirectory "$InstallationDirectory" -CleanInstallation

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
    # This is only needed temporarily

    $Env:Path = (
        "${InstallationDirectory}\cygwin64\usr\bin;" + 
        "${InstallationDirectory}\cygwin64\usr\sbin;" + 
        "${InstallationDirectory}\cygwin64\bin;" + 
        "${InstallationDirectory}\cygwin64\sbin;" + 
        "${Env:Path};"
    )
    Start-Process -FilePath "$InstallationDirectory\cygwin64\bin\bash.exe" -Wait -Verb RunAs -ArgumentList "`"${PSScriptRoot}\install.sh`""

    echo "Finished deploying on Windows." 
    echo "There are some final tasks to remember!"
    echo "1. Install any not-yet-automated packages."
    echo "2. Use gpedit.msc to disable OneDrive by going to Local Computer Policy\Computer Configuration\Administrative Templates\Windows Components\OneDrive, and also remove the OneDrive environment variable."
    echo "3. Use msconfig to disable startup services and tasks that are unnecessary. This will speed up bootup and restarts."
    echo "4. Remember to run ${PSScriptRoot}\tools\clean-windows-path.ps1."
    echo "5. Configure to use your local DNS server and Hosts file, point your DNS address on relevant network interfaces to 127.0.0.1 and ::1."
    echo "6. Finally restart your computer!"

}

# ScheduleRebootTask will also stop the transcript before rebooting
# But if you've reached here, then the script has ended!
if ($LogPath) {
    Stop-Transcript
}