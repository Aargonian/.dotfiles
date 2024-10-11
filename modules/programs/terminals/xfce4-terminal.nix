{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.xfce4-terminal.enable = mkEnableOption "XFCE4 Terminal Emulator";

  config = mkIf config.custom.programs.xfce4-terminal.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        xfce.xfce4-terminal
      ];
    };
  };
}
