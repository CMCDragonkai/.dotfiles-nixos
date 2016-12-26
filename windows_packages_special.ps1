#!/usr/bin/env powershell

if ((Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V -Online).State -eq 'Enabled') {

    Install-Package -Name 'docker-for-windows' -ProviderName 'chocolateyget' -RequiredVersion '1.12.3.8488' -Force

} else {
    
    Write-Host 'Microsoft Hyper V is not available on this computer. Instead of Docker for Windows, try: https://www.docker.com/products/docker-toolbox'
    Write-Host 'It requires manual installation.'
    
}