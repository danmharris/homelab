{
  config,
  libs,
  pkgs,
  ...
}: {
  services.immich = {
    enable = true;
    port = 2283;
    host = "localhost";
    mediaLocation = "/var/lib/immich";
  };

  services.caddy.virtualHosts."immich.dnhrrs.xyz" = {
    useACMEHost = "dnhrrs.xyz";
    extraConfig = ''
      reverse_proxy http://${config.services.immich.host}:${toString config.services.immich.port}
    '';
  };

  environment.persistence."/nix/persist" = {
    directories = [
      {
        directory = config.services.immich.mediaLocation;
        user = "immich";
        group = "immich";
        mode = "0750";
      }
    ];
  };

  services.restic.backups.immich = {
    repository = "/mnt/restic/immich";
    initialize = true;
    passwordFile = config.sops.secrets."services/restic/password".path;
    paths = [
      config.services.immich.mediaLocation
    ];
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
}
