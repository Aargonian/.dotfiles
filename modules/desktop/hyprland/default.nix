{ lib, config, pkgs, pkgs-unstable, ... }:
{
  imports = [
    ./waybar
    ./anyrun
  ];

  options.custom.hyprland = {
    enable = lib.mkEnableOption "Enable hyprland";
  };

  config = lib.mkIf config.custom.hyprland.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        # Screenshot Utilities
        grim
        slurp
        dunst

        # Wallpaper
        hyprpaper

        # Utilities
        wl-clipboard
        wl-screenrec
        wlr-randr

        # We need a polkit agent
        lxqt.lxqt-policykit

        # Screensharing
        xwaylandvideobridge
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk

        # We need unstable nwg-displays due to https://github.com/nwg-piotr/nwg-displays/issues/64
        pkgs-unstable.nwg-displays

      ];

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        settings = {
          "$mod" = "Mod4";

          debug = {
            disable_logs = false;
          };

          input = {
            kb_layout = "us";
            kb_options = "ctrl:nocaps,altwin:swap_alt_win";
            follow_mouse = "1";
            touchpad = {
              clickfinger_behavior = true;
              natural_scroll = "yes";
              disable_while_typing = "yes";
            };
            sensitivity = 0;
          };

          exec-once = [
            "hyprpaper"
            "lxqt-policykit-agent"
            "fcitx5 -d -r"
            "fcitx5-remote -r"
          ];

          general = {
            gaps_in = 16;
            gaps_out = 32;
            border_size = 4;
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";

            layout = "dwindle";

            # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
            allow_tearing = false;
          };

          decoration = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            rounding = 10;

            blur = {
                enabled = true;
                size = 3;
                passes = 1;
            };

            drop_shadow = "yes";
            shadow_range = 4;
            shadow_render_power = 3;
            "col.shadow" = "rgba(1a1a1aee)";
          };
          animations = {
            enabled = "yes";

            # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };
          dwindle = {
              # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
              # master switch for pseudotiling. Enabling is bound to mod + P in the keybinds section below
              pseudotile = "yes";
              preserve_split = "yes"; # you probably want this
          };
          master = {
              # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
              new_on_active= "after";
          };
          gestures = {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              workspace_swipe = true;
              workspace_swipe_fingers = 4;
          };
          misc = {
              # See https://wiki.hyprland.org/Configuring/Variables/ for more
              force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
          };
          windowrule = [
            "pseudo, fcitx"
          ];
          windowrulev2 = [
            "suppressevent maximize, class:.*" # You'll probably like this.
            "opacity 0.95 0.50, title:(.*)$"
          ];

      # Making things not break in Wayland
          env = [
            "QT_QPA_PLATFORM,wayland;xcb,"
            "GDK_BACKEND,wayland,x11,"
            "SDL_VIDEODRIVER,wayland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "CLUTTER_BACKEND,wayland"
          ];

          bind = [
            "$mod, p, exec, anyrun"
            "$mod, Return, exec, xfce4-terminal"
            ", Print, exec, grimblast copy area"
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            #"$mod, V, togglefloating,"
            #"$mod, R, exec, $menu"
            #"$mod, P, pseudo, # dwindle"
            "$mod SHIFT, k, killactive"
            "$mod SHIFT, t, pseudo," # dwindle
            "$mod, V, togglesplit," # dwindle

            # Move with LMB, Resize with RMB
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindowpixel"

            # Move focus with mod + arrow keys
            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"

            # Example special workspace (scratchpad)
            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"

            # Switch workspaces with mod + [0-9]
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"

            # Move active window to a workspace with mod + SHIFT + [0-9]
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"

            # Scroll through existing workspaces with mod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
          ];

        };

        extraConfig = ''
          source = ~/.config/hypr/monitors.conf
          source = ~/.config/hypr/workspaces.conf
        '';
      };
    };
  };
}
