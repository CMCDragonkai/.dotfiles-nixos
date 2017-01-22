@echo off

REM Only CMD console hosts launched in ConEmu should bootstrap with this file
REM Like: `cmd /K %USERPROFILE%/.cmd_profile.bat`
REM Unfortunately there's no way on Windows to make CMD automatically read a profile on launch
REM So you just need to change all `cmd` invocations to use the above command
REM Launching CMD from CYGWIN does not require the below settings, as the PATH is inherited
REM and the PROMPT doesn't work in Cygwin Terminal Emulators nor native Windows console host

SET PATH=%PATH:;=%;%USERPROFILE%\bin;
SET PATH=%PATH:;=%;%GOPATH%\bin;
SET PATH=%PATH:;=%;%USERPROFILE%\.npm;

PROMPT $E[32m$E]9;8;"USERNAME"$E\@$E]9;8;"COMPUTERNAME"$E\$S$E[92m$P$E[90m$_$E[90m$S$G$E[m$S
