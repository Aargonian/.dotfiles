{ lib, config, pkgs, pkgs-unstable, ... }: with lib;
{
  options.custom.programs = {
      audio = {
        all = mkEnableOption "All Audio Programs";
        cli = mkEnableOption "CLI Audio Applications";
        gui = mkEnableOption "GUI Audio Applications";
        util = mkEnableOption "Audio Utility Applications";
      };
    };

  config = mkIf config.custom.programs.audio.all {
    environment.systemPackages = with pkgs; [
      pa_applet
      pavucontrol
      spotify
      vlc
    ] ++ [
      pkgs-unstable.ncspot
    ];
  };
}
