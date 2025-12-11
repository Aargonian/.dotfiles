{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.firefox = {
    enable = mkEnableOption "Firefox web browser";
  };

  config = mkIf config.custom.programs.firefox.enable {
    programs.firefox.enable = true;
  };
}
