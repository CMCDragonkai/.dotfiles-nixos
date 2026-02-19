{ pkgs, username, inputs, ... }:

{
  imports = [ 
    inputs.polykey-cli.homeModules.default 
    ./packages.nix
    ./files.nix
    ./programs
    ./services
  ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "dcraw-9.28.0"
      "googleearth-pro-7.3.6.10201"
    ];
  };
  nixpkgs.overlays = [
    (self: super: {
      pkgsMaster = import inputs.nixpkgsMaster {
        system = self.stdenv.hostPlatform.system;
        config = super.config;
      };
    })
    inputs.nix-vscode-extensions.overlays.default
  ];
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };
  programs = {
    home-manager.enable = true;
  };
}
