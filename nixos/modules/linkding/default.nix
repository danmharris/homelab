{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mySystem.linkding;
in {
  options.mySystem.linkding.enable = lib.mkEnableOption "linkding";

  config = lib.mkIf (cfg.enable) {
    sops.secrets."app/linkding/env" = {
      sopsFile = ./secrets.yml;
      owner = "poddy";
      group = "poddy";
      restartUnits = ["podman-linkding.service"];
    };

    virtualisation.oci-containers.containers.linkding = {
      image = "sissbruecker/linkding:1.39.1";
      user = "917:917";
      ports = ["127.0.0.1:9090:9090"];
      volumes = [
        "/var/lib/linkding:/etc/linkding/data:rw"
      ];
      environment = {
        LD_ENABLE_OIDC = "True";
        OIDC_OP_AUTHORIZATION_ENDPOINT = "https://auth.cluster.dnhrrs.xyz/application/o/authorize/";
        OIDC_OP_TOKEN_ENDPOINT = "https://auth.cluster.dnhrrs.xyz/application/o/token/";
        OIDC_OP_USER_ENDPOINT = "https://auth.cluster.dnhrrs.xyz/application/o/userinfo/";
        OIDC_OP_JWKS_ENDPOINT = "https://auth.cluster.dnhrrs.xyz/application/o/linkding/jwks/";
        OIDC_RP_CLIENT_ID = "8Ys4YcM9Y428wzcHwDm5Ve884acZdUOkZgfdE4IG";
      };
      environmentFiles = [config.sops.secrets."app/linkding/env".path];
    };

    services.caddy.virtualHosts."linkding.dnhrrs.xyz" = {
      useACMEHost = "dnhrrs.xyz";
      extraConfig = ''
        reverse_proxy http://127.0.0.1:9090
      '';
    };

    environment.persistence."/nix/persist" = {
      directories = [
        {
          directory = "/var/lib/linkding";
          user = "poddy";
          group = "poddy";
          mode = "0750";
        }
      ];
    };

    services.restic.backups.linkding = {
      repository = "/mnt/restic/linkding";
      initialize = true;
      passwordFile = config.sops.secrets."services/restic/password".path;
      paths = [
        "/var/lib/linkding/backup.zip"
      ];
      backupPrepareCommand = ''
        ${pkgs.podman}/bin/podman exec linkding python manage.py full_backup /etc/linkding/data/backup.zip
      '';
      backupCleanupCommand = ''
        rm -f /var/lib/linkding/backup.zip
      '';
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "30m";
      };
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
    };
  };
}
