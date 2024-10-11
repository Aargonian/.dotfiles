{ lib, config, pkgs, ... }: with lib;
{
  imports = [
    ./i3bar.nix
  ];

  options.custom.system.display.windowManagers.i3.enable = mkEnableOption "i3 Window Manager";

  config = mkIf config.custom.system.display.windowManagers.i3.enable {
    custom = {
      # Xorg is required for i3
      system.display.xorg.enable = true;

      services = {
        # Default enable Picom for compositing
        picom.enable = mkDefault true;

        # We need polkit for authentication
        polkit.enable = mkDefault true;
      };

      # Default to thunar for file management
      programs.thunar.enable = mkDefault true;
    };


    home-manager.users.${config.custom.username} = {

      home.packages = with pkgs; [
        xfce.xfce4-terminal

        # Make things look nicer
        lxappearance

        # Necessary Packages
        i3status
        dmenu
        feh

        # Necessary to save settings for certain gtk applications
        dconf
      ];

      xsession.windowManager.i3 = {
        enable = true;
        package = mkDefault pkgs.i3-gaps;
        config = mkDefault {
          modifier = "Mod4";

          fonts = {
            names = [ "xft:URWGothic-Book 11" ];
            style = "Bold Semi-Condensed";
            size = 11.0;
          };

          floating = {
            modifier = "Mod4";
          };

          startup = [
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; always = false; }
            { command = "sleep 1 && picom"; always = false; }
            { command = "pa-applet"; always = false; }
            { command = "setxkbmap -layout us -option ctrl:nocaps,altwin:swap_alt_win"; always = true; }
            { command = "feh --bg-scale $HOME/.background-image"; always = true; }
          ];

          # Input settings
          focus.followMouse = true;

          # General settings
          gaps = {
            inner = 16;
            outer = 32;
          };

          window.border = 4;

          bars = [
            {
              position = "bottom";
              statusCommand = "${pkgs.i3status}/bin/i3status";
            }
          ];

          # Keybindings
          keybindings = let modifier = "Mod4"; in {
            "${modifier}+p" = "exec dmenu_run";
            "${modifier}+Return" = "exec xfce4-terminal";
            "Print" = "exec grimblast copy area";
            "${modifier}+Shift+c" = "kill";
            "${modifier}+Shift+t" = "exec pseudo"; # No direct equivalent for pseudotile
            "${modifier}+Space" = "floating toggle"; # Toggle floating
            "${modifier}+Shift+space" = "floating toggle"; # Equivalent to toggle floating

            # Move focus
            "${modifier}+h" = "focus left";
            "${modifier}+j" = "focus down";
            "${modifier}+k" = "focus up";
            "${modifier}+l" = "focus right";

            # Move Window
            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+j" = "move down";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+l" = "move right";

            # Change tiling mode
            "${modifier}+b" = "split h;exec notify-send 'tile horizontally'";
            "${modifier}+v" = "split v;exec notify-send 'tile vertically'";
            "${modifier}+q" = "split toggle";

            # Toggle window fullscreen
            "${modifier}+f" = "fullscreen toggle";

            # Change container layout (stacked, tabbed, toggle split)
            "${modifier}+s" = "layout stacking";
            "${modifier}+t" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            # Workspace switching
            "${modifier}+1" = "workspace 1";
            "${modifier}+2" = "workspace 2";
            "${modifier}+3" = "workspace 3";
            "${modifier}+4" = "workspace 4";
            "${modifier}+5" = "workspace 5";
            "${modifier}+6" = "workspace 6";
            "${modifier}+7" = "workspace 7";
            "${modifier}+8" = "workspace 8";
            "${modifier}+9" = "workspace 9";
            "${modifier}+0" = "workspace 10";

            # Move window to workspace
            "${modifier}+Shift+1" = "move container to workspace 1";
            "${modifier}+Shift+2" = "move container to workspace 2";
            "${modifier}+Shift+3" = "move container to workspace 3";
            "${modifier}+Shift+4" = "move container to workspace 4";
            "${modifier}+Shift+5" = "move container to workspace 5";
            "${modifier}+Shift+6" = "move container to workspace 6";
            "${modifier}+Shift+7" = "move container to workspace 7";
            "${modifier}+Shift+8" = "move container to workspace 8";
            "${modifier}+Shift+9" = "move container to workspace 9";
            "${modifier}+Shift+0" = "move container to workspace 10";

            # Mouse bindings
            "${modifier}+button1" = "move";
            "${modifier}+button3" = "resize";

            # Special workspace
            #"${modifier}+S" = "exec --no-startup-id scratchpad show";
            "${modifier}+Shift+S" = "exec --no-startup-id move container to scratchpad";
          };
        };
      };

      # Unfortunately, there is (to my knowledge) not a way to configure xinitrc through nix, so we'll write it manually
      home.file."Data/Configuration/RC/xinitrc".text = mkDefault ''
        #!/usr/bin/env sh

        # Start i3
        #exec i3
        i3
      '';
      # environment.pathsToLink = [ "/libexec" ];
    };
  };
}
