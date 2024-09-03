{
  description = "Aaron's Personal Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";


    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
#    hyprland,
    anyrun,
    ...
    } @ inputs:
    let
      lib = nixpkgs.lib;
      virtual_system = "aarch64-linux";
      rpi-system = "aarch64-linux";
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
      pkgs-virtual-unstable = import nixpkgs-unstable {
        system = virtual_system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      pkgs-rpi = import nixpkgs {
        system = rpi-system;
        config = {
          allowUnfree = true;
	  allowUnfreePredicate = (_: true);
        };
      };

      pkgs-rpi-unstable = import nixpkgs-unstable {
        system = rpi-system;
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
          inherit inputs;
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
          inherit inputs;
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
          inherit inputs;
          pkgs-unstable = pkgs-desktop-unstable;
        };
      };

      rpi = lib.nixosSystem {
        system = rpi-system;
	modules = [
	  ./rpi-config.nix
	  nixos-hardware.nixosModules.raspberry-pi-4
	];
	specialArgs = {
	  inherit username;
	  inherit hostname;
	  inherit inputs;
	  pkgs-unstable = pkgs-rpi-unstable;
	};
      };
    };

    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-desktop;
        modules = [
#          hyprland.homeManagerModules.default
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit username;
          inherit inputs;
          inherit anyrun;
          pkgs-unstable = pkgs-desktop-unstable;
        };
      };
    };

  };
}
