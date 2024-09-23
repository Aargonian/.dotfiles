{ lib, config, pkgs, ... }:
let
  username = "aargonian";
  home = "/home/${username}";

  dataDirRelative   = "/Data";
  localDataRelative = "${dataDirRelative}/LocalData";
  appDataRelative   = "${localDataRelative}/AppData";
  trashRelative     = "${localDataRelative}/Trash";
  scriptsRelative   = "${localDataRelative}/Scripts";
  configsRelative   = "${appDataRelative}/Config";
  cacheRelative     = "${appDataRelative}/Cache";

  dataDir   = "${home}${dataDirRelative}";
  localData = "${home}${localDataRelative}";
  appData   = "${home}${appDataRelative}";
  trash     = "${home}${trashRelative}";
  scripts   = "${home}${scriptsRelative}";
  configs   = "${home}${configsRelative}";
  cache     = "${home}${cacheRelative}";
in
{
  options.users.aargonian = {
    enable = lib.mkEnableOption "Enable aargonian";
  };

  config = lib.mkIf config.users.aargonian.enable {
    custom = {
      username = username;

      git = {
        enable = true;
        name = "Aaron Gorodetzky";
        email = "aaron@nytework.com";
      };

      hyprland.enable = true;
      waybar.enable = true;
      anyrun.enable = true;
      neovim.enable = true;

      # Use Data Directory Layout
      useHomeDataDir = true;

      dataDirPath = dataDir;
      localData = localData;
      appData   = appData;
      trash     = trash;
      scripts   = scripts;
      configs   = configs;
      cache     = cache;

      dataDirRelative   = dataDirRelative;
      localDataRelative = localDataRelative;
      appDataRelative   = appDataRelative;
      trashRelative     = trashRelative;
      scriptsRelative   = scriptsRelative;
      configsRelative   = configsRelative;
      cacheRelative     = cacheRelative;
    };

    home-manager.users.${username} = lib.mkIf config.users.aargonian.enable {

      home.username = username;
      home.homeDirectory = home;

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
