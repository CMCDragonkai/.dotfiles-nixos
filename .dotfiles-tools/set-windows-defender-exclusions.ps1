#!/usr/bin/env powershell
#requires -RunAsAdministrator
#requires -Version 5.0

Add-MpPreference -ExclusionPath "${Env:UserProfile}\Projects"

Add-MpPreference -ExclusionProcess 'gcc.exe'
Add-MpPreference -ExclusionProcess 'ld.exe'
Add-MpPreference -ExclusionProcess 'cl.exe'
Add-MpPreference -ExclusionProcess 'msbuild.exe'
Add-MpPreference -ExclusionProcess 'devenv.exe'
Add-MpPreference -ExclusionProcess 'ghc.exe'
Add-MpPreference -ExclusionProcess 'stack.exe'
