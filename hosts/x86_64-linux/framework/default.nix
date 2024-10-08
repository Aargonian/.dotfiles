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
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd

      ({ lib, config, pkgs, options, ... }:
      {
        hardware.enableRedistributableFirmware = lib.mkDefault true;

        users.aargonian.enable = true;

        custom = {
          username = "aargonian";
          hostname = "NytegearFramework";

          desktop.enable = true;
          mullvad.enable = true;
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

          # AMD GPU Control
          lact
        ];

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

          # Mount the big data partition
          "/run/media/aargonian/InternalData" = {
            device = "/dev/disk/by-uuid/7b75839e-56c3-4e31-8d4e-a69a61cdc653";
            fsType = "btrfs";
          };

          # Mount Framework Portable SSD if Present (Usually in the left slot)
          "/run/media/aargonian/FrameworkPortable" = {
            device = "/dev/disk/by-uuid/203ECDA4274108EA";
            fsType = "ntfs";
            options = [ "nofail" "fmask=011" "dmask=000" ];
          };

          # Mount Temporary Framework SSD
          "/run/media/aargonian/FrameworkAuxillary" = {
            device = "/dev/disk/by-uuid/a0561ab4-8f9d-41f2-bdfc-e357660b8307";
            fsType = "btrfs";
            options = [ "nofail" ];
          };
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

        # Graphic Stuff
        hardware.opengl = {
          extraPackages = with pkgs; [ amdvlk ];
          extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
          enable = true;
          driSupport = true;
          driSupport32Bit = true;
        };

        # Control AMD GPU with Lact
        systemd.packages = with pkgs; [ lact ];
        systemd.services.lactd.wantedBy = [ "multi-user.target" ];

        # Add Raspberry Pi Server to Hosts
        networking.extraHosts = ''
          192.168.50.7 rpi
          192.168.50.1 router
        '';
      })
    ];
  };
}
