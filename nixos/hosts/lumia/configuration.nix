{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/acme
    ../../modules/glances
    ../../modules/immich
    ../../modules/linkding
  ];

  nix.settings.trusted-users = ["@wheel"];

  boot.kernelParams = ["ip=dhcp"];
  boot.initrd.network = {
    enable = true;
    ssh = {
      enable = true;
      port = 2222;
      shell = "/bin/cryptsetup-askpass";
      authorizedKeys = config.users.users.dan.openssh.authorizedKeys.keys;
      hostKeys = ["/nix/persist/initrd/ssh_host_ed25519_key"];
    };
  };

  fileSystems."/mnt/restic" = {
    device = "nas.dnhrrs.xyz:/volume1/restic";
    fsType = "nfs";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lumia";

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  console.keyMap = "uk";

  users.mutableUsers = false;

  sops.age.sshKeyPaths = ["/nix/persist/etc/ssh/ssh_host_ed25519_key"];
  sops.secrets.dan-password = {
    sopsFile = ./secrets.yml;
    neededForUsers = true;
  };

  users.users.dan = {
    isNormalUser = true;
    extraGroups = ["wheel" "poddy"];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.dan-password.path;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4div1SWpMioi2ibOZy3/ww3tN8rdoNE5RLiy90s7leQsBhe8LzFVw8kn+oMVFIa/QBc8Iwt19j774OtG/wtfN3lNwO+s2N36ha34z722adfTB9LouEv0Af+sHvvrcVAMgNZ8Lqtevjy1VgLOx/LGMTi3pFhk7FfVFPwmYmPEXY+PjxPH8vALDgLMtTqt0o7OtuGI1ekXQ6V/7sXITiLVBzkGxmeYMOZZwNiVNNC0FdcFAopueZKzaejTLgmD/0Y1MGitDZSw+t0oAS2Rry152xSjcWaisdKJeO9F7r09rAr1oWwSttDAa99ddYcfv/gmkFz5kgr6uOPvPlp64gu5T"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkFBua9e2PT5pUZSi9fpRYznYepQBuNcTMj97gupNfB"
    ];
  };

  programs.zsh.enable = true;
  services.openssh.enable = true;

  services.caddy.enable = true;
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
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

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/containers"
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

  sops.secrets."services/restic/password" = {
    sopsFile = ./secrets.yml;
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
