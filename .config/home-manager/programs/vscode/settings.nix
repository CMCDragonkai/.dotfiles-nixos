{ pkgs }:

{
  # Updates
  "extensions.autoCheckUpdates" = false;
  "update.mode" = "none";

  # Language servers
  "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";

  # Editor
  "editor.fontFamily" = "Fira Code, DejaVu Sans Mono, monospace";
  "editor.fontLigatures" = true;
  "editor.fontSize" = 16;
  "editor.inlayHints.enabled" = "off";
  "editor.inlineSuggest.enabled" = true;
  "editor.lineNumbers" = "relative";
  "editor.minimap.enabled" = false;
  "editor.renderWhitespace" = "all";
  "editor.rulers" = [ 80 ];
  "editor.tokenColorCustomizations" = {
    "[*Dark*]" = {
      textMateRules = [
        {
          scope = "ref.matchtext";
          settings = {
            foreground = "#fff";
          };
        }
      ];
    };
    "[*Light*]" = {
      textMateRules = [
        {
          scope = "ref.matchtext";
          settings = {
            foreground = "#000";
          };
        }
      ];
    };
    textMateRules = [
      {
        scope = "keyword.other.dotenv";
        settings = {
          foreground = "#FF000000";
        };
      }
    ];
  };

  # Explorer
  "explorer.confirmDelete" = false;
  "explorer.confirmDragAndDrop" = false;

  # Terminal
  "terminal.integrated.tabs.enabled" = true;

  # Debug
  "debug.javascript.autoAttachFilter" = "onlyWithFlag";

  # Workbench
  "workbench.startupEditor" = "none";

  # Telemetry
  "redhat.telemetry.enabled" = false;
  "telemetry.telemetryLevel" = "crash";

  # Git
  "git.openRepositoryInParentFolders" = "never";

  # File associations
  "files.associations" = {
    ".env" = "dotenv";
    ".env*" = "dotenv";
    "cstddef" = "cpp";
    "cstdint" = "cpp";
    "cstdlib" = "cpp";
    "flake.lock" = "json";
    "iostream" = "cpp";
    "ranges" = "cpp";
    "string" = "cpp";
  };

  # JS/TS
  "js/ts.implicitProjectConfig.experimentalDecorators" = true;

  # Dotenv
  "dotenv.enableAutocloaking" = true;

  # Markdown preview
  "markdown.math.enabled" = true;

  # Vim
  "vim.easymotion" = true;
  "vim.normalModeKeyBindingsNonRecursive" = [
    {
      before = [ "<space>" ];
      commands = [ "vspacecode.space" ];
    }
    {
      before = [ "," ];
      commands = [
        "vspacecode.space"
        {
          command = "whichkey.triggerKey";
          args = "m";
        }
      ];
    }
  ];
  "vim.useSystemClipboard" = false;
  "vim.visualModeKeyBindingsNonRecursive" = [
    {
      before = [ "<space>" ];
      commands = [ "vspacecode.space" ];
    }
    {
      before = [ "," ];
      commands = [
        "vspacecode.space"
        {
          command = "whichkey.triggerKey";
          args = "m";
        }
      ];
    }
  ];

  # vspacecode overrides
  "vspacecode.bindingOverrides" = [
    {
      keys = "a";
      name = "AI Commands";
      type = "bindings";
      bindings = [
        {
          key = "n";
          name = "Roo: New Task";
          type = "command";
          command = "roo-cline.plusButtonClicked";
        }
        {
          key = "l";
          name = "Roo: Add selection → Context + Focus";
          type = "commands";
          commands = [
            "roo-cline.addToContext"
            "roo-cline.focusInput"
          ];
        }
        {
          key = "a";
          name = "Roo: Add selection to context";
          type = "command";
          command = "roo-cline.addToContext";
        }
        {
          key = "s";
          name = "Roo: Focus input";
          type = "command";
          command = "roo-cline.focusInput";
        }
        {
          key = "o";
          name = "Roo: Open in new tab";
          type = "command";
          command = "roo-cline.openInNewTab";
        }
        {
          key = "e";
          name = "Roo: Explain selected code";
          type = "command";
          command = "roo-cline.explainCode";
        }
        {
          key = "f";
          name = "Roo: Fix selected code";
          type = "command";
          command = "roo-cline.fixCode";
        }
        {
          key = "i";
          name = "Roo: Improve selected code";
          type = "command";
          command = "roo-cline.improveCode";
        }
        {
          key = "t";
          name = "Roo: Terminal → Add to context";
          type = "command";
          command = "roo-cline.terminalAddToContext";
        }
        {
          key = "T";
          name = "Roo: Terminal → Explain command";
          type = "command";
          command = "roo-cline.terminalExplainCommand";
        }
        {
          key = "F";
          name = "Roo: Terminal → Fix command";
          type = "command";
          command = "roo-cline.terminalFixCommand";
        }
        {
          key = "p";
          name = "Roo: Toggle auto-approve";
          type = "command";
          command = "roo-cline.toggleAutoApprove";
        }
        {
          key = "r";
          name = "Roo: Accept input / primary action";
          type = "command";
          command = "roo-cline.acceptInput";
        }
      ];
    }
  ];

  # Roo Code settings
  # - enableCodeActions is true by default in Roo Code; kept explicit here.
  # - autoImportSettingsPath stays empty to avoid accidentally importing an
  #   exported config JSON that may contain API keys in plaintext.
  # - allowedCommands list of commands allowed for roo to run
  "roo-cline.enableCodeActions" = true;
  "roo-cline.autoImportSettingsPath" = "";
  "roo-cline.allowedCommands" = [
    "git log"
    "git diff"
    "git show"
  ];
  "roo-cline.deniedCommands" = [ ];

  # Explorer File Sizes
  "explorerFileSizes.badgeMode" = "subtle";
  "explorerFileSizes.enableFolderSizes" = false;
}
