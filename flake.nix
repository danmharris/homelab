{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
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

          EDITOR = "nvim";
        };
      }
    );
}
