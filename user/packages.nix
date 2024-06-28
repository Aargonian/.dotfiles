{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim-nightly
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
    nodejs_21
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
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}
