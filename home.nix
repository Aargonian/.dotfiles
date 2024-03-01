{ username, ... }:

{
  imports = [
    ./user/sh.nix
    ./user/git.nix
    ./user/packages.nix
    ./user/services.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.file = {
    ".config/i3/config".source = user/i3config;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
