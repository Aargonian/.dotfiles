{ lib, pkgs, config, ...}:
{
  options.custom.desktop.programs.via = {
    enable = lib.mkEnableOption "VIA QMK Configuration Utilities";
  };

  config = lib.mkIf config.custom.desktop.programs.via.enable {

    # Need chromium because firefox won't allow HID interfacing to configure the keyboard
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
      via
    ];
  };
}
