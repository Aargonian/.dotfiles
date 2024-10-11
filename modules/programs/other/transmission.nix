{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.transmission.enable = mkEnableOption "Transmission Torrent Client";

  config = mkIf config.custom.programs.transmission.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        transmission-qt
      ];
    };
  };
}
