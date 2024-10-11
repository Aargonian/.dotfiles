{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.tigervnc.enable = mkEnableOption "TigerVNC Client";

  config = mkIf config.custom.programs.tigervnc.enable {
    environment.systemPackages = with pkgs; [
      tigervnc
    ];
  };
}
