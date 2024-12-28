{ lib, inputs, pkgs-unstable, system-name, config-path, profiles-path, ... }:
let
  username = "aargonian";
  hostname = "NytegearFramework";

  configuration = { lib, config, pkgs, options, ... }: {
    options.custom.hostname = "NytegearFramework";
    config = {
      users.aargonian.enable = true;

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/32231aaa-78be-4203-ab2d-3590d33438b7";
          fsType = "btrfs";
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/1FA3-F2D7";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        "/data" = {
          device = "/dev/disk/by-label/InternalData";
          fsType = "ntfs";
          options = [ "nofail,noatime,uid=1000,gid=100,fmask=0022,dmask=0022" ];
        };
      };

      swapDevices = [ ];

      boot = {
        initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "thunderbolt"
          "usb_storage"
          "usbhid"
          "sd_mod"
        ];

        extraModulePackages = [ ];
        extraModprobeConfig = ''options cfg80211 ieee80211_regdom="US"'';
      };

      hardware = {
        # Mediatek Driver fix for Framework
        wirelessRegulatoryDatabase = true;
        cpu.amd.updateMicrocode = true;
        enableRedistributableFirmware = true;
      };

      nixpkgs.hostPlatform = system-name;
    };
  };
in
{
  framework = lib.nixosSystem {
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

#     inputs.nixos-hardware.nixosModules.framework-16-7040-amd

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
