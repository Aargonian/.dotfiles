{ username, ... }:

{
  imports = [
    ./user/sh.nix
    ./user/git.nix
    ./user/packages.nix
    ./user/services.nix
    ./user/i3.nix
    ./user/neovim.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
