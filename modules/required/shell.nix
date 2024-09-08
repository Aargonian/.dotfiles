{ lib, pkgs, config, ... }:
{
  options.custom.shell = {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zsh;
      example = pkgs.bash;
      description = "Choose a preferred shell program";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      config.custom.shell.package

      # Common system and shell utilities
      vim
      wget
      curl
      file
      htop
      tree
      nmon
      du-dust
      udisks
      parted

      # To easily search Nixpkgs :)
      nix-search-cli
    ];

    programs.zsh.enable = true;
  };
}
