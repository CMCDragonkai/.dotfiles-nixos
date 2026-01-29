{
  mkSeedMutableFileActivation =
    { lib
    , pkgs
    , name
    , target
    , template
    , reset
    , warnOnDrift ? true
    , replaceSymlink ? true
    , backupOnReset ? true
    }:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      set -eu

      target=${lib.escapeShellArg target}
      template=${lib.escapeShellArg template}

      ${lib.optionalString replaceSymlink ''
        # If this file was previously managed by home.file/xdg.configFile it will
        # likely be a symlink into a Home Manager generation (and thus immutable).
        # Replace it with a real file so the application can edit it.
        if [ -L "$target" ]; then
          echo "home-manager: ${lib.escapeShellArg name} was a symlink; replacing with a writable file: $target"
          rm -f "$target"
        fi
      ''}

      if [ ! -e "$target" ]; then
        echo "home-manager: seeding ${lib.escapeShellArg name}: $target"
        ${pkgs.coreutils}/bin/install -Dm644 "$template" "$target"
        exit 0
      fi

      if ! ${pkgs.diffutils}/bin/cmp -s "$template" "$target"; then
        if [ "${if reset then "1" else "0"}" = "1" ]; then
          ${lib.optionalString backupOnReset ''
            ts=$(${pkgs.coreutils}/bin/date -u +%Y%m%dT%H%M%SZ)
            backup="$target.$ts.bak"
            echo "home-manager: ${lib.escapeShellArg name} differ; backing up to $backup and overwriting"
            ${pkgs.coreutils}/bin/cp -a "$target" "$backup"
          ''}
          ${lib.optionalString (!backupOnReset) ''
            echo "home-manager: ${lib.escapeShellArg name} differ; overwriting"
          ''}
          ${pkgs.coreutils}/bin/install -Dm644 "$template" "$target"
        else
          ${lib.optionalString warnOnDrift ''
            echo "home-manager: ${lib.escapeShellArg name} differ from template; leaving unchanged: $target"
          ''}
        fi
      fi
    '';
}

