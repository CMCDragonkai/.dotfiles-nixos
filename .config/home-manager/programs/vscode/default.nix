{ config, lib, pkgs, mutableStateLib, ... }:

let
  json = pkgs.formats.json { };

  # Roo Code MCP settings is mutable state owned by VSCodium/Roo. We seed a
  # template into place (real file, not store symlink) and optionally reset.
  rooMcpSettingsTarget =
    "${config.xdg.configHome}/VSCodium/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json";

  rooMcpSettingsTemplate = json.generate "mcp_settings.roo.template.json" {
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
          # Note: must escape `${...}` from Nix interpolation.
          BRAVE_API_KEY = "\${env:BRAVE_API_KEY}";
        };
      };
    };
  };
in
{
  options.programs.vscode.reset = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Enable a "reset" activation mode for mutable VSCodium-owned state files.
      When true, activation may back up and overwrite mutable files from
      templates (for example Roo MCP settings).
    '';
  };

  config = {
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

    # Seed Roo Code's MCP server settings as a mutable file (not a store symlink).
    home.activation.vscodeSeedRooMcpSettings = mutableStateLib.mkSeedMutableFileActivation {
      inherit lib pkgs;
      name = "VSCodium Roo MCP settings";
      target = rooMcpSettingsTarget;
      template = rooMcpSettingsTemplate;
      reset = config.programs.vscode.reset;
    };
  };
}
