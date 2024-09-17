{ lib, inputs, pkgs-unstable, system-name, config-path, users-path, ... }:
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
      users-path
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        imports = [
          users-path
        ];
      }
      # Disabled for now as currently framework-laptop-kmod breaks with kernel 6.11
      #inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      ({ pkgs, options, ... }:
      {
        hardware.enableRedistributableFirmware = lib.mkDefault true;

        users.aargonian.enable = true;

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

        # Install virtualbox
        virtualisation.virtualbox.host.enable = true;
        users.extraGroups.vboxusers.members = [
          "aargonian"
        ];

        environment.systemPackages = with pkgs; [
          tigervnc
          liferea
          gsmartcontrol
        ];

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
        fileSystems."/run/media/aargonian/InternalData" = {
          device = "/dev/disk/by-uuid/7b75839e-56c3-4e31-8d4e-a69a61cdc653";
          fsType = "btrfs";
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
      })
    ];
  };
}
