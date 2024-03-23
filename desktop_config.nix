# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, options, ... }:
{
  imports =
    [
      ./desktop-hardware-configuration.nix
      ./system/user_setup.nix
      ./system/networking.nix
      ./system/services.nix
      ./system/package_sets/essential.nix
      ./system/package_sets/desktop_environment.nix
      ./system/package_sets/steam.nix
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
}
