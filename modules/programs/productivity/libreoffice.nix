{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.libreoffice.enable = mkEnableOption "Libreoffice Office Suite";

  config = mkIf config.custom.programs.libreoffice.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        libreoffice
      ];
    };
  };
}
