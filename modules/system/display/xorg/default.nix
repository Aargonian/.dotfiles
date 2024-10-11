{ lib, config, pkgs, ... }: with lib;
{
  options.custom.system.display.xorg = {
    enable = mkEnableOption "X11 Windowing System";
  };

  config = mkIf config.custom.system.display.enable {

    services.xserver = {
      enable = true;

      # Disable most display managers by default
      displayManager = {
        gdm.enable = mkDefault false;
        lightdm = {
          enable = mkDefault false;
          greeters.gtk.enable = mkDefault false;
          greeters.slick.enable = mkDefault false;
        };
      };

      xkb = {
        layout = mkDefault "us";
        options = mkDefault "eurosign:e,ctrl:nocaps";
      };
    };

    environment.systemPackages = with pkgs; [
      xorg.setxkbmap
      xorg.xrandr

      arandr
      dmenu
      feh
      dconf
    ];
  };
}
