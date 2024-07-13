{ inputs, anyrun, pkgs, system, ... }:
{
  imports = [inputs.anyrun.homeManagerModules.default];

  home.packages = with pkgs; [
    dunst
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    #plugins = [
    #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    #];
    settings = {
      "$mod" = "CONTROL";
      bind = [
        "$mod, p, exec, anyrun"
        "$mod, t, exec, xfce4-terminal"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to} workspace {1..10}
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );

      monitor = [
        "eDP-2,2560x1600@165,auto,1" # Main Laptop Screen
        "DVI-I-2,preferred,auto-left,1"
        "DVI-I-1,preferred,auto-right,1"
        ",preferred,auto,1"
      ];
    };
  };

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        inputs.anyrun.packages.${pkgs.system}.applications
        inputs.anyrun.packages.${pkgs.system}.rink
        inputs.anyrun.packages.${pkgs.system}.shell
        inputs.anyrun.packages.${pkgs.system}.kidex
      ];
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = true;
      maxEntries = null;
    };
  };
}
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
