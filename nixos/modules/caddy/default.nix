{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.caddy;
in {
  options.mySystem.caddy.enable = lib.mkEnableOption "caddy";

  config = lib.mkIf (cfg.enable) {
    mySystem.acme.enable = true;

    services.caddy.enable = true;
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
