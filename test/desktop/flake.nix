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
      unfreeConfig = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };

      systems = {
        x86_64 = {
          name = "x86_64-linux";
          pkgs = import nixpkgs {
            system = name;
            config = unfreeConfig;
          };
          pkgs-unstable = import nixpkgs-unstable {
            system = name;
            config = unfreeConfig;
          };
        };

        aarch64-linux = {
          name = "aarch64-linux";
          pkgs = import nixpkgs {
            system = name;
            config = unfreeConfig;
          };

          pkgs-unstable = import nixpkgs-unstable {
            system = name;
            config = unfreeConfig;
          };
        };
      };

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

    in {

    nixosConfigurations = {

      import ./hosts/framework inputs;

      vm = lib.nixosSystem {
        system = systems.aarch64-linux.name;
        modules = [
          ./virtual-config.nix
        ];
        specialArgs = {
          inherit inputs;
          username = vm-username;
          hostname = vm-hostname;
          pkgs-unstable = systems.aarch64-linux.pkgs-unstable;
        };
      };

      rpi = lib.nixosSystem {
        system = systems.aarch64-linux.name;
          modules = [
            ./rpi-config.nix
            nixos-hardware.nixosModules.raspberry-pi-4
          ];
          specialArgs = {
            inherit inputs;
            username = rpi-username;
            hostname = rpi-hostname;
            pkgs-unstable = system.aarch64-linux.pkgs-unstable;
          };
      };

      desktop = lib.nixosSystem {
        system = systems.x86_64-linux.name;
        modules = [
          ./desktop-config.nix
        ];
        specialArgs = {
          inherit inputs;
          username = desktop-username;
          hostname = desktop-hostname;
          pkgs-unstable = systems.x86_64-linux.pkgs-unstable;
        };
      };

      import ./hosts/framework inputs;
    };

    homeConfigurations = {
      ${vm-id} = home-manager.lib.homeManagerConfiguration {
        pkgs = systems.aarch64-linux.pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit anyrun;
          username = vm-username;
          pkgs-unstable = systems.aarch64-linux.pkgs-unstable;
        };
      };

      "${rpi-id}" = home-manager.lib.homeManagerConfiguration {
        pkgs = systems.aarch64-linux.pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit anyrun;
          username = rpi-username;
          pkgs-unstable = systems.aarch64-linux.pkgs-unstable;
        };
      };

      "${desktop-id}" = home-manager.lib.homeManagerConfiguration {
        pkgs = systems.x86_64-linux.pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit anyrun;
          username = desktop-username;
          pkgs-unstable = systems.x86_64-linux.pkgs-unstable;
        };
      };

      "${framework-id}" = home-manager.lib.homeManagerConfiguration {
        pkgs = systems.x86_64-linux.pkgs;
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit anyrun;
          username = framework-username;
          pkgs-unstable = systems.x86_64-linux.pkgs-unstable;
        };
      };
    };
  };
}
