{ lib, inputs, pkgs-unstable, system-name, config-path, profiles-path, ... }:
let
  flake_system = "desktop";
  username = "aargonian";
  hostname = "NytegearFramework";

  configuration = { lib, config, pkgs, options, ... }: {
    users.aargonian.enable = true;

    custom = {
      username = username;

      system = {
        audio.enable = true;
        bluetooth.enable = true;
        networking = {
          enable = true;
          hostname = hostname;
          vpn.enable = true;
        };
        # Enable Virtualbox
        virtualization.virtualbox.host = true;
      };

      services = {
        greetd.enable = true;
        lact.enable = true;
        power-profiles-daemon.enable = true;
      };

      programs = {
        # Package Sets
        audio.all = true;
        development.all = true;
        messaging.all = true;
        other.all = true;
        productivity.all = true;
        security.all = true;
        shell.all = true;
        utility.all = true;

        # Individual
        firefox.enable = true;
        steam.enable = true;
        xfce4-terminal.enable = true;
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/9e412de9-bef7-4747-9116-c01582fb22c1";
        fsType = "btrfs";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/1FA3-F2D7";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
    };

    swapDevices = [ ];
    nixpkgs.hostPlatform = system-name;

    # Add Raspberry Pi Server to Hosts
    networking.extraHosts = ''
      192.168.50.7 rpi
      192.168.50.1 router
    '';
  };
in
{
  ${flake_system} = lib.nixosSystem {
    system = system-name;
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;

      username = username;
      hostname = hostname;
    };
    modules = [
      config-path
      profiles-path
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        imports = [
          profiles-path
        ];
      }

      configuration
    ];
  };
}
