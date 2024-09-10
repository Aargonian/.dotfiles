{ lib, inputs, pkgs-unstable, system-name, config-path, ... }:
{
  desktop = lib.nixosSystem {
    system = system-name;
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;

      username = "aargonian";
      hostname = "NytegearDesktop";
    };
    modules = [
      config-path
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      {
        custom = {
          username = "aargonian";
          hostname = "NytegearDesktop";
          desktop.enable = true;
          development = {
            common.enable = true;
            rust.enable = true;
            python.enable = true;
          };

          greetd.enable = true;
          audio.pipewire.enable = true;

          # Enable Framework Fingerprint Reader
          # Note: Remember to run fprind-enroll on first setup
          services = {
            fingerprint.enable = false;
          };
        };

        # Enable Firmware Updates for Framework 16
        services.fwupd.enable = true;

        fileSystems."/" =
          { device = "/dev/disk/by-uuid/1cf03095-bc5f-4f4e-b466-ad5631a6d3af";
            fsType = "btrfs";
          };

        fileSystems."/boot" =
          { device = "/dev/disk/by-uuid/2F2E-6AF3";
            fsType = "vfat";
          };

        swapDevices = [ ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        nixpkgs.hostPlatform = system-name;
        hardware.enableRedistributableFirmware = lib.mkDefault true;
        hardware.cpu.amd.updateMicrocode = lib.mkdDefault true;
      }
    ];
  };
}
