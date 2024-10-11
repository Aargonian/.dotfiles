{ lib, config, pkgs, ... }:
{
  options.custom.programs.liferea.enable = lib.mkEnableOption "Liferea RSS Reader";

  config = lib.mkIf config.custom.programs.liferea.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        liferea
      ];
    };
  };
}
