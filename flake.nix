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
    anyrun,
    ...
    } @ inputs:
    let
      aarch64-system = "aarch64-linux";
      x86_64-system = "x86_64-linux";
      default-username = "aargonian";

      vm-username = default-username;
      rpi-username = default-username;
      desktop-username = default-username;
      framework-username = default-username;

      vm-hostname = "NytegearVM";
      rpi-hostname = "NytegearRPI";
      desktop-hostname = "NytegearDesktop";
      framework-hostname = "NytegearLaptop";

      vm-id = "${vm-username}@${vm-hostname}";
      rpi-id = "${rpi-username}@${rpi-hostname}";
      desktop-id = "${desktop-username}@${desktop-hostname}";
      framework-id = "${framework-username}@${framework-hostname}";

      lib = nixpkgs.lib;

      unfreeConfig = {
        allowUnfree = true;
    allowUnfreePredicate = (_: true);
      };

      x86_64-pkgs = import nixpkgs {
        system = x86_64-system;
        config = unfreeConfig;
      };

      x86_64-pkgs-unstable = import nixpkgs-unstable {
        system = x86_64-system;
    config = unfreeConfig;
      };

      aarch64-pkgs = import nixpkgs {
        system = aarch64-system;
    config = unfreeConfig;
      };

      aarch64-pkgs-unstable = import nixpkgs-unstable {
        system = aarch64-system;
    config = unfreeConfig;
      };
    in {

    nixosConfigurations = {

      vm = lib.nixosSystem {
        system = aarch64-system;
        modules = [
          ./virtual-config.nix
        ];
        specialArgs = {
          username = vm-username;
          hostname = vm-hostname;
          inherit inputs;
          pkgs-unstable = aarch64-pkgs-unstable;
        };
      };

      rpi = lib.nixosSystem {
        system = aarch64-system;
    modules = [
      ./rpi-config.nix
      nixos-hardware.nixosModules.raspberry-pi-4
    ];
    specialArgs = {
      username = rpi-username;
      hostname = rpi-hostname;
      inherit inputs;
      pkgs-unstable = aarch64-pkgs-unstable;
    };
      };

      desktop = lib.nixosSystem {
        system = x86_64-system;
        modules = [
          ./desktop-config.nix
        ];
        specialArgs = {
          username = desktop-username;
          hostname = desktop-hostname;
          inherit inputs;
          pkgs-unstable = x86_64-pkgs-unstable;
        };
      };

      framework = lib.nixosSystem {
        system = x86_64-system;
        modules = [
          ./hosts/laptop-config.nix
          nixos-hardware.nixosModules.framework-16-7040-amd
        ];
        specialArgs = {
          username = framework-username;
          hostname = framework-hostname;
          inherit inputs;
          pkgs-unstable = x86_64-pkgs-unstable;
        };
      };

    };

    homeConfigurations = {
      ${vm-id} = home-manager.lib.homeManagerConfiguration {
        pkgs = aarch64-pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          username = vm-username;
          inherit inputs;
          inherit anyrun;
          pkgs-unstable = aarch64-pkgs-unstable;
        };
      };

      "${rpi-id}" = home-manager.lib.homeManagerConfiguration {
        pkgs = aarch64-pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          username = rpi-username;
          inherit inputs;
          inherit anyrun;
          pkgs-unstable = aarch64-pkgs-unstable;
        };
      };

      "${desktop-id}" = home-manager.lib.homeManagerConfiguration {
        pkgs = x86_64-pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          username = desktop-username;
          inherit inputs;
          inherit anyrun;
          pkgs-unstable = x86_64-pkgs-unstable;
        };
      };

      "${framework-id}" = home-manager.lib.homeManagerConfiguration {
        pkgs = x86_64-pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          username = framework-username;
          inherit inputs;
          inherit anyrun;
          pkgs-unstable = x86_64-pkgs-unstable;
        };
      };
    };
  };
}
