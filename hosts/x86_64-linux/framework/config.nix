# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ lib, modulesPath, ... }:
{
  imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
  ];

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

  # QMK Support for the Framework 16 Keyboard
  hardware.keyboard.qmk.enable = true;

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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  # Mediatek Driver fix for Framework
  hardware.wirelessRegulatoryDatabase = true;
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="US"
  '';

  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  #hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
}
