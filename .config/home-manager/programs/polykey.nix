{ ... }:

{
  programs.polykey = {
    enable = true;
    passwordFilePath = "%h/.polykeypass";
    recoveryCodeOutPath = "%h/.polykeyrecovery";
  };
}