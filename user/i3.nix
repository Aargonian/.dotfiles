{ pkgs, ... }:
{
  imports = [
    ./picom.nix
    ./i3bar.nix
  ];
  home.packages = with pkgs; [
    # We need xorg
    xorg.xinit
    xorg.setxkbmap
    xorg.xrandr
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-dropbox-plugin
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.tumbler
    xfce.xfce4-terminal

    # Control Pulseaudio Volume/Devices
    pavucontrol
    pa_applet

    # We need a policy kit
    polkit_gnome

    # Make things look nicer
    lxappearance

    # Necessary Packages
    i3status
    dmenu
    arandr
    grim
    feh

    # Necessary to save settings for certain gtk applications
    dconf
  ];

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
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
        { command = "xrandr --output eDP-2 --mode 2560x1600 --rate 165 --primary"; always = false; }
        { command = "xrandr --output DVI-I-2 --auto --left-of eDP-2"; always = false; }
        { command = "xrandr --output DVI-I-1 --auto --right-of eDP-2"; always = false; }
        { command = "xrandr --output DP-10 --auto --right-of eDP-2"; always = false; }
        { command = "xrandr --output DP-11 --auto --right-of eDP-2"; always = false; }
        { command = "xrandr --output DP-5 --auto --left-of eDP-2"; always = false; }
        { command = "xrandr --output DP-12 --auto --left-of eDP-2"; always = false; }
        { command = "xrandr --output DP-13 --auto --left-of eDP-2"; always = false; }
        { command = "xrandr --output DP-14 --auto --left-of eDP-2"; always = false; }
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
  home.file.".xinitrc".text = ''
    #!/usr/bin/env sh

    # Start i3
    exec i3
  '';
  # environment.pathsToLink = [ "/libexec" ];
}
## i3 config file (v4)
## Please see http://i3wm.org/docs/userguide.html for a complete reference!
#
## Set mod key (Mod1=<Alt>, Mod4=<Super>)
#set ${modifier} Control
#
## set default desktop layout (default is tiling)
## workspace_layout tabbed <stacking|tabbed>
#
## Configure border style <normal|1pixel|pixel xx|none|pixel>
#default_border pixel 1
#default_floating_border normal
#
## Hide borders
#hide_edge_borders none
#
## change borders
#bindsym ${modifier}+u border none
#bindsym ${modifier}+y border pixel 1
#bindsym ${modifier}+n border normal
#
## Font for window titles. Will also be used by the bar unless a different font
## is used in the bar {} block below.
#font xft:URWGothic-Book 11
#
## Use Mouse+${modifier} to drag floating windows
#floating_modifier ${modifier}
#
## start a terminal
#bindsym ${modifier}+Return exec i3-sensible-terminal
#
## kill focused window
#bindsym ${modifier}+Shift+c kill
#
## Use dmenu_run for launcher
#bindsym ${modifier}+p exec --no-startup-id dmenu_run
#
## Screen brightness controls
#bindsym XF86MonBrightnessUp exec "xbacklight -inc 10; notify-send 'brightness up'"
#bindsym XF86MonBrightnessDown exec "xbacklight -dec 10; notify-send 'brightness down'"
#
## Start Applications
##bindsym ${modifier}+t exec --no-startup-id pkill picom
##bindsym ${modifier}+Ctrl+t exec --no-startup-id picom -b
##bindsym ${modifier}+Shift+d --release exec "killall dunst; exec notify-send 'restart dunst'"
#bindsym Print exec --no-startup-id i3-scrot
#bindsym ${modifier}+Print --release exec --no-startup-id i3-scrot -w
#bindsym ${modifier}+Shift+Print --release exec --no-startup-id i3-scrot -s
##bindsym ${modifier}+Shift+h exec xdg-open /usr/share/doc/manjaro/i3_help.pdf
##bindsym ${modifier}+Ctrl+x --release exec --no-startup-id xkill
#
## focus_follows_mouse no
#
## change focus
#bindsym ${modifier}+h focus left
#bindsym ${modifier}+j focus down
#bindsym ${modifier}+k focus up
#bindsym ${modifier}+l focus right
#
## alternatively, you can use the cursor keys:
#bindsym ${modifier}+Left focus left
#bindsym ${modifier}+Down focus down
#bindsym ${modifier}+Up focus up
#bindsym ${modifier}+Right focus right
#
## move focused window
#
## alternatively, you can use the cursor keys:
#bindsym ${modifier}+Shift+Left move left
#bindsym ${modifier}+Shift+Down move down
#bindsym ${modifier}+Shift+Up move up
#bindsym ${modifier}+Shift+Right move right
#
## split orientation
#
## toggle fullscreen mode for the focused container
#
## toggle tiling / floating
#bindsym ${modifier}+Shift+space floating toggle
#
## change focus between tiling / floating windows
#bindsym ${modifier}+space focus mode_toggle
#
## toggle sticky
##bindsym ${modifier}+Shift+s sticky toggle
#
## focus the parent container
#bindsym ${modifier}+a focus parent
#
## move the currently focused window to the scratchpad
#bindsym ${modifier}+Shift+minus move scratchpad
#
## Show the next scratchpad window or hide the focused scratchpad window.
## If there are multiple scratchpad windows, this command cycles through them.
#bindsym ${modifier}+minus scratchpad show
#
#navigate workspaces next / previous
#bindsym ${modifier}+Ctrl+Right workspace next
#bindsym ${modifier}+Ctrl+Left workspace prev

