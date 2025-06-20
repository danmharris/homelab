{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.trusted-users = ["@wheel"];

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

  sops.secrets.dan-password = {
    sopsFile = ./secrets.yml;
    neededForUsers = true;
  };

  users.users.dan = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.dan-password.path;

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4div1SWpMioi2ibOZy3/ww3tN8rdoNE5RLiy90s7leQsBhe8LzFVw8kn+oMVFIa/QBc8Iwt19j774OtG/wtfN3lNwO+s2N36ha34z722adfTB9LouEv0Af+sHvvrcVAMgNZ8Lqtevjy1VgLOx/LGMTi3pFhk7FfVFPwmYmPEXY+PjxPH8vALDgLMtTqt0o7OtuGI1ekXQ6V/7sXITiLVBzkGxmeYMOZZwNiVNNC0FdcFAopueZKzaejTLgmD/0Y1MGitDZSw+t0oAS2Rry152xSjcWaisdKJeO9F7r09rAr1oWwSttDAa99ddYcfv/gmkFz5kgr6uOPvPlp64gu5T"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkFBua9e2PT5pUZSi9fpRYznYepQBuNcTMj97gupNfB"
    ];
  };

  programs.zsh.enable = true;
  services.openssh.enable = true;

  mySystem = {
    acme.enable = true;
    glances.enable = true;
    immich.enable = true;
    linkding.enable = true;
    restic.enable = true;
    impermanence.enable = true;
    cryptroot.enable = true;
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
