{ pkgs }:

let
  # 3 sets of vscode extensions
  compatible = pkgs.nix-vscode-extensions.forVSCodeVersion pkgs.vscodium.version;
  # Upstream nixpkgs
  nixpkgs = pkgs.vscode-extensions;
  # OpenVSX
  openvsx = compatible.open-vsx-release;
  # Marketplace
  marketplace = compatible.vscode-marketplace-release;
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
  openvsx.neo4j-extensions.neo4j-for-vscode
  nixpkgs.github.vscode-pull-request-github
  marketplace.briandooley.explorer-file-sizes
  marketplace.randomfractalsinc.vscode-vega-viewer
]
