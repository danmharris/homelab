{
  config,
  lib,
  pkgs,
  ...
}: {
  services.glances = {
    enable = true;
    openFirewall = true;
    port = 61208;
  };
}
