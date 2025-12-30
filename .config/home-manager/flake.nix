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
    in {
      homeConfigurations.${username} =
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs-matrix-private.nixpkgs;
          extraSpecialArgs = { inherit inputs system username; };
          modules = [ ./home.nix ];
        };
    };
}
