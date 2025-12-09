{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.shell.common.all = mkEnableOption "All shell utility programs.";

  config = mkIf config.custom.programs.shell.common.all {
    environment.systemPackages = with pkgs; [
      # Common system and shell utilities
      vim
      wget
      curl
      file
      htop
      tree
      nmon
      dust
      udisks
      parted

      # To easily search Nixpkgs :)
      nix-search-cli
    ];
  };
}
