{ lib, config, pkgs, ... }:
let
  username = "aargonian";
in
{
  imports = [
    ./directories.nix
  ];

  options.users.aargonian = {
    enable = lib.mkEnableOption "Enable aargonian";
  };

  config = lib.mkIf config.users.aargonian.enable {
    custom = {
      username = username;

      fonts.useNerdFont = true;

      programs.git = {
        enable = true;
        name = "Aaron Gorodetzky";
        email = "aaron@nytework.com";
      };

      system.display.windowManagers = {
        hyprland.enable = true;
      };

      programs.neovim.enable = true;
    };

    home-manager.users.${username} = lib.mkIf config.users.aargonian.enable {

      home.username = username;
      home.sessionVariables = {
        EDITOR = "nvim";
      };

      home.stateVersion = "23.11"; # Please read the comment before changing.
    };
  };
}
