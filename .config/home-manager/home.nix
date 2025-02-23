{ pkgs, username, inputs, ... }:

{
  imports = [ inputs.polykey-cli.homeModules.default ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
    packages = with pkgs; [
      vscode 
      discord
    ];
  };
  programs = {
    home-manager.enable = true;
    polykey = {
      enable = true;
      passwordFilePath = "%h/.polykeypass";
      recoveryCodeOutPath = "%h/.polykeyrecovery";
    };
  };
}