{ config, pkgs, pkgs-unstable, lib, inputs, ... }:
{
  config = {
    environment.systemPackages = with pkgs; [
      xorg.setxkbmap
      xorg.xrandr

      arandr
      dmenu
      feh
      dconf
      dig
      inetutils
      xfce4-terminal # Terminal
      tigervnc
      ungoogled-chromium
      via
      samba
      cifs-utils
      pa_applet
      pa_applet
      pavucontrol
      spotify
      vlc
      git
      cmakeMinimal
      gcc
      gnumake
      automake

      sqlite
      jq
      jq          # JSON Utility
      nodejs_22   # NodeJS Support
      pkgs-unstable.neovim
      ripgrep
      fzf # For neovim telescope plugin
      xclip # Neovim clipboard provider
      xsel # Neovim clipboard provider
      universal-ctags # Neovim TagBar
      python311Packages.pynvim
      nil         # Nix Language Server
      python3
      cargo
      #      rustc
      rustup
      ripgrep
      thunderbird
      # Common system and shell utilities
      bash
      vim
      wget
      curl
      file
      htop
      tree
      nmon
      du-dust
      udisks
      parted

      # To easily search Nixpkgs :)
      nix-search-cli
    ] ++ [
      pkgs-unstable.ncspot
    ];

    custom.programs.firefox.enable = true;

    programs.firefox.enable = true;

  home-manager.users.aargonian = {
    home.packages = with pkgs; [
      discord
      hexchat
    ];

    programs.git = {
      enable = true;
      userName = "Aaron Gorodetzky";
      userEmail = "aaron@nytework.com";
      ignores = [
        "*.swp"
      ];

      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "store --file ~/.git-credentials";
      };

    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };


    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    # Use binary cache for anyrun if possible
    nix.settings = {
      builders-use-substitutes = true;
      extra-substituters = [
        "https://anyrun.cachix.org"
      ];
      extra-trusted-public-keys = [
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      ];
    };

    home-manager.users.${config.custom.username} = {
      imports = [
        inputs.anyrun.homeManagerModules.default
      ];
      programs.anyrun = {
        enable = true;
          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            applications
            rink
            # randr
            shell
            kidex
            symbols
          ];

          width.fraction = 0.25;
          y.fraction = 0.3;
          hidePluginInfo = true;
          closeOnClick = true;
          hideIcons = false;
          showResultsImmediately = true;
          maxEntries = null;
        };

        extraCss = builtins.readFile(./. + "/anyrun-style.css");
      };
    };

    custom.programs = {
      transmission.enable = true;
      liferea.enable = true;
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        liferea
      ];
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        transmission-qt
      ];
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        # Jetbrains Mono font for waybar
        jetbrains-mono
        font-awesome_5
        siji
      ];

      # Waybar status bar for hyprland
      programs.waybar = {
        enable = true;
        style = ./. + "/style.css";
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
        systemd.enable = true;
      };
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        calibre
      ];
    };

    custom.system.display.enable = true;

    custom.programs = {
      calibre.enable = true;
      libreoffice.enable = true;
      obsidian.enable = true;
      todoist.enable = true;
      xreader.enable = true;
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        libreoffice
      ];
    };
    nixpkgs.config.allowUnfree = true;
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        obsidian
      ];

    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        todoist-electron
      ];
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        cinnamon.xreader
      ];
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        bitwarden-cli
        bitwarden-desktop
      ];
    };

    # Enable gnome-keyring for passkey storage

    # Enable graphical frontend for gnome-keyring
    programs.seahorse.enable = true;
    programs.zsh.enable = true;

    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        gnome.gnome-terminal
      ];
    };
    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        xfce.xfce4-terminal
      ];
    };

    # Japanese IME
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
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-volman
        thunar-dropbox-plugin
        thunar-archive-plugin
        thunar-media-tags-plugin
      ];
    };

    # Tumbler for thumbnail support in Thunar

    # GVFS for Mount, Trash, and other filesystem tools
    servies = {
      tumbler.enable = true;
      printing.enable = true;
      gnome.gnome-keyring.enable = true;
      gvfs = {
        enable = true;
        package = lib.mkForce pkgs.gnome3.gvfs;
      };
    };

    # Samba Fix
    networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';

    # Xfconf is needed to save thunar's preferences in case XFCE doesn't exist
    # TODO: Eventually pull this into its own module and use home manager for xfconf settings!
    programs.xfconf.enable = true;
    networking.firewall.allowedTCPPorts = [
      548
      636
    ];

    # Enable touchpad support (enabled default in most desktopManager).
    services.logind = {
      libinput.enable = true;
      libinput.touchpad.naturalScrolling = true;
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
      lidSwitch = "hibernate";
      lidSwitchExternalPower = "ignore";
      openssh.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        publish = {
          enable = true;
          userServices = true;
          addresses = true;
        };
      };
      fprintd.enable = true;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --remember-user-session --time --cmd dbus-run-session hyprland";
            user = "greeter";
          };
        };
      };
    };

    # Control AMD GPU with Lact
    systemd.packages = [ pkgs.lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];
    # Ensure greetd can unlock my keyring
    security.pam.services.greetd.enableGnomeKeyring = true;

    services.picom = {
      enable = true;

      settings = {
        # Backend configuration
        backend = "glx";
        vsync = true;

        # Shadows
        shadow = true;
        shadow-radius = 4;
        shadow-offset-x = -12;
        shadow-offset-y = -12;
        shadow-opacity = 0.75;
        shadow-exclude = [
            "class_g = 'i3-frame'"
            "class_g = 'i3bar'"
            "_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
            "_GTK_FRAME_EXTENTS@:c"
        ];
        # shadow-exclude-reg = "bounding_shaped && !rounded_corners";

        # Fading
        fading = true;
        fade-delta = 4;
        fade-in-step = 0.03;
        fade-out-step = 0.03;

        # Transparency / Opacity
        inactive-opacity = 0.75;
        active-opacity = 0.90;
        frame-opacity = 0.80;
        inactive-opacity-override = true;

        # Blur
        blur-method = "dual_kawase";
        blur-strength = 7;
        blur-background = true;
        blur-background-frame = true;
        blur-background-fixed = true;
        #blur-kern = "11,11,11,11,11,11,11,11,11,11,11";

        # Window animations
        animation-for-open = "flyin 1.0 3";
        animation-for-unmap = "flyout 1.0 3";
        animation-stagger-time = 0.03;

        # Other settings
        use-ewmh-active-win = true;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        refresh-rate = 60;
        sw-opti = true;
        unredir-if-possible = true;
        unredir-if-possible-exclude = [
            "class_g = 'i3-frame'"
        ];
      };
    };
  # Pipewire for Audio and Screensharing
    # Recommended for Pipewire and Pulseaudio
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      wireplumber = {
        enable = true;
      };
    };

    # Pulseaudio needs to be disabled for pipewire
    hardware.pulseaudio.enable = false;
  security.polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        });
      '';
    };
    services.power-profiles-daemon.enable = true;
    # Enable sound.
    sound.enable = true;

    # Disable SDDM by default
    services.displayManager.sddm.enable = false;

    # Install Cinnamon
    services.xserver = {
      desktopManager.cinnamon.enable = true;

      # For whatever reason, startx is needed to start cinnamon with greetd
      displayManager.startx.enable = true;
    };

    # DisplayLink Driver Support
    services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
    services.xserver.displayManager.sessionCommands = ''
        ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
    '';

    # Note: The following command may need to be ran before the DL driver will work:
    # nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
    # QT Dark Theming.
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    home-manager.users.${config.custom.username} = {
      dconf.settings = {
        "org/gnome/desktop/background" = {
          picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      gtk = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome.gnome-themes-extra;
        };
      };
    };
    # If xorg erroring is enabled, we attempt to force-disable xorg with errors if something turns it on
    services.xserver = {
      enable = false;
    };

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
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
            #"opacity 0.95 0.50, title:(.*)$"
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

            # Various Window Functions
            "$mod, SPACE, togglefloating,"
            "$mod, f, fullscreen"
            "$mod, c, killactive"

            # Dwindle
            "$mod SHIFT, t, pseudo,"
            "$mod, V, togglesplit,"

            # Move with LMB, Resize with RMB
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindowpixel"

            # Move window with Keyboard
            "$mod SHIFT, h, movewindow, l"
            "$mod SHIFT, j, movewindow, d"
            "$mod SHIFT, k, movewindow, u"
            "$mod SHIFT, l, movewindow, r"

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
          ];

        };

        extraConfig = ''
          source = ~/.config/hypr/monitors.conf
          source = ~/.config/hypr/workspaces.conf
        '';
      };
    };

      # Enable i3 itself and throw in some additional useful packages
    services.xserver.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
        feh
        dconf
        lxappearance
      ];
    };

    # Recommends by NixOS Wiki for some reason?
    environment.pathsToLink = [ "/libexec" ];

    home-manager.users.${config.custom.username} = {
      xsession.windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
          modifier = "Mod4";

          fonts = {
            names = [ "xft:URWGothic-Book 11" ];
            style = "Bold Semi-Condensed";
            size = 16.0;
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
            outer = 16;
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
    };
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
      };
    };

    services.xserver.displayManager.startx.enable = true;

    home-manager.users.${config.custom.username} = {
      home.packages = with pkgs; [
        xorg.xinit
      ];

    # Install XFCE4
    services.xserver.desktopManager.xfce.enable = true;

    services.xserver = {
      enable = true;

      # Disable most display managers by default
      displayManager = {
        gdm.enable = false;
        lightdm = {
          enable = false;
          greeters.gtk.enable = false;
          greeters.slick.enable = false;
        };
      };

      xkb = {
        layout = "us";
        options = "eurosign:e,ctrl:nocaps";
      };
    };

    # GVFS for Samba Share
    services.gvfs = {
      enable = true;
      package = pkgs.gnome3.gvfs;
    };

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
    ];


    networking = {
      hostName = config.custom.system.networking.hostname;
      networkmanager.enable = true;

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      useDHCP = true;
      # networking.interfaces.enp5s0.useDHCP = true;
      # networking.interfaces.wlo1.useDHCP = true;


      firewall.allowedTCPPorts = [];
    };

    time.timeZone = "America/New_York";

    services = {
      mullvad-vpn.enable = true;

      # Mullvad currently requires systemd-resolved
      resolved = {
        enable = true;
        dnssec = "false";
        dnsovertls = "false";
      };
    };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use the latest linux kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Ensure NTFS is supported
  boot.supportedFilesystems = [ "ntfs" "btrfs" ];
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.05";
  nix.settings.experimental-features = "nix-command flakes";

    users.users.${config.custom.username} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      initialPassword = "123456";
      extraGroups = [ "wheel" "dialout" ];
    };

   virtualisation.virtualbox.host.enable = config.custom.system.virtualization.virtualbox.host;

   users.extraGroups.virtualboxusers.members = [
     config.custom.username
   ];
}
