#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

# Variables targeting current process will be acquired by the calling process

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

# GOPATH points to where go dependencies should be installed
# This is only required because Golang is a Windows executable
[Environment]::SetEnvironmentVariable("GOPATH", "${Env:UserProfile}\.go", [System.EnvironmentVariableTarget]::User)
[Environment]::SetEnvironmentVariable("GOPATH", "${Env:UserProfile}\.go", [System.EnvironmentVariableTarget]::Process)
