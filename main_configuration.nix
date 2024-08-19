# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, options, ... }:
{
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  imports =
    [ # Include the results of the hardware scan.
      ./system/user_setup.nix
      ./system/display.nix
      ./system/networking.nix
      ./system/system_packages.nix
      ./system/services.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest linux kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Ensure NTFS is supported
  boot.supportedFilesystems = [ "ntfs" ];

  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "23.11";
  nix.settings.experimental-features = "nix-command flakes";

  # Bad bad dirty hack to make generic linux binaries work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = options.programs.nix-ld.libraries.default ++ (with pkgs; [
    stdenv.cc.cc
    xorg.libX11
    xorg.libXcursor
    xorg.libxcb
    xorg.libXi
    libxkbcommon
  ]);
}
