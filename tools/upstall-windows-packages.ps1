#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [switch]$Force
)

Import-Module PackageManagement
Import-Module PowerShellGet

# Nuget is needed for PowerShellGet
# Updating PowerShellGet updates PackageManagement
# Update PackageManagement explicitly to be sure
# PSReadline is nice
if ($Force) {
    
    Install-PackageProvider -Name Nuget -Force
    Install-Module -Name PowerShellGet -Force
    Install-Module -Name PackageManagement -Force
    Install-Module -Name PSReadline -Force -SkipPublisherCheck
    Install-Module -Name BurntToast -Force

} else {

    Install-PackageProvider -Name Nuget
    Install-Module -Name PowerShellGet
    Install-Module -Name PackageManagement
    Install-Module -Name PSReadline -SkipPublisherCheck
    Install-Module -Name BurntToast

}

# Reimport PackageManagement and PowerShellGet to take advantage of the new commands
Import-Module PackageManagement -Force
Import-Module PowerShellGet -Force

# The ChocolateyGet provider is more stable
if ($Force) {

    Install-PackageProvider -Name 'ChocolateyGet' -Force
    Install-PackageProvider -Name 'PowerShellGet' -Force

} else {

    Install-PackageProvider -Name 'ChocolateyGet'
    Install-PackageProvider -Name 'PowerShellGet'

}

# The ChocolateyGet bin path is "${Env:ChocolateyInstall}\bin"
# The directory is populated for special packages, but won't necessarily be populated by native installers
# The ChocolateyGet will also automatically install chocolatey package, making the choco commands available as well

# Make PowerShellGet's source trusted
Set-PackageSource -Name 'PSGallery' -ProviderName 'PowerShellGet' -Trusted -Force
    
# Nuget doesn't register a package source by default
Register-PackageSource -Name 'NuGet' -ProviderName 'NuGet' -Location 'https://www.nuget.org/api/v2' -Trusted -Force

# Acquire the Package Lists
$WindowsPackages = (Get-Content "${PSScriptRoot}\..\windows_packages.txt" | Where-Object { 
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

        # heredoc in powershell (must have no spaces before ending `'@`)
        $InstallCommand += "-AdditionalArguments @'
            --installargs `"$AdditionalArguments`"
'@ "

    }

    if ($Force) {
        $InstallCommand += '-Force'
    }

    Invoke-Expression "$InstallCommand"
    
}

# Windows packages requiring special instructions
if ($Force) {

    & "${PSScriptRoot}\..\windows_packages_special.ps1" -Force

} else {

    & "${PSScriptRoot}\..\windows_packages_special.ps1"

}
