{
  config,
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.users.nixos = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4div1SWpMioi2ibOZy3/ww3tN8rdoNE5RLiy90s7leQsBhe8LzFVw8kn+oMVFIa/QBc8Iwt19j774OtG/wtfN3lNwO+s2N36ha34z722adfTB9LouEv0Af+sHvvrcVAMgNZ8Lqtevjy1VgLOx/LGMTi3pFhk7FfVFPwmYmPEXY+PjxPH8vALDgLMtTqt0o7OtuGI1ekXQ6V/7sXITiLVBzkGxmeYMOZZwNiVNNC0FdcFAopueZKzaejTLgmD/0Y1MGitDZSw+t0oAS2Rry152xSjcWaisdKJeO9F7r09rAr1oWwSttDAa99ddYcfv/gmkFz5kgr6uOPvPlp64gu5T"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkFBua9e2PT5pUZSi9fpRYznYepQBuNcTMj97gupNfB"
    ];
  };
}
