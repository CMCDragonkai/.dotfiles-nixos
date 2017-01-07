#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

Start-Process `
    -FilePath "$Env:SystemRoot\system32\reg.exe" `
    -Wait `
    -Verb RunAs `
    -ArgumentList "IMPORT `"${PSScriptRoot}\..\.dotfiles-config\windows_registry.reg`""
