{ lib, config, ...}:
{
  options.custom.desktop = {
    enable = lib.mkEnableOption "X11 Windowing System and Related Utilities";
  };

  config = lib.mkIf config.custom.desktop.enable {
    # Enable X11
    services.xserver = {
      enable = true;

      displayManager = {
        startx.enable = lib.mkDefault true;
        gdm.enable = lib.mkDefault false;
        lightdm = {
          enable = lib.mkDefault false;
          greeters.gtk.enable = lib.mkDefault false;
          greeters.slick.enable = lib.mkDefault false;
        };
      };

      xkb = {
        layout = lib.mkDefault "us";
        options = lib.mkDefault "eurosign:e,ctrl:nocaps";
      };

      desktopManager = {
        cinnamon.enable = lib.mkDefault true;
        xfce.enable = lib.mkDefault false;
      };
    };

    services.displayManager = {
        sddm.enable = false;
        defaultSession = "plasma";
    };

    # QT Dark Theming.
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    # Enable various services by default
    custom = {
      sound.enable = lib.mkDefault true;
      printing.enable = lib.mkDefault true;
      touchpad.enable = lib.mkDefault true;
      keyring.enable = lib.mkDefault true;
      browser.enable = lib.mkDefault true;
      ime.enable = lib.mkDefault true;
      desktop.programs = {
        steam.enable = lib.mkDefault true;
        thunderbird.enable = lib.mkDefault true;
        thunar.enable = lib.mkDefault true;
      };
    };
  };
}
