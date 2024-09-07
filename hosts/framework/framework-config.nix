# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, options, ... }:
{
  imports =
    [
      ./laptop-hardware-configuration.nix
      ../../system/user-setup.nix
      ../../system/networking.nix
      ../../system/services.nix
      ../../system/package-sets/essential.nix
      ../../system/package-sets/desktop-environment.nix
      ../../system/package-sets/steam.nix
      ../../system/package-sets/rust.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Ensure NTFS is supported
  boot.supportedFilesystems = [ "ntfs" ];

  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.11";
  nix.settings.experimental-features = "nix-command flakes";

  # Bad bad dirty hack to make generic linux binaries work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [ stdenv.cc.cc ] );

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
