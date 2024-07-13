{
  description = "Aaron's Personal Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides split workspace behavior across monitors
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    hyprland,
    anyrun,
    split-monitor-workspaces,
    ...
    } @ inputs:
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
          inherit inputs;
          pkgs-unstable = pkgs-desktop-unstable;
        };
      };
    };

    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs-desktop;
        modules = [
          hyprland.homeManagerModules.default
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
