{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.hexchat.enable = mkEnableOption "Hexchat IRC Client";

  config = mkIf config.custom.programs.hexchat.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        hexchat
      ];
    };
  };
}
