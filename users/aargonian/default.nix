{ lib, config, pkgs, ... }:
let
  username = "aargonian";
in
{
  options.users.aargonian = {
    enable = lib.mkEnableOption "Enable aargonian";
  };

  config = lib.mkIf config.users.aargonian.enable {
    custom.username = username;
    custom = {
      git = {
        enable = true;
        name = "Aaron Gorodetzky";
        email = "aaron@nytework.com";
      };

      hyprland.enable = true;
      waybar.enable = true;
      anyrun.enable = true;
      neovim.enable = true;
    };

    home-manager.users.${username} = lib.mkIf config.users.aargonian.enable {
      imports = [
        ./packages.nix
        ./sh.nix
      ];

      home.username = username;
      home.homeDirectory = "/home/${username}";

      home.sessionVariables = {
        EDITOR = "nvim";
      };

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

      home.stateVersion = "23.11"; # Please read the comment before changing.
    };
  };
}
