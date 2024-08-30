{ pkgs, ... }:
{
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

    # Jetbrains IDEs
    jetbrains.rust-rover
    jetbrains.webstorm
    jetbrains.writerside
    jetbrains.pycharm-community-bin
    jetbrains.clion

    # Bitwarden and Qutebrowser
    bitwarden-cli

    # To use qute-bitwarden
    keyutils
    rofi
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  programs.qutebrowser = {
    enable = true;
#    greasemonkey = [
#      (pkgs.fetchurl {
#        url = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/8ddaef35d0c05e226a9018647a2f2874456435f9/misc/userscripts/qute-bitwarden";
#        sha256 = "1j84gbyzbzhyn5xn5h4d2mx01fynvhyvp3lfmsp7f29fiw8zrv30";
#      })
#    ];
    searchEngines = {
      DEFAULT = "https://www.google.com/search?hl=en&q={}";
    };
  };
}
