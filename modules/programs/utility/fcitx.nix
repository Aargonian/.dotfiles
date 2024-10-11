{ lib, config, pkgs, ... }: with lib;
{
  options.custom.programs.fcitx.enable = mkEnableOption "An IME for Chinese and Japanese Input";

  config = mkIf config.custom.programs.fcitx.enable {
    # Japanese IME
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc
        fcitx5-nord
      ];
    };
  };
}
