{ config, pkgs, ... }:

{
  home.packages = [ pkgs.ollama ];
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    port = 11434;
    acceleration = null;
  };
}
