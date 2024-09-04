{ pkgs, options, ... }:
{
  imports =
    [
      ./virtual-hardware-configuration.nix
      ./system/user-setup.nix
      ./system/networking.nix
      ./system/services.nix
      ./system/package-sets/essential.nix
      ./system/package-sets/desktop-environment.nix
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
