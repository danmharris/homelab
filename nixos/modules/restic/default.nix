{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.restic;
in {
  options.mySystem.restic.enable = lib.mkEnableOption "restic";

  config = {
    fileSystems."/mnt/restic" = {
      device = "nas.dnhrrs.xyz:/volume1/restic";
      fsType = "nfs";
    };

    sops.secrets."services/restic/password" = {
      sopsFile = ./secrets.yml;
    };
  };
}
