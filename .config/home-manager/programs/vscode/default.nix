{ pkgs, ... }:

let
  json = pkgs.formats.json { };
in
{
  programs.vscode = {
    enable = true;
    # Using FHS-wrapped VSCodium instead of the pure one, with gnome-libsecret
    # and libsecret to communicate with the OS keyring
    package =
      (pkgs.vscodium.override {
        commandLineArgs = "--password-store=gnome-libsecret";
      }).fhsWithPackages
        (ps: [ ps.libsecret ]);
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = import ./extensions.nix { inherit pkgs; };
      userSettings = import ./settings.nix { inherit pkgs; };
      keybindings = import ./keybindings.nix;
    };
  };
  # Configuration for Roo Code's MCP server settings
  xdg.configFile."VSCodium/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json" =
    {
      force = true;
      source = json.generate "mcp_settings.json" {
        mcpServers = {
          "brave-search" = {
            command = "${pkgs.nodejs}/bin/npx";
            args = [
              "-y"
              "@brave/brave-search-mcp-server"
              "--transport"
              "stdio"
            ];
            disabled = false;
            alwaysAllow = [ ];
            env = {
              "BRAVE_API_KEY" = "\${env:BRAVE_API_KEY}";
            };
          };
        };
      };
    };
}
