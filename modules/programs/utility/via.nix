{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.via.enable = mkEnableOption "VIA QMK Configuration Utilities";

  config = mkIf config.custom.programs.via.enable {

    # Need chromium because firefox won't allow HID interfacing to configure the keyboard
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
      via
    ];
  };
}
