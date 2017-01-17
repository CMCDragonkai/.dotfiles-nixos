#!/usr/bin/env powershell

# This script can keep the computer awake while executing another executable, or
# if no executable was passed in, then it stays awake until this script stops.
# There are 3 different ways of staying awake:
#     Away Mode - Enable away mode (https://blogs.msdn.microsoft.com/david_fleischman/2005/10/21/what-does-away-mode-do-anyway/)
#     Display Mode - Keep the display on and don't go to sleep or hibernation
#     System Mode - Don't go to sleep or hibernation
# The default mode is the System Mode.
# Away mode is only available when away mode is enabled in the advanced power options.
# An alternative to this script is using presentation mode, but this is more flexible.

param (
    [string]$Executable = $null,
    [ValidateSet('Away', 'Display', 'System')]$Option = 'System'
)

$Code=@'
[DllImport("kernel32.dll", CharSet = CharSet.Auto,SetLastError = true)]
public static extern void SetThreadExecutionState(uint esFlags);
'@

$ste = Add-Type -memberDefinition $Code -name System -namespace Win32 -passThru

# Requests that the other EXECUTION_STATE flags set remain in effect until
# SetThreadExecutionState is called again with the ES_CONTINUOUS flag set and
# one of the other EXECUTION_STATE flags cleared.
$ES_CONTINUOUS = [uint32]"0x80000000"
$ES_AWAYMODE_REQUIRED = [uint32]"0x00000040"
$ES_DISPLAY_REQUIRED = [uint32]"0x00000002"
$ES_SYSTEM_REQUIRED = [uint32]"0x00000001"

Switch ($Option) {
    "Away"    {$Setting = $ES_AWAYMODE_REQUIRED}
    "Display" {$Setting = $ES_DISPLAY_REQUIRED}
    "System"  {$Setting = $ES_SYSTEM_REQUIRED}
}

try {

    Write-Host "Staying Awake with ``${Option}`` Option"

    $ste::SetThreadExecutionState($ES_CONTINUOUS -bor $Setting)

    if ($Executable) {
        Write-Host "Executing Executable"
        & "$Executable"
    } else {
        Read-Host "Enter or Exit to Stop Staying Awake"
    }

} finally {

    Write-Host "Stopping Staying Awake"
    $ste::SetThreadExecutionState($ES_CONTINUOUS)

}
