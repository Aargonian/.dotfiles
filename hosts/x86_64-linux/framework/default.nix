{ lib, inputs, pkgs-unstable, system-name, config-path, users-path, ... }:
let
  username = "aargonian";
  hostname = "NytegearFramework";

  configuration = { lib, config, pkgs, options, ... }: {
    users.aargonian.enable = true;

    custom = {
      username = username;

      system = {
        audio.enable = true;
        bluetooth.enable = true;
        filesystem.gvfs.enable = true;
        networking = {
          enable = true;
          hostname = hostname;
          vpn.enable = true;
        };

        display.enable = true;
        display.desktopManagers.cinnamon.enable = true;
        display.windowManagers.i3.enable = true;

        # Enable Virtualbox
        virtualization.virtualbox.host = true;
      };

      services = {
        avahi.enable = true;
        greetd.enable = true;
        lact.enable = false;
        power-profiles-daemon.enable = true;
      };

      servers = {
        ssh.enable = true;
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
	device = "/dev/disk/by-uuid/32231aaa-78be-4203-ab2d-3590d33438b7";
        fsType = "btrfs";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/1FA3-F2D7";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };

      # Mount the big data partition
      "/media/Data" = {
        device = "/dev/disk/by-uuid/7b75839e-56c3-4e31-8d4e-a69a61cdc653";
        fsType = "btrfs";
        options = [ "nofail" ];
      };

      # Mount Framework Portable SSD if Present (Usually in the left slot)
#     "/media/Work" = {
#       device = "/dev/disk/by-uuid/203ECDA4274108EA";
#       fsType = "ntfs";
#       options = [ "nofail" "uid=1000" "gid=100" "fmask=133" "dmask=022" ];
#     };

#     # Mount Temporary Framework SSD
#     "/media/Inbox" = {
#       device = "/dev/disk/by-uuid/11CA8534042ADA73";
#       fsType = "ntfs";
#       options = [ "nofail" "uid=1000" "gid=100" "fmask=133" "dmask=022" ];
#     };
    };

    swapDevices = [ ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
    #boot.initrd.kernelModules = [ "amdgpu" ];
    #boot.kernelModules = [ "amdgpu" ];
    boot.extraModulePackages = [ ];

    # Mediatek Driver fix for Framework
    hardware.wirelessRegulatoryDatabase = true;
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="US"
    '';

    nixpkgs.hostPlatform = system-name;
    hardware.cpu.amd.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;

    # Graphic Stuff
#   hardware.opengl = {
#     extraPackages = with pkgs; [ amdvlk ];
#     extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
#     enable = true;
#     driSupport = true;
#     driSupport32Bit = true;
#   };

    # Add Raspberry Pi Server to Hosts
    networking.extraHosts = ''
      192.168.50.7 rpi
      192.168.50.1 router
    '';
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
      users-path

#     inputs.nixos-hardware.nixosModules.framework-16-7040-amd

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        imports = [
          users-path
        ];
      }

      configuration
    ];
  };
}
