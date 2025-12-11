{ lib, config, ... }: with lib;
{
  options.custom.theme = {
    enable = mkEnableOption "Theming support";

    default = mkOption {
      default = "dark";
      example = "light";
      description = ''The desktop theming to use, if theming is enabled.'';
      type = types.oneOf [ "dark" "light" ];
    };
  };

  config = mkIf config.custom.theme.enable {
    # QT Dark Theming.
    qt = mkIf config.qt.enable {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    home-manager.users.${config.custom.username} = {
      dconf.settings = {
        "org/gnome/desktop/background" = {
          picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome.gnome-themes-extra;
        };
      };
    };
  };
}
