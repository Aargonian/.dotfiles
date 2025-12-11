{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.calibre.enable = mkEnableOption "Calibre eBook Library Manager";

  config = mkIf config.custom.programs.calibre.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        calibre
      ];
    };
  };
}
