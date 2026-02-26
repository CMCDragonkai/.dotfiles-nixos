{ config, pkgs, ... }:

let
  configDir = "${config.xdg.configHome}/litellm";
  configFile = "${configDir}/config.yaml";
  secretNamespace = "litellm";
  pythonPackages = pkgs.python3Packages;
  # The litellm has proxy dependencies
  litellm = pythonPackages.litellm.overridePythonAttrs (old: {
    propagatedBuildInputs =
      (old.propagatedBuildInputs or [ ]) ++ pythonPackages.litellm.optional-dependencies.proxy;
  });
  # Wrap the litellm to authenticate with credentials
  litellmWrapped = pkgs.symlinkJoin {
    name = "litellm-authenticated";
    paths = [ litellm ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/litellm \
        --run 'export OPENAI_API_KEY="$(<"$CREDENTIALS_DIRECTORY/${secretNamespace}.openai_api_key")"'
    '';
  };
in
{
  home.packages = [ litellm ];

  xdg.configFile."litellm/config.yaml".source = ./config.yaml;

  systemd.user.services.litellm = {
    Unit = {
      Description = "LiteLLM Proxy (user)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      # Enables loading proxy hooks
      WorkingDirectory = configDir;
      Environment = [ "PYTHONPATH=${configDir}" ];
      # Loads it from $XDG_CONFIG_HOME/credstore.encrypted
      ImportCredential = [ "${secretNamespace}.*" ];
      PrivateMounts = true;
      ExecStart = ''
        ${litellmWrapped}/bin/litellm \
          --config ${configFile} \
          --host 127.0.0.1 \
          --port 4000 \
          --telemetry False
      '';
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
