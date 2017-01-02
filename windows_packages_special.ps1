#!/usr/bin/env powershell

param (
    [switch]$Force
)

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