# Workspace names
# to display names or symbols instead of plain workspace numbers you can use
# something like: set $ws1 1:mail
#                 set $ws2 2:
#set $ws1 1
#set $ws2 2
#set $ws3 3
#set $ws4 4
#set $ws5 5
#set $ws6 6
#set $ws7 7
#set $ws8 8
#set $ws9 9
#set $ws0 0
#
# switch to workspace
#bindsym ${modifier}+1 workspace $ws1
#bindsym ${modifier}+2 workspace $ws2
#bindsym ${modifier}+3 workspace $ws3
#bindsym ${modifier}+4 workspace $ws4
#bindsym ${modifier}+5 workspace $ws5
#bindsym ${modifier}+6 workspace $ws6
#bindsym ${modifier}+7 workspace $ws7
#bindsym ${modifier}+8 workspace $ws8
#bindsym ${modifier}+9 workspace $ws9
#bindsym ${modifier}+0 workspace $ws0
#
## Move focused container to workspace
#bindsym ${modifier}+Shift+1 move container to workspace $ws1
#bindsym ${modifier}+Shift+2 move container to workspace $ws2
#bindsym ${modifier}+Shift+3 move container to workspace $ws3
#bindsym ${modifier}+Shift+4 move container to workspace $ws4
#bindsym ${modifier}+Shift+5 move container to workspace $ws5
#bindsym ${modifier}+Shift+6 move container to workspace $ws6
#bindsym ${modifier}+Shift+7 move container to workspace $ws7
#bindsym ${modifier}+Shift+8 move container to workspace $ws8
#bindsym ${modifier}+Shift+9 move container to workspace $ws9
#bindsym ${modifier}+Shift+0 move container to workspace $ws0
#
## Open specific applications in floating mode
#for_window [title="alsamixer"] floating enable border pixel 1
#for_window [class="calamares"] floating enable border normal
#for_window [class="Clipgrab"] floating enable
#for_window [title="File Transfer*"] floating enable
#for_window [class="fpakman"] floating enable
#for_window [class="Galculator"] floating enable border pixel 1
#for_window [class="GParted"] floating enable border normal
#for_window [title="i3_help"] floating enable sticky enable border normal
#for_window [class="Lightdm-settings"] floating enable
#for_window [class="Lxappearance"] floating enable sticky enable border normal
#for_window [class="Manjaro-hello"] floating enable
#for_window [class="Manjaro Settings Manager"] floating enable border normal
#for_window [title="MuseScore: Play Panel"] floating enable
#for_window [class="Nitrogen"] floating enable sticky enable border normal
#for_window [class="Oblogout"] fullscreen enable
#for_window [class="octopi"] floating enable
#for_window [title="About Pale Moon"] floating enable
#for_window [class="Pamac-manager"] floating enable
#for_window [class="Pavucontrol"] floating enable
#for_window [class="qt5ct"] floating enable sticky enable border normal
#for_window [class="Qtconfig-qt4"] floating enable sticky enable border normal
#for_window [class="Simple-scan"] floating enable border normal
#for_window [class="(?i)System-config-printer.py"] floating enable border normal
#for_window [class="Skype"] floating enable border normal
#for_window [class="Timeset-gui"] floating enable border normal
#for_window [class="(?i)virtualbox"] floating enable border normal
#for_window [class="Xfburn"] floating enable

## switch to workspace with urgent window automatically
#for_window [urgent=latest] focus

## Binding is being used for the "Close" command
## reload the configuration file
##bindsym ${modifier}+Shift+c reload

# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
#bindsym ${modifier}+Shift+r restart

# exit i3 (logs you out of your X session)
#bindsym ${modifier}+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"
#
## Set shut down, restart and locking features
##bindsym ${modifier}+0 mode "${modifier}e_system"
#bindsym XF86PowerOff mode "${modifier}e_system"
#set ${modifier}e_system (l)ock, (e)xit, switch_(u)ser, (s)uspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
#mode "${modifier}e_system" {
#    bindsym l exec --no-startup-id i3exit lock, mode "default"
#    bindsym s exec --no-startup-id i3exit suspend, mode "default"
#    bindsym u exec --no-startup-id i3exit switch_user, mode "default"
#    bindsym e exec --no-startup-id i3exit logout, mode "default"
#    bindsym h exec --no-startup-id i3exit hibernate, mode "default"
#    bindsym r exec --no-startup-id i3exit reboot, mode "default"
#    bindsym Shift+s exec --no-startup-id i3exit shutdown, mode "default"
#
#    # exit system mode: "Enter" or "Escape"
#    bindsym Return mode "default"
#    bindsym Escape mode "default"
#}
#
## Resize window (you can also use the mouse for that)
#bindsym ${modifier}+r mode "resize"
#mode "resize" {
#        # These bindings trigger as soon as you enter the resize mode
#        # Pressing left will shrink the window’s width.
#        # Pressing right will grow the window’s width.
#        # Pressing up will shrink the window’s height.
#        # Pressing down will grow the window’s height.
#        bindsym h resize shrink width 5 px or 5 ppt
#        bindsym j resize grow height 5 px or 5 ppt
#        bindsym k resize shrink height 5 px or 5 ppt
#        bindsym l resize grow width 5 px or 5 ppt
#
#        # same bindings, but for the arrow keys
#        bindsym Left resize shrink width 10 px or 10 ppt
#        bindsym Down resize grow height 10 px or 10 ppt
#        bindsym Up resize shrink height 10 px or 10 ppt
#        bindsym Right resize grow width 10 px or 10 ppt
#
#        # exit resize mode: Enter or Escape
#        bindsym Return mode "default"
#        bindsym Escape mode "default"
#}
#
## Lock screen
##bindsym ${modifier}+9 exec --no-startup-id blurlock
#
## Color palette used for the terminal ( ~/.Xresources file )
## Colors are gathered based on the documentation:
## https://i3wm.org/docs/userguide.html#xresources
## Change the variable name at the place you want to match the color
## of your terminal like this:
## [example]
## If you want your bar to have the same background color as your
## terminal background change the line 362 from:
## background #14191D
# to:
# background $term_background
# Same logic applied to everything else.
#set_from_resource $term_background background
#set_from_resource $term_foreground foreground
#set_from_resource $term_color0     color0
#set_from_resource $term_color1     color1
#set_from_resource $term_color2     color2
#set_from_resource $term_color3     color3
#set_from_resource $term_color4     color4
#set_from_resource $term_color5     color5
#set_from_resource $term_color6     color6
#set_from_resource $term_color7     color7
#set_from_resource $term_color8     color8
#set_from_resource $term_color9     color9
#set_from_resource $term_color10    color10
#set_from_resource $term_color11    color11
#set_from_resource $term_color12    color12
#set_from_resource $term_color13    color13
#set_from_resource $term_color14    color14
#set_from_resource $term_color15    color15
#
## Start i3bar to display a workspace bar (plus the system information i3status if available)
#bar {
##	i3bar_command i3bar
#	status_command i3status
#	position bottom
#
### please set your primary output first. Example: 'xrandr --output eDP1 --primary'
##	tray_output primary
##	tray_output eDP1
#
#	bindsym button4 nop
#	bindsym button5 nop
##   font xft:URWGothic-Book 11
#	strip_workspace_numbers yes
#
#    colors {
#        background #222D31
#        statusline #F9FAF9
#        separator  #454947
##
##                      border  backgr. text
#        focused_workspace  #F9FAF9 #16a085 #292F34
#        active_workspace   #595B5B #353836 #FDF6E3
#        inactive_workspace #595B5B #222D31 #EEE8D5
#        binding_mode       #16a085 #2C2C2C #F9FAF9
#        urgent_workspace   #16a085 #FDF6E3 #E5201D
#    }
#}
#
## hide/unhide i3status bar
#bindsym ${modifier}+m bar mode toggle
#
## Theme colors
## class                   border  backgr. text    indic.   child_border
#  client.focused          #556064 #556064 #80FFF9 #FDF6E3
#  client.focused_inactive #2F3D44 #2F3D44 #1ABC9C #454948
#  client.unfocused        #2F3D44 #2F3D44 #1ABC9C #454948
#  client.urgent           #CB4B16 #FDF6E3 #1ABC9C #268BD2
#  client.placeholder      #000000 #0c0c0c #ffffff #000000
#
#  client.background       #2B2C2B
#
##############################
#### settings for i3-gaps: ###
##############################
#
## Set inner/outer gaps
#gaps inner 14
#gaps outer -2
#
## Additionally, you can issue commands with the following syntax. This is useful to bind keys to changing the gap size.
## gaps inner|outer current|all set|plus|minus <px>
## gaps inner all set 10
## gaps outer all plus 5
#
## Smart gaps (gaps used if only more than one container on the workspace)
#smart_gaps on
#
## Smart borders (draw borders around container only if it is not the only container on this workspace)
## on|no_gaps (on=always activate and no_gaps=only activate if the gap size to the edge of the screen is 0)
#smart_borders on
#
## Press ${modifier}+Shift+g to enter the gap mode. Choose o or i for modifying outer/inner gaps. Press one of + / - (in-/decrement for current workspace) or 0 (remove gaps for current workspace). If you also press Shift with these keys, the change will be global for all workspaces.
#set ${modifier}e_gaps Gaps: (o) outer, (i) inner
#set ${modifier}e_gaps_outer Outer Gaps: +|-|0 (local), Shift + +|-|0 (global)
#set ${modifier}e_gaps_inner Inner Gaps: +|-|0 (local), Shift + +|-|0 (global)
#bindsym ${modifier}+Shift+g mode "${modifier}e_gaps"
#
#mode "${modifier}e_gaps" {
#        bindsym o      mode "${modifier}e_gaps_outer"
#        bindsym i      mode "${modifier}e_gaps_inner"
#        bindsym Return mode "default"
#        bindsym Escape mode "default"
#}
#mode "${modifier}e_gaps_inner" {
#        bindsym plus  gaps inner current plus 5
#        bindsym minus gaps inner current minus 5
#        bindsym 0     gaps inner current set 0
#
#        bindsym Shift+plus  gaps inner all plus 5
#        bindsym Shift+minus gaps inner all minus 5
#        bindsym Shift+0     gaps inner all set 0
#
#        bindsym Return mode "default"
#        bindsym Escape mode "default"
#}
#mode "${modifier}e_gaps_outer" {
#        bindsym plus  gaps outer current plus 5
#        bindsym minus gaps outer current minus 5
#        bindsym 0     gaps outer current set 0
#
#        bindsym Shift+plus  gaps outer all plus 5
#        bindsym Shift+minus gaps outer all minus 5
#        bindsym Shift+0     gaps outer all set 0
#
#        bindsym Return mode "default"
#        bindsym Escape mode "default"
#}
#
## Autostart Applications
## Delay start PulseAudio because fuck
#exec --no-startup-id sleep 10; pulseaudio --start
#exec --no-startup-id pa-applet
#exec --no-startup-id nm-applet
#exec --no-startup-id blueman-applet
#exec --no-startup-id xfce4-power-manager
#exec --no-startup-id pamac-tray
##exec --no-startup-id $HOME/.screenlayout/layout.sh; sleep 1; nitrogen --restore; sleep 1; picom -b
#exec --no-startup-id xautolock -time 10 -locker blurlock
#exec --no-startup-id /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
#exec --no-startup-id start_conky_maia
#exec --no-startup-id albert
#exec_always --no-startup-id setxkbmap -option ctrl:nocaps
#exec_always --no-startup-id ff-theme-util
#exec_always --no-startup-id fix_xcursor
#
## Reverse scroll direction on touchpad for my laptop
#exec --no-startup-id xinput set-button-map 20 1 2 3 5 4 6 7
