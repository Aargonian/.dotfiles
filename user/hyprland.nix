{ inputs, anyrun, pkgs, system, ... }:
{
  imports = [innputs.anyrun.homeManagerModules.default];

  wayland.windowManager.hyprland = {
    enable = true;
    #plugins = [
    #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    #];
    settings = {
      "$mod" = "CONTROL";
      bind = [
        "$mod, p, exec, dmenu_run"
        ", Print, exec, grimblast copy area"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to} workspace {1..10}
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (c + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
          ]
        )
        10)
      );
    };
  };

  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        "{inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
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
