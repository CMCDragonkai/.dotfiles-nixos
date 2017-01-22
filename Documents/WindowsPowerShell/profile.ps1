# This is for the current user only and for all console hosts

# Local node executables
$Env:Path = "${Env:Path}".TrimEnd(';') + ";${Env:UserProfile}\.npm;"

# Local Go executables
$Env:Path = "${Env:Path}".TrimEnd(';') + ";${Env:GOPATH}\bin;"

# Local custom executables
$Env:Path = "${Env:Path}".TrimEnd(';') + ";${Env:UserProfile}\bin;"
