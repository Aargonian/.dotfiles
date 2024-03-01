{
  description = "Aaron's Personal Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
      username = "aargonian";
      hostname = "NixosPersonal";
    in {

    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
        specialArgs = {
          inherit username;
          inherit hostname;
          inherit pkgs-unstable;
        };
      };
    };
    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ({
            nixpkgs.overlays = overlays;
          })
        ];
        extraSpecialArgs = {
          inherit username;
          inherit pkgs-unstable;
        };
      };
    };
  };
}
