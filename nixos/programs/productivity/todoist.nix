{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.todoist.enable = mkEnableOption "Todoist Task Manager";

  config = mkIf config.custom.programs.todoist.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        todoist-electron
      ];
    };
  };
}
