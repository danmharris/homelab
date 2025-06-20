{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    utils.url = "github:numtide/flake-utils";
    sops-nix.url = "github:Mic92/sops-nix";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    utils,
    sops-nix,
    impermanence,
    ...
  }:
    {
      nixosConfigurations = {
        lumia = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            impermanence.nixosModules.impermanence
            sops-nix.nixosModules.sops
            ./nixos/modules
            ./nixos/hosts/lumia/configuration.nix
          ];
          specialArgs = {inherit inputs;};
        };

        iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./nixos/hosts/iso.nix
          ];
          specialArgs = {inherit inputs;};
        };
      };
    }
    // utils.lib.eachDefaultSystem (
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
