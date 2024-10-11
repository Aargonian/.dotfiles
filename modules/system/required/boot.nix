{ pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest linux kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Ensure NTFS is supported
  boot.supportedFilesystems = [ "ntfs" ];
}
