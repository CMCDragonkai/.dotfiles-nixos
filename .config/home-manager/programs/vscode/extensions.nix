{ pkgs }:

let
  ext = pkgs.nix-vscode-extensions;
  openvsx = ext.open-vsx-release;
  marketplace = ext.vscode-marketplace-release;
in
[
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
  openvsx.mkhl.direnv
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
  openvsx.github.vscode-pull-request-github
  marketplace.briandooley.explorer-file-sizes
  marketplace.randomfractalsinc.vscode-vega-viewer
]
