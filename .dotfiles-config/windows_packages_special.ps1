#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

param (
    [switch]$Force
)

# Docker for Windows requires Hyper-V
# Without Hyper-V, Docker Toolbox is the alternative
# But that requires manual installation

if ((Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online).State -eq 'Enabled') {

    if ($Force) {
        Install-Package -Name 'docker-for-windows' -ProviderName 'chocolateyget' -RequiredVersion '1.12.3.8488' -Force
    } else {
        Install-Package -Name 'docker-for-windows' -ProviderName 'chocolateyget' -RequiredVersion '1.12.3.8488'
    }

} else {

    echo 'Microsoft Hyper V is not available on this computer. Instead of Docker for Windows, try: https://www.docker.com/products/docker-toolbox'
    echo 'It requires manual installation.'

}

# Microsoft SQL Server (Express) cannot be installed in compressed folders.
# So we must first create uncompressed installation folders.
# The below script relies on the Carbon module to disable NTFS compression

New-Item -ItemType Directory -Force -Path "${Env:ProgramFiles}\Microsoft SQL Server"
New-Item -ItemType Directory -Force -Path "${Env:ProgramFiles(x86)}\Microsoft SQL Server"
Disable-NtfsCompression -Path "${Env:ProgramFiles}\Microsoft SQL Server"
Disable-NtfsCompression -Path "${Env:ProgramFiles(x86)}\Microsoft SQL Server"
if ($Force) {
    Install-Package -Name 'mssqlserver2014express' -ProviderName 'chocolateyget' -Force
} else {
    Install-Package -Name 'mssqlserver2014express' -ProviderName 'chocolateyget'
}
Set-Service -Name 'MSSQL$SQLEXPRESS' -StartupType Manual
Set-Service -Name 'SQLWriter' -StartupType Manual
Stop-Service -Name 'MSSQL$SQLEXPRESS'
Stop-Service -Name 'SQLWriter'
