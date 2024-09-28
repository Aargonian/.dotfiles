{ lib, inputs, pkgs-unstable, system-name, config-path, users-path, ... }:
{
  desktop = lib.nixosSystem {
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
      ({ pkgs, config, options, modulesPath, ... }:
      {
        imports = [ 
          (modulesPath + "/installer/scan/not-detected.nix")
        ];
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
        ];

        fileSystems."/" =
        { 
          device = "/dev/disk/by-uuid/169a918f-011b-4f32-9c64-e62605b596aa";
          fsType = "btrfs";
        };

        fileSystems."/boot" =
        { 
          device = "/dev/disk/by-uuid/EDE0-E7FD";
          fsType = "vfat";
          options = [ "fmask=0022" "dmask=0022" ];
        };

        swapDevices = [ ];

        boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        # Mediatek Driver fix for Framework
        hardware.wirelessRegulatoryDatabase = true;
        boot.extraModprobeConfig = ''
          options cfg80211 ieee80211_regdom="US"
        '';

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      })
    ];
  };
}
