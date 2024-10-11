{ lib, config, pkgs, ...}: with lib;
{
  options.custom.programs.utility.applets.all = mkEnableOption "All utility applets";

  config = mkIf config.custom.programs.utility.applets.all {
    custom.system = {
      audio.enable = true;
      display.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pa_applet
    ];
  };
}
