#!/usr/bin/env powershell
#requires -RunAsAdministrator

# Unidentified network connections will not show here
# Not all profiles shown here will be active
# https://blogs.technet.microsoft.com/networking/2010/09/08/network-location-awareness-nla-and-how-it-relates-to-windows-firewall-profiles/

param (
    [string]$ID = $null,
    [string]$Name = $null,
    [string]$Description = $null,
    [ValidateSet('Public', 'Private')]$Category = $null
)

if ($ID) {

    $ProfileKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\{$ID}"

    if (Test-Path -Path "$ProfileKey") {

        if ($Name) {
            Set-ItemProperty -Path "$ProfileKey" -Name 'ProfileName' -Value "$Name"
        }

        if ($Description) {
            Set-ItemProperty -Path "$ProfileKey" -Name 'Description' -Value "$Description"
        }

        if ($Category) {
            switch ($Category) {
                'Public' {
                    Set-ItemProperty -Path "$ProfileKey" -Name 'Category' -Value 0 -Type DWord
                }
                'Private' {
                    Set-ItemProperty -Path "$ProfileKey" -Name 'Category' -Value 1 -Type DWord
                }
            }
        }

    } else {

        Write-Host "Network Profile {$ID} does not exist!"
        Exit 3

    }

} else {

    Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles' `
    | ForEach-Object { Get-ItemProperty $_.PSPath } `
    | Select-Object -Property `
        @{Label = "ID"; Expression = { $_.PSChildName.Trim('{}') }}, `
        @{Label = "Name"; Expression = { $_.ProfileName }}, `
        Description, `
        @{Label = "Category"; Expression = {
            switch ($_.Category) {
                0 {"Public"}
                1 {"Private"}
                2 {"Domain"}
            }
        }}, `
        Managed `
    | Format-Table

}
