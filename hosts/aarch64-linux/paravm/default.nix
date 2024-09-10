{ lib, inputs, pkgs-unstable, system-name, config-path, ... }:
{
  # Parallels Virtual Machine Configuration
  paravm = lib.nixosSystem {
    system = system-name;
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;

      username = "aargonian";
      hostname = "NytegearVirtual";
    };
    modules = [
      config-path
      {
        custom = {
          username = "aargonian";
          hostname = "NytegearVirtual";

          desktop.enable = false;
          displaylink.enable = false;
          development = {
            common.enable = true;
            rust.enable = true;
            python.enable = true;
          };
        };

        # Use the systemd-boot EFI boot loader.
        boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" "sr_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ ];
        boot.extraModulePackages = [ ];

        fileSystems."/" =
          { device = "/dev/disk/by-uuid/37ebd5b5-7490-4d98-90ef-2d50cf0d2198";
            fsType = "btrfs";
          };

        fileSystems."/boot" =
          { device = "/dev/disk/by-uuid/459F-2619";
            fsType = "vfat";
          };

        swapDevices = [ ];

        nixpkgs.hostPlatform = system-name;
        hardware.parallels.enable = true;
      }
    ];
  };
}
