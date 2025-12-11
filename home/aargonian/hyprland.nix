{ lib, pkgs, ... }: with lib;
{
  home.packages = with pkgs; [
    hyprland
    anyrun
    waybar
    xwayland

    # Wallpaper
    hyprpaper

    # Runner
    dmenu

    # Utilities
    wl-clipboard
    wl-screenrec
    wlr-randr
    wev           # Input Event Reader (Determine what keyboard scancodes are etc.)

    # We need a polkit agent
    lxqt.lxqt-policykit

    # Screensharing
    xdg-desktop-portal-hyprland
    nwg-displays
  ];
}
