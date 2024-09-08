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
  };

  # QMK Support for the Framework 16 Keyboard
  hardware.keyboard.qmk.enable = true;

  environment.systemPackages = with pkgs; [
    ungoogled-chromium # To use Framework's VIA interface
    power-profiles-daemon
    fprintd # To use Framework's fingerprint reader
  ];

  services.power-profiles-daemon.enable = true;

  services.logind = {
    powerKey = "hibernate";
    powerKeyLongPress = "poweroff";
    lidSwitch = "hibernate";
    lidSwitchExternalPower = "ignore";
  };

  # Setup Fprintd for framework laptop
  # Note: Remember to run fprind-enroll on first setup
  services.fprintd.enable = true;

  # Mount the big data partition
  fileSystems."/run/media/aargonian/SteamSamsung" = {
    device = "/dev/disk/by-uuid/3428B3C628B38580";
    fsType = "ntfs-3g";
    options = [ "rw" "user" "nofail"];
  };
}
