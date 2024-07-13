{ pkgs, ... }:
{
  programs.hyprland.enable = true;
  /*
  home.packages = with pkgs; [
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-dropbox-plugin
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.xfce4-terminal
  ];

  home.file = {
    ".config/i3/config".source = ./i3config;
  };
  */
}
