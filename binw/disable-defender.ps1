#!/usr/bin/env powershell
#requires -RunAsAdministrator

try {

    Set-MpPreference -DisableRealtimeMonitoring $true
    Read-Host "Enter or Exit to renable Real Time Monitoring"

} finally {

    Set-MpPreference -DisableRealtimeMonitoring $false

}
