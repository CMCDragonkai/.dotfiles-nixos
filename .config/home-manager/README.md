# Home Manager

This is a flake-based Home Manager configuration.

## Normal switch

This repo is wired so plain `home-manager switch` evaluates the default output [`homeConfigurations.${username}`](flake.nix:32).

If you want to be explicit (or run it from another working directory), run:

```bash
home-manager switch --flake /home/cmcdragonkai/.config/home-manager#cmcdragonkai
```

## Reset switch (overwrite mutable app-owned state)

Some application/extension configuration is intentionally treated as *mutable state* (not store-symlinked) and is only seeded by activation; the file can then be modified by the application.

When you want Home Manager to back up + overwrite such mutable files from their templates, use the reset output [`homeConfigurations."${username}-reset"`](flake.nix:34):

```bash
# from repo root
home-manager switch --flake .#cmcdragonkai-reset

# or from anywhere
home-manager switch --flake /home/cmcdragonkai/.config/home-manager#cmcdragonkai-reset
```

The reset output flips [`programs.vscode.reset`](programs/vscode/default.nix:65) which is consulted by the mutable-state helper [`mutableStateLib.mkSeedMutableFileActivation()`](lib/mutable-state.nix:2).

## Mutable-state helper

For seeding app-owned files (seed-if-missing, warn on drift, optional reset), modules can use [`mutableStateLib.mkSeedMutableFileActivation()`](lib/mutable-state.nix:2), which is passed to modules via [`extraSpecialArgs`](flake.nix:28).
