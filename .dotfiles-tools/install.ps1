#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [ValidateLength(2, 15)][string]$ComputerName = "POLYHACK-" + "$(-join ((65..90) | Get-Random -Count 5 | % {[char]$_}))",
    [string]$MainMirror = "http://mirrors.kernel.org/sourceware/cygwin",
    [string]$PortMirror = "ftp://ftp.cygwinports.org/pub/cygwinports",
    [string]$PortKey = "http://cygwinports.org/ports.gpg",
    [string]$InstallationDirectory = "$Env:SystemDrive",
    [string]$LogPath = $null,
    [int]$Stage = 0,
    [switch]$ForceReinstallation
)

if ($LogPath) {
    Start-Transcript -Path "$LogPath" -Append
}

# Utility functions

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
        "`"& '${PSCommandPath}' -MainMirror '${MainMirror}' -PortMirror '${PortMirror}' -PortKey '${PortKey}' -InstallationDirectory '${InstallationDirectory}' -LogPath '${LogPath}' -Stage ${Stage} -ForceReinstallation:`$${ForceReinstallation}`""
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

    # Copy the transparent.ico icon for removing NTFS compression arrow icon
    Copy-Item "${PSScriptRoot}\..\.dotfiles-data\transparent.ico" "${Env:SYSTEMROOT}\system32"
    Unblock-File -Path "${Env:SYSTEMROOT}\system32\transparent.ico"

    # Setup wallpaper
    # Even if the image is smaller than the resolution of the screen, it will be filled to the resolution of the screen
    # Preferably use a large resolution image like 3000 x 2000
    $Wallpaper = $(Get-ChildItem "${PSScriptRoot}\..\Pictures\wallpaper.png")
    Copy-Item -Path "$($Wallpaper.FullName)" -Destination "${Env:USERPROFILE}\Pictures"
    Unblock-File -Path "${Env:USERPROFILE}\Pictures\$($Wallpaper.Name)"
    & "${PSScriptRoot}\set-wallpaper.ps1" -WallpaperPath "${Env:USERPROFILE}\Pictures\$($Wallpaper.Name)" -Style 'Fill'

    # Allow Powershell scripts to be executable
    Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

    # Associate `*.ps1` scripts to PowerShell
    CMD /C 'assoc .ps1=Microsoft.PowerShellScript.1' >$null
    CMD /C 'ftype Microsoft.PowerShellScript.1="%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe" "%1"' >$null

    # Setup Windows Registry
    & "${PSScriptRoot}\set-registry.ps1"

    # Setup Windows Environment Variables (not PATH)
    & "${PSScriptRoot}\set-environment.ps1"

    # Setup Windows Optional Features
    & "${PSScriptRoot}\set-features.ps1"

    # Setup windows firewall
    & "${PSScriptRoot}\set-firewall.ps1" -InstallationDirectory "$InstallationDirectory"

    # Change power settings for the current plan
    & "${PSScriptRoot}\set-power.ps1"

    # Setup exclusions for windows defender
    & "${PSSCriptRoot}\set-windows-defender-exclusions.ps1"

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
    Remove-Item "${Env:UserProfile}\Contacts" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "${Env:UserProfile}\Favorites" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "${Env:UserProfile}\Links" -Recurse -Force -ErrorAction SilentlyContinue

    # Uninstall Windows 10 Bloat
    & "${PSScriptRoot}\uninstall-windows-apps.ps1"

    # Setup Windows Package Management
    & "${PSScriptRoot}\upstall-windows-packages.ps1" -Force:$ForceReinstallation

    # Install Powershell Help Files (so we can use -?)
    Update-Help -Force:$ForceReinstallation

    # Setup Chrome App Shortcuts and Symlinks to Native Packages
    & "${PSScriptRoot}\upstall-windows-symlinks-shortcuts.ps1"

    # Installing Cygwin Packages
    & "${PSScriptRoot}\upstall-cygwin-packages.ps1" -MainMirror "$MainMirror" -PortMirror "$PortMirror" -PortKey "$PortKey" -InstallationDirectory "$InstallationDirectory" -Force:$ForceReinstallation

    # Use Carbon's Grant-Privilege feature to give us the ability to create Windows symbolic links
    # Because I am an administrator user, this doesn't give me unelevated access to creating native symlinks.
    # I still need to elevate to be able to create a symlink. This is caused by UAC filtering, which filters out the privilege.
    # See the difference in `whoami /priv` running elevated vs non-elevated in Powershell.
    # However if UAC is disabled, then the administrator user can create symlinks without elevating.
    # If I was a non-administrator user, then I would have the ability to create symlinks without any more work.
    # See: http://superuser.com/q/839580
    Import-Module Carbon -Force
    Grant-Privilege -Identity "$Env:UserName" -Privilege SeCreateSymbolicLinkPrivilege

    & "${PSScriptRoot}\set-dns.ps1"

    # Schedule a final reboot to start the Cygwin setup process
    Unregister-ScheduledTask -TaskName "Dotfiles - 2" -Confirm:$false -ErrorAction SilentlyContinue
    ScheduleRebootTask -Name "Dotfiles - " -Stage 2

} elseif ($Stage -eq 2) {

    Unregister-ScheduledTask -TaskName "Dotfiles - 2" -Confirm:$false

    # Add the primary Cygwin bin paths to PATH before launching install.sh directly from Powershell
    # This is because the PATH is not been completely configured for Cygwin before install.sh runs
    # This is only needed temporarily
    $Env:Path = (
        "${InstallationDirectory}\cygwin64\usr\local\bin;" +
        "${InstallationDirectory}\cygwin64\usr\local\sbin;" +
        "${InstallationDirectory}\cygwin64\usr\bin;" +
        "${InstallationDirectory}\cygwin64\usr\sbin;" +
        "${InstallationDirectory}\cygwin64\bin;" +
        "${InstallationDirectory}\cygwin64\sbin;" +
        "${Env:Path};"
    )

    if ($ForceReinstallation) {
        Start-Process -FilePath "$InstallationDirectory\cygwin64\bin\bash.exe" -Wait -Verb RunAs -ArgumentList "`"${PSScriptRoot}\install.sh`" --force"
    } else {
        Start-Process -FilePath "$InstallationDirectory\cygwin64\bin\bash.exe" -Wait -Verb RunAs -ArgumentList "`"${PSScriptRoot}\install.sh`""
    }

    echo "Finished deploying on Windows."
    echo "There are some final tasks to remember!"
    echo "1. Install any not-yet-automated packages."
    echo "2. Use gpedit.msc to disable OneDrive by going to Local Computer Policy\Computer Configuration\Administrative Templates\Windows Components\OneDrive, and also remove the OneDrive environment variable."
    echo "3. Use msconfig to disable startup services and tasks that are unnecessary. This will speed up bootup and restarts."
    echo "4. Remember to run ${Env:USERPROFILE}/.dotfiles/.dotfiles-tools/set-windows-path.ps1."
    echo "5. Configure to use your local DNS server and Hosts file, point your DNS address on relevant network interfaces to 127.0.0.1 and ::1."
    echo "6. Remember to check your Sign-in options and make sure to select that you want to sign-in on every time you are away."
    echo "7. Finally restart your computer!"

}

# ScheduleRebootTask will also stop the transcript before rebooting
# But if you've reached here, then the script has ended!
if ($LogPath) {
    Stop-Transcript
}
