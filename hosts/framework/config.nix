# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:
{
  imports = [
      ./laptop-hardware-configuration.nix
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

  # Mount the big data partition
  fileSystems."/run/media/aargonian/SteamSamsung" = {
    device = "/dev/disk/by-uuid/3428B3C628B38580";
    fsType = "ntfs-3g";
    options = [ "rw" "user" "nofail"];
  };
}
