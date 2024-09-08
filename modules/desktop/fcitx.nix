{lib, pkgs, config, ...}:
{
  options.custom.ime = {
    enable = lib.mkEnableOption "An IME for Chinese and Japanese Input";
  };

  config = lib.mkIf config.custom.ime.enable {
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
