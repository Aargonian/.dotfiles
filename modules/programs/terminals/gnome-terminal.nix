{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.gnome-terminal.enable = mkEnableOption "Gnome3 Terminal Emulator";

  config = mkIf config.custom.programs.gnome-terminal.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        gnome.gnome-terminal
      ];
    };
  };
}
