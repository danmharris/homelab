{
  config,
  lib,
  ...
}: let
  cfg = config.mySystem.impermanence;
in {
  options.mySystem.impermanence.enable = lib.mkEnableOption "impermanence";

  config = lib.mkIf (cfg.enable) {
    users.mutableUsers = false;

    sops.age.sshKeyPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];

    environment.persistence."/nix/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
      ];
      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
