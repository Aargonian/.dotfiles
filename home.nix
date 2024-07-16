{ username, pkgs, ... }:

{
  imports = [
    ./user/sh.nix
    ./user/git.nix
    ./user/packages.nix
    ./user/services.nix
    ./user/i3.nix
    ./user/neovim.nix
    ./user/hyprland.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.

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

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
