{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.glances;
in {
  options.mySystem.glances.enable = lib.mkEnableOption "glances";

  config = lib.mkIf (cfg.enable) {
    services.glances = {
      enable = true;
      openFirewall = true;
      port = 61208;
    };
  };
}
