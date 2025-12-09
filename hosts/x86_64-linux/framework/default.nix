{ lib, inputs, pkgs-unstable, system-name, config-path, profiles-path, ... }:
let
  username = "aargonian";
  hostname = "NytegearFramework";

  configuration = { lib, config, pkgs, options, ... }: {
    options.custom.hostname = "NytegearFramework";
    config = {
      users.aargonian.enable = true;

      boot = {
        initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "thunderbolt"
          "usb_storage"
          "usbhid"
          "sd_mod"
        ];

        supportedFilesystems = [ "zfs" ];
        zfs.devNodes = "/dev/disk/by-id";

        extraModulePackages = [ ];
        extraModprobeConfig = ''options cfg80211 ieee80211_regdom="US"'';
      };

      hardware = {
        # Mediatek Driver fix for Framework
        wirelessRegulatoryDatabase = true;
        cpu.amd.updateMicrocode = true;
        enableRedistributableFirmware = true;
      };

      # Required for ZFS
      networking.hostId = "deadbeef";

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

      inputs.disko.nixosModules.disko
      ./disko.nix

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
