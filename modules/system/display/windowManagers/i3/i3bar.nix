{ lib, config, pkgs, ... }: with lib;
{
  config = mkIf config.custom.system.display.windowManagers.i3.enable {
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        # Jetbrains Mono font for waybar
        jetbrains-mono
        font-awesome_5
        siji
      ];

      programs.i3status = {
        enable = true;
        general = {
          colors = true;
          interval = 1;
        };
        modules = {
          "wireless __first__" = {
            position = 1;
            settings = {
              format_up = "W: (%quality at %essid) %ip";
              format_down = "W: Down";
            };
          };
          "battery all" = {
            position = 2;
            settings = { format = "%status %percentage %remaining"; };
          };

          "disk /" = {
            position = 3;
            settings = { format = "%avail"; };
          };

          load = {
            position = 4;
            settings = { format = "%1min"; };
          };

          memory = {
            position = 5;
            settings = {
              format = "%used | %available";
              threshold_degraded = "1G";
              format_degraded = "MEMORY < %available";
            };
          };

          "volume master" = {
            position = 6;
            settings = {
              format = "♪ %volume";
              format_muted = "♪ muted (%volume)";
              device = "pulse:1";
            };
          };

          "tztime local" = {
            position = 7;
            settings = { format = "%Y-%m-%d %H:%M:%S"; };
          };
        };

        #style = ./. + "/style.css";
        /*
        settings = {
          mainBar = {
            layer = "top";
            position = "bottom";
            height = 32;

            modules-left = [
                "hyprland/workspaces"
                "custom/arrow10"
                "hyprland/window"
                "hyprland/submap"
            ];

            modules-right = [
                "custom/arrow9"
                "network"
                "custom/arrow8"
                "disk"
                "custom/arrow7"
                "memory"
                "custom/arrow6"
                "cpu"
                "custom/arrow5"
                "temperature"
                "custom/arrow4"
                "battery"
                "custom/arrow3"
                "pulseaudio"
                "custom/arrow2"
                "tray"
                "clock#date"
                "custom/arrow1"
                "clock#time"
            ];

            # Modules
            "hyprland/workspaces" = {
              format = "{name}";
              format-window-separator = "\n";
              active-only = false;
              all-outputs = true;
              show-special = true;
              move-to-monitor = true;
              persistent-workspaces = {
                "*" = 10;
              };
            };

            battery = {
                interval = 2;
                states = {
                    warning = 30;
                    critical =  15;
                };
                format-time = "{H}:{M:02}";
                format = "{icon} {capacity}% ({time}) ({power:.2f}W)";
                format-charging = " {capacity}% ({time})";
                format-charging-full = " {capacity}%";
                format-full = "{icon} {capacity}%";
                format-alt = "{icon} Health: {health}% {power:.2f}W";

                format-icons = [
                    "  "
                    "  "
                    "  "
                    "  "
                    "  "
                ];
                bat-compatibility = true;
                tooltip = false;
            };

            disk = {
              path = "/";
              interval = 30;
              unit = "GiB";
              format = "💾  {specific_used:0.1f} / {specific_total:0.1f}Gb ({percentage_used}%)";
            };

            "clock#time" = {
                "interval" = 1;
                "format" = "{:%H:%M:%S}";
                "tooltip" = false;
            };

            "clock#date" = {
                "interval" = 20;
                "format" = "{:%e %b %Y}";
                "tooltip" = false;
                #"tooltip-format" = "{:%e %B %Y}"
            };

            "cpu" = {
                "interval" = 5;
                "tooltip" = false;
                "format" = "  {usage}%";
                "format-alt" = "  {load}";
                "states" = {
                    "warning" = 70;
                    "critical" = 90;
                };
            };

            "sway/language" = {
                "format" = "  {}";
                "min-length" = 5;
                "on-click" = "swaymsg 'input * xkb_switch_layout next'";
                "tooltip" = false;
            };

            "memory" = {
                "interval" = 5;
                "format" = "🧠 {used:0.1f}G/{total:0.1f}G";
                "states" = {
                    "warning" = 70;
                    "critical" = 90;
                };
                "tooltip" = false;
            };

            "network" = {
                "interval" = 5;
                "format-wifi" = "   {essid} ({signalStrength}% @ {frequency}Ghz) ({ifname}) (↓{bandwidthDownBits}/↑{bandwidthUpBits})";
                "format-ethernet" = "  {ifname}";
                "format-disconnected" = "No connection";
                "format-alt" = "  {ipaddr}/{cidr}";
                "tooltip" = false;
            };

            "pulseaudio" = {
                "format" = "{icon} {volume}%";
                "format-bluetooth" = "{icon} {volume}%";
                "format-muted" = "  ";
                "format-icons" = {
                    "headphone" = "  ";
                    "hands-free" = "  ";
                    "headset" = "  ";
                    "phone" = "  ";
                    "portable" = "  ";
                    "car" = "  ";
                    "default" = ["  " "  "];
                };
                "scroll-step" = 1;
                "on-click" = "pavucontrol";
                # "on-click" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
                "tooltip" = false;
            };

            "temperature" = {
                "critical-threshold" = 90;
                "interval" = 5;
                "format" = "{icon} {temperatureC}°";
                "format-icons" = [
                    "  "
                    "  "
                    "  "
                    "  "
                    "  "
                ];
                "tooltip" = false;
            };

            "tray" = {
                "icon-size" = 18;
                #"spacing" = 10
            };

            "custom/arrow1" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow2" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow3" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow4" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow5" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow6" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow7" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow8" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow9" = {
                "format" = "";
                "tooltip" = false;
            };

            "custom/arrow10" = {
                "format" = "";
                "tooltip" = false;
            };
          };
        };
        */
      };
    };
  };
}
