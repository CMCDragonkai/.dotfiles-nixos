{ pkgs, ...}:

{
  extensions =
    let
      ext = pkgs.nix-vscode-extensions;
      openvsx = ext.open-vsx-release;
      marketplace = ext.vscode-marketplace-release;
    in [
      openvsx.vscodevim.vim
      openvsx.vspacecode.vspacecode
      openvsx.vspacecode.whichkey
      openvsx.bodil.file-browser
      openvsx.jacobdufault.fuzzy-search
      openvsx.editorconfig.editorconfig
      openvsx.dotenv.dotenvx-vscode
      openvsx.waderyan.gitblame
      openvsx.kahole.magit
      openvsx.rooveterinaryinc.roo-cline
      openvsx.detachhead.basedpyright
      openvsx.jnoortheen.nix-ide
      openvsx.llvm-vs-code-extensions.vscode-clangd
      openvsx.redhat.vscode-yaml
      openvsx.tamasfe.even-better-toml
      openvsx.jock.svg
      openvsx.bradlc.vscode-tailwindcss
      openvsx.unifiedjs.vscode-mdx
      openvsx.github.vscode-github-actions
      openvsx.janisdd.vscode-edit-csv
      openvsx.mathematic.vscode-pdf
      openvsx.rust-lang.rust-analyzer
      openvsx.haskell.haskell
      openvsx.golang.go
      openvsx.zxh404.vscode-proto3
    ];
  userSettings = {
    "extensions.autoCheckUpdates" = false;
    "update.mode" = "none";
    "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
    "vim.easymotion" = true;
    "vim.useSystemClipboard" = false;
    "vim.normalModeKeyBindingsNonRecursive" = [
      {
        before = [ "<space>" ];
        commands = [ "vspacecode.space" ];
      }
      {
        before = [ "," ];
        commands = [
          "vspacecode.space"
          { command = "whichkey.triggerKey"; args = "m"; }
        ];
      }
    ];
    "vim.visualModeKeyBindingsNonRecursive" = [
      {
        before = [ "<space>" ];
        commands = [ "vspacecode.space" ];
      }
      {
        before = [ "," ];
        commands = [
          "vspacecode.space"
          { command = "whichkey.triggerKey"; args = "m"; }
        ];
      }
    ];
    "editor.fontFamily" = "Fira Code, DejaVu Sans Mono, monospace";
    "editor.fontLigatures" = true;
    "editor.minimap.enabled" = false;
    "editor.lineNumbers" = "relative";
    "js/ts.implicitProjectConfig.experimentalDecorators" = true;
    "editor.fontSize" = 16;
    "explorer.confirmDragAndDrop" = false;
    "editor.renderWhitespace" = "all";
    "terminal.integrated.tabs.enabled" = true;
    "debug.javascript.autoAttachFilter" = "onlyWithFlag";
    "workbench.startupEditor" = "none";
    "telemetry.telemetryLevel" = "crash";
    "files.associations" = {
      ".env" = "dotenv";
      ".env*" = "dotenv";
      "string" = "cpp";
      "cstdint" = "cpp";
      "flake.lock" = "json";
      "iostream" = "cpp";
      "cstdlib" = "cpp";
      "cstddef" = "cpp";
      "ranges" = "cpp";
    };
    "redhat.telemetry.enabled" = false;
    "editor.inlineSuggest.enabled" = true;
    "editor.inlayHints.enabled" = "off";
    "explorer.confirmDelete" = false;
    "git.openRepositoryInParentFolders" = "never";
    "editor.tokenColorCustomizations" = {
      "[*Light*]" = {
        textMateRules = [
          {
            scope = "ref.matchtext";
            settings = { foreground = "#000"; };
          }
        ];
      };
      "[*Dark*]" = {
        textMateRules = [
          {
            scope = "ref.matchtext";
            settings = { foreground = "#fff"; };
          }
        ];
      };
      textMateRules = [
        {
          scope = "keyword.other.dotenv";
          settings = { foreground = "#FF000000"; };
        }
      ];
    };
    "editor.rulers" = [ 80 ];
    "dotenv.enableAutocloaking" = true;
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
            commands = [ "roo-cline.addToContext" "roo-cline.focusInput" ];
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
    # Roo Code settings (safe defaults; no API keys in Nix)
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
  };
  keybindings = [
    {
      key = "space";
      command = "vspacecode.space";
      when = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
    }
    {
      key = "space";
      command = "vspacecode.space";
      when = "sideBarFocus && !inputFocus && !whichkeyActive";
    }
    # Vim / Magit tweaks
    {
      key = "tab";
      command = "extension.vim_tab";
      when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
    }
    {
      key = "tab";
      command = "-extension.vim_tab";
      when = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
    }
    {
      key = "x";
      command = "magit.discard-at-point";
      when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    { key = "k"; command = "-magit.discard-at-point"; }
    {
      key = "-";
      command = "magit.reverse-at-point";
      when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    { key = "v"; command = "-magit.reverse-at-point"; }
    {
      key = "shift+-";
      command = "magit.reverting";
      when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    { key = "shift+v"; command = "-magit.reverting"; }
    {
      key = "shift+o";
      command = "magit.resetting";
      when = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
    }
    { key = "shift+x"; command = "-magit.resetting"; }
    { key = "x"; command = "-magit.reset-mixed"; }
    { key = "ctrl+u x"; command = "-magit.reset-hard"; }
    { key = "y"; command = "-magit.show-refs"; }
    {
      key = "y";
      command = "vspacecode.showMagitRefMenu";
      when = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
    }
    # Quick open navigation
    { key = "ctrl+j"; command = "workbench.action.quickOpenSelectNext"; when = "inQuickOpen"; }
    { key = "ctrl+k"; command = "workbench.action.quickOpenSelectPrevious"; when = "inQuickOpen"; }
    # Suggestions widget
    {
      key = "ctrl+j"; command = "selectNextSuggestion";
      when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
      key = "ctrl+k"; command = "selectPrevSuggestion";
      when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    {
      key = "ctrl+l"; command = "acceptSelectedSuggestion";
      when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
    }
    # Parameter hints
    {
      key = "ctrl+j"; command = "showNextParameterHint";
      when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    {
      key = "ctrl+k"; command = "showPrevParameterHint";
      when = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
    }
    # File browser (extension)
    { key = "ctrl+h"; command = "file-browser.stepOut"; when = "inFileBrowser"; }
    { key = "ctrl+l"; command = "file-browser.stepIn"; when = "inFileBrowser"; }
    # Code action menu
    { key = "ctrl+j"; command = "selectNextCodeAction"; when = "codeActionMenuVisible"; }
    { key = "ctrl+k"; command = "selectPrevCodeAction"; when = "codeActionMenuVisible"; }
    { key = "ctrl+l"; command = "acceptSelectedCodeAction"; when = "codeActionMenuVisible"; }
    # Roo
    {
      key = "ctrl+enter";
      command = "roo-cline.acceptInput";
      when = "view == roo-cline.SidebarProvider || activeWebviewPanelId == roo-cline.TabPanelProvider";
    }
  ];
}
