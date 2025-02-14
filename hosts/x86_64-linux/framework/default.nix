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
          device = "/dev/disk/by-label/NixRoot";
          fsType = "btrfs";
        };

        "/boot" = {
          device = "/dev/disk/by-label/BootRoot";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        "/data" = {
          device = "/dev/disk/by-label/InternalData";
          fsType = "ntfs";
          options = [ "nofail,noatime,uid=1000,gid=100,fmask=0022,dmask=0022" ];
        };

        "/data/Portable" = {
          device = "/dev/disk/by-label/Portable";
          fsType = "ntfs";
          options = [ "nofail,noatime,uid=1000,gid=100,fmask=0022,dmask=0022" ];
        };

        "/data/LinuxData" = {
          device = "/dev/disk/by-label/LinuxData";
          fsType = "btrfs";
          options = [ "nofail,noatime,autodefrag" ];
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

      inputs.nixos-hardware.nixosModules.framework-16-7040-amd

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
