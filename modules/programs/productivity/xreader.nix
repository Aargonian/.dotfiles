{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.xreader.enable = mkEnableOption "XReader PDF Reader";

  config = mkIf config.custom.programs.xreader.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        cinnamon.xreader
      ];
    };
  };
}
