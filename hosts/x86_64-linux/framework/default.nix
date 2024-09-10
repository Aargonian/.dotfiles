{ lib, inputs, pkgs-unstable, system-name, config-path, ... }:
{
  framework = lib.nixosSystem {
    system = system-name;
    specialArgs = {
      inherit inputs;
      inherit pkgs-unstable;

      username = "aargonian";
      hostname = "NytegearFramework";
    };
    modules = [
      config-path
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd

      {
        hardware.enableRedistributableFirmware = lib.mkDefault true;

        custom = {
          username = "aargonian";
          hostname = "NytegearFramework";

          desktop.enable = true;
          #displaylink.enable = true;
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

        services.power-profiles-daemon.enable = true;

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/9e412de9-bef7-4747-9116-c01582fb22c1";
          fsType = "btrfs";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/1FA3-F2D7";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        # Mount the big data partition
        fileSystems."/run/media/aargonian/SteamSamsung" = {
          device = "/dev/disk/by-uuid/3428B3C628B38580";
          fsType = "ntfs-3g";
          options = [ "rw" "user" "nofail"];
        };

        swapDevices = [ ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ "amdgpu" ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        # Mediatek Driver fix for Framework
        hardware.wirelessRegulatoryDatabase = true;
        boot.extraModprobeConfig = ''
          options cfg80211 ieee80211_regdom="US"
        '';

        #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
      }
    ];
  };
}
