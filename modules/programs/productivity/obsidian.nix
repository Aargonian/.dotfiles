{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.obsidian.enable = mkEnableOption "Obsidian notes";

  config = mkIf config.custom.programs.obsidian.enable {
    nixpkgs.config.allowUnfree = true;
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        obsidian
      ];

    };
  };
}
