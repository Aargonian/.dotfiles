{ lib, config, pkgs, ... }: with lib;
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-mozc
      fcitx5-nord
    ];
  };

  programs.thunar = {
    enable = mkDefault true;
    plugins = with pkgs.xfce; mkDefault [
      thunar-volman
      thunar-dropbox-plugin
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  programs.firefox.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.naturalScrolling = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Tumbler for thumbnail support in Thunar
  services.tumbler.enable = mkDefault true;

  # GVFS for Mount, Trash, and other filesystem tools
  services.gvfs = {
    enable = mkDefault true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };


  environment.systemPackages = with pkgs; [
    thunderbird
    bash
    samba
    pa_applet
    cifs-utils
    pv
    tree
    yt-dlp
    ffmpeg
    zip
    unzip
    lsof
    epubcheck
    gsmartcontrol
    gparted
    tmux
    nil         # Nix Language Server
    jq          # JSON Utility
    nodejs_24   # NodeJS Support
    git
    cmakeMinimal
    gcc
    gnumake
    automake
    sqlite
    python3
    rustup

    # Basic Necessities
    vim
    wget
    curl
    file
    htop
    tree
    nmon
    dust
    udisks
    parted

    # Audio
    pa_applet
    pavucontrol
    spotify
    vlc

    # To easily search Nixpkgs :)
    nix-search-cli
  ]; 
  #  ++ [
  #  pkgs-unstable.ncspot
  #];

  programs.zsh.enable = true;

  # TODO: Make a nix shell to solve this issue
  # Bad bad dirty hack to make generic linux binaries work
#   programs.nix-ld.enable = true;
#   programs.nix-ld.libraries = config.programs.nix-ld.libraries.default ++ (with pkgs; [
#     stdenv.cc.cc
#     xorg.libX11
#     xorg.libXcursor
#     xorg.libxcb
#     xorg.libXi
#     libxkbcommon
#   ]);

  # Samba Fix
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

  # Xfconf is needed to save thunar's preferences in case XFCE doesn't exist
  # TODO: Eventually pull this into its own module and use home manager for xfconf settings!
  programs.xfconf.enable = mkDefault true;

  # Enable gnome-keyring for passkey storage
  services.gnome.gnome-keyring.enable = true;

  # Enable graphical frontend for gnome-keyring
  programs.seahorse.enable = true;

  nixpkgs.config.allowUnfree = true;

  home-manager.users.aargonian = {
    home.packages = with pkgs; [
      discord
      libreoffice
      hexchat
      calibre
      kitty
      obsidian
      todoist-electron
      libsecret # So we can store git credentials
      bitwarden-cli
      bitwarden-desktop
      foliate
      liferea
      transmission_4-qt
    ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    programs.git = {
      enable = true;
      userName = "Aaron Gorodetzky";
      userEmail = "aaron@nytegear.com";
      ignores = [
        "*.swp"
      ];

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store --file ~/.git-credentials";
      };

    };
  };
}
