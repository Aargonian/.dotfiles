{
  description = "Aaron's Personal Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      virtual_system = "aarch64-linux";
      desktop_system = "x86_64-linux";
      laptop_system = "x86_64-linux";

      pkgs-desktop = import nixpkgs {
        system = desktop_system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      pkgs-desktop-unstable = import nixpkgs-unstable {
        system = desktop_system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      pkgs-virtual = import nixpkgs {
        system = virtual_system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
      pkgs-virtual-unstable = import nixpkgs-unstable {
        system = virtual_system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      username = "aargonian";
      hostname = "NixosPersonal";
    in {

    nixosConfigurations = {
      virtual = lib.nixosSystem {
        system = virtual_system;
        modules = [
          ./virtual_config.nix
        ];
        specialArgs = {
          inherit username;
          inherit hostname;
          pkgs-unstable = pkgs-virtual-unstable;
        };
      };
      desktop = lib.nixosSystem {
        system = desktop_system;
        modules = [
          ./desktop_config.nix
        ];
        specialArgs = {
          inherit username;
          inherit hostname;
          pkgs-unstable = pkgs-desktop-unstable;
        };
      };
      laptop = lib.nixosSystem {
        system = laptop_system;
        modules = [
          ./laptop_config.nix
        ];
        specialArgs = {
          inherit username;
          inherit hostname;
          pkgs-unstable = pkgs-desktop-unstable;
        };
      };
    };

    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-desktop;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit username;
          pkgs-unstable = pkgs-desktop-unstable;
        };
      };
    };

  };
}
