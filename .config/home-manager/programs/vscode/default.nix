{ config, lib, pkgs, mutableStateLib, ... }:

let
  json = pkgs.formats.json { };

  # Roo Code MCP settings is mutable state owned by VSCodium/Roo. We seed a
  # template into place (real file, not store symlink) and optionally reset.
  rooMcpSettingsTarget =
    "${config.xdg.configHome}/VSCodium/User/globalStorage/rooveterinaryinc.roo-cline/settings/mcp_settings.json";

  rooMcpSettingsTemplate = json.generate "mcp_settings.roo.template.json" {
    mcpServers = {
      # Brave Search MCP relies on npx running a node program
      # This isn't the most secure, but nix package of it doesn't exist
      # Furthermore systemd-run could be used to isolate and pull it, but it's a pain to debug
      "brave-search" = {
        command = lib.getExe' pkgs.nodejs "npx";
        args = [
          "-y"
          "@brave/brave-search-mcp-server@2.0.72"
          "--transport"
          "stdio"
        ];
        disabled = false;
        alwaysAllow = [ ];
        env = {
          # Use the Brave API key with Data for AI subscription
          # Note: must escape `${...}` from Nix interpolation.
          BRAVE_API_KEY = "\${env:BRAVE_API_KEY}";
        };
      };
      # Fetch URL MCP
      # This automatically converts web pages to markdown
      "fetch" = {
        command = lib.getExe' pkgs.uv "uvx";
        args = [
          "--from" "mcp-server-fetch==2025.4.7"
          "mcp-server-fetch"
          # Common UA
          "--user-agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36'"
        ];
        disabled = false;
        alwaysAllow = [ ];
        env = { };
      };
      # GitHub's official MCP server (stdio, nixpkgs)
      "github" = {
        command = lib.getExe pkgs.github-mcp-server;
        args = [
          "stdio"
          "--read-only"
          "--toolsets"
          "default"
        ];
        disabled = false;
        alwaysAllow = [ ];
        env = {
          # GitHub MCP server expects this name. :contentReference[oaicite:2]{index=2}
          GITHUB_PERSONAL_ACCESS_TOKEN = "\${env:GITHUB_PERSONAL_ACCESS_TOKEN}";
        };
      };
      "playwright" = {
        command = lib.getExe pkgs.playwright-mcp;
        args = [
          "--headless"
          "--browser" "chrome"
          "--executable-path" (lib.getExe pkgs.brave)
          "--user-data-dir" "${config.xdg.stateHome}/roo/playwright/brave-profile"
        ];
        disabled = false;
        alwaysAllow = [ ];
        env = { };
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
