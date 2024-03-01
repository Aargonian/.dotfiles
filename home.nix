{ config, pkgs, pkgs-unstable, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.packages = [
    pkgs.neovim-nightly
  ];

  home.file = {
    "~/.config/i3/config".source = configs/i3config;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      vim = "nvim";
    };
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
  };

  # Gitignore
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
      "notes"
    ];
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
