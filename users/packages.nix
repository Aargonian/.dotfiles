{ lib, config, pkgs, pkgs-unstable, ... }:
{
  home-manager.users.${config.custom.username} = {
    home.packages = with pkgs; [
      firefox
      thunderbird
      nerdfonts
      ncspot
      calibre
      terminator
      ripgrep # Mostly for Neovim telescope
      tree
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-dropbox-plugin
      xfce.thunar-archive-plugin
      xfce.thunar-media-tags-plugin
      xfce.xfce4-terminal
      nodejs_22
      obsidian
      fzf # For neovim telescope plugin
      xclip # Neovim clipboard provider
      xsel # Neovim clipboard provider
      lf # Ranger-inspired explorer
      universal-ctags # Neovim TagBar
      python311Packages.pynvim
      yt-dlp
      ffmpeg
      discord
      spotify
      todoist-electron
      vlc
      zip
      unzip
      epubcheck
      transmission-qt
      libreoffice
      bitwarden-cli
      bitwarden-desktop

      # PDF Reader
      pkgs-unstable.xreader

      # Jetbrains IDEs
      jetbrains.rust-rover
      jetbrains.webstorm
      jetbrains.writerside
      jetbrains.pycharm-community-bin
      jetbrains.clion

      # To use qute-bitwarden
      keyutils
      rofi

      # Various apps I find useful
      hexchat
      pkgs-unstable.liferea
      gsmartcontrol
      jq
      pv
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    programs.qutebrowser = {
      enable = true;
      searchEngines = {
        DEFAULT = "https://www.google.com/search?hl=en&q={}";
      };
    };
  };
}
