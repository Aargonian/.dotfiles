{ lib, pkgs, config, ... }:
{
  options.custom.shell = {
    editor = lib.mkPackageOption {
      default = pkgs.vim;
      example = pkgs.neovim;
      description = "Choose a default shell editor";
    };

    package = lib.mkPackageOption {
      default = pkgs.zsh;
      example = pkgs.bash;
      description = "Choose a preferred shell program";
    };
  }

  config = {
    environment.systemPackages = with pkgs; [
      config.custom.shell.editor
      config.custom.shell.package

      vi # Always install vi as a backup editor

      # Common system and shell utilities
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
  };
}
