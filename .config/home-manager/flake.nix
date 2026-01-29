{
  inputs = {
    # Need nixpkgsMaster for proprietary packages (use `master` to always load from the tip)
    nixpkgsMaster.url = "github:NixOS/nixpkgs/master";
    # Using Matrix AI's private package set
    nixpkgs-matrix-private = {
      type = "indirect";
      id = "nixpkgs-matrix-private";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-matrix-private/nixpkgs-matrix/nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-matrix-private/nixpkgs-matrix/nixpkgs";
    };
    polykey-cli.url = "github:MatrixAI/Polykey-CLI";
  };
  outputs = { nixpkgs-matrix-private, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "cmcdragonkai";

      mkHome = extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-matrix-private.nixpkgs;
          extraSpecialArgs = {
            inherit inputs system username;
            mutableStateLib = import ./lib/mutable-state.nix;
          };
          modules = [ ./home.nix ] ++ extraModules;
        };
    in {
      homeConfigurations.${username} = mkHome [ ];
      # "Reset" profile: opt-in, explicit activation that may overwrite mutable app-owned state.
      homeConfigurations."${username}-reset" = mkHome [
        ({ ... }: {
          programs.vscode.reset = true;
        })
      ];
    };
}
