#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# Run this after installing anything!

# After installation of various packages, the PATHs may be mutated
# We want to maintain a strict PATH setup so we know where things are found
# Most packages that will add their own path to the PATH should be converted to be using symlinks
# Symlinks can be placed in either the custom global or local executable locations
# However some packages are very complex, and so we leave them added to our PATH

# Windows looks up PATHS left to right
# System PATH is given priority over User PATH because it is prepended
# Windows doesn't just look for executables but anything in the PATHEXT including DLLs

$UserPaths =
    # Original User Paths
    '%LOCALAPPDATA%\Microsoft\WindowsApps',
    # Custom local executables
    '%LOCALAPPDATA%\bin'

$SystemPaths =
    # Original System Paths
    '%SystemRoot%\system32',
    '%SystemRoot%',
    '%SystemRoot%\System32\Wbem',
    '%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\',
    # NVIDIA graphics driver DLLs
    '%ProgramFiles(x86)%\NVIDIA Corporation\PhysX\Common',
    # Custom global executables
    '%ALLUSERSPROFILE%\bin',
    # Chocolatey global executables
    '%ChocolateyInstall%\bin',
    # JDK (preferred over JRE)
    '%JAVA_HOME%\bin',
    # Windows 10 SDK
    '%ProgramFiles(x86)%\Windows Kits\10\Windows Performance Toolkit',
    # CUDA
    '%CUDA_PATH%\bin',
    '%CUDA_PATH%\libnvvp',
    # Windows Git
    '%ProgramFiles%\Git\cmd',
    # MikTex 2.9
    '%ProgramFiles%\MiKTeX 2.9\miktex\bin\x64\'

# Filter out PATHs that don't exist
$UserPaths = $UserPaths | Where-Object { Test-Path "$([System.Environment]::ExpandEnvironmentVariables(`"$_`"))" -PathType Container }
$SystemPaths = $SystemPaths | Where-Object { Test-Path "$([System.Environment]::ExpandEnvironmentVariables(`"$_`"))" -PathType Container }

# We should always have a semicolon at the very end to make it predictable to append
$UserPaths = ($UserPaths -Join ';') + ';'
$SystemPaths = ($SystemPaths -Join ';') + ';'

# Because these PATHs have expandable strings, we cannot use the normal [Environment]::SetEnvironmentVariable function
# Instead we need to go the registry and make sure our environment variable is considered an expandable string

try {

    $UserKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment', $true)
    $SystemKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)

    $UserKey.SetValue('Path', "$UserPaths", 'ExpandString')
    $SystemKey.SetValue('Path', "$SystemPaths", 'ExpandString')

} finally {

    $UserKey.Dispose()
    $SystemKey.Dispose()

}
