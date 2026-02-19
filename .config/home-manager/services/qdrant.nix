{ config, pkgs, ... }:

let
  qdrantConfig = "${config.xdg.configHome}/qdrant/config.yaml";
  storageDir   = "${config.xdg.dataHome}/qdrant/storage";
  snapshotsDir = "${config.xdg.dataHome}/qdrant/snapshots";
in
{
  home.packages = [ pkgs.qdrant ];

  xdg.configFile."qdrant/config.yaml".text = ''
    log_level: INFO

    storage:
      storage_path: ${storageDir}
      snapshots_path: ${snapshotsDir}

    service:
      host: 127.0.0.1
      http_port: 6333
      grpc_port: null
      enable_cors: false

    telemetry_disabled: true
  '';

  systemd.user.services.qdrant = {
    Unit = {
      Description = "Qdrant vector database (user)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${storageDir} ${snapshotsDir}";
      ExecStart = "${pkgs.qdrant}/bin/qdrant --config-path ${qdrantConfig}";
      Restart = "on-failure";
      RestartSec = 2;

      # Optional but usually helpful for DB-ish processes
      LimitNOFILE = 1048576;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
