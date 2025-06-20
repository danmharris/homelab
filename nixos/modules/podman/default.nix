{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.podman;
in {
  options.mySystem.podman.enable = lib.mkEnableOption "podman";

  config = lib.mkIf (cfg.enable) {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
    networking.firewall.interfaces.podman0.allowedUDPPorts = [53];
    users.users.poddy = {
      uid = 917;
      group = "poddy";
    };
    users.groups.poddy.gid = 917;

    users.users.dan.extraGroups = ["poddy"];

    environment.persistence."/nix/persist" = lib.mkIf (config.mySystem.impermanence.enable) {
      directories = [
        "/var/lib/containers"
      ];
    };
  };
}
