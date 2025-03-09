{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = with pkgs; mkShell {
          packages = [
            fluxcd
            kubectl
            talosctl
            sops
            age
            ansible
          ];

          shellHook = ''
            . <(flux completion zsh)
            . <(kubectl completion zsh)
          '';
        };
      }
    );
}
