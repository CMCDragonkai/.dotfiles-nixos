# This is for the current user only and for all console hosts

$Env:Path = "${Env:Path}".TrimEnd(';') + ";${Env:UserProfile}\bin;"
