{ lib, config, ... }: with lib;
{
  options.custom.programs.tmux.enable = mkEnableOption "tmux terminal multiplexer";

  config = mkIf config.custom.programs.tmux.enable {
    home-manager.users.${config.custom.username} = {

      programs.tmux = {
        enable = true;
        extraConfig = ''
          # Enable reloading via hotkey
          unbind r
          bind r source-file ~/.tmux.conf

          # Change our prefix to something easier
          set -g prefix C-Space
          unbind C-b
          bind C-Space send-prefix

          # Enable the Mouse
          set -g mouse on

          # More Sane Pane Splitting
          bind | split-window -h
          bind - split-window -v
          unbind '"'
          unbind %

          # Use VIM Keybinds
          setw -g mode-keys vi
          bind-key h select-pane -L
          bind-key j select-pane -D
          bind-key k select-pane -U
          bind-key l select-pane -R

          # Window Commands
          unbind o
          unbind c
          bind-key o new-window

          # bind-key c kill-window
          bind-key c if-shell -F '#{==:#{session_windows},1}' \
            'display-message "This is the last window, cannot close it."' \
            'kill-window'

          # Window Renaming
          set-option -g allow-rename off

          # DESIGN TWEAKS

          # don't do anything when a 'bell' rings
          set -g visual-activity off
          set -g visual-bell off
          set -g visual-silence off
          setw -g monitor-activity off
          set -g bell-action none

          # Colors
          set -g default-terminal "xterm-256color"
          set-option -ga terminal-overrides ",xterm-256color:Tc"
          set-option -sa terminal-features ',xterm-256color:RGB'

          # clock mode
          setw -g clock-mode-colour colour226

          # copy mode
          setw -g mode-style 'fg=colour0 bg=red bold'

          # panes
          set -g pane-border-style 'fg=red'
          set -g pane-active-border-style 'fg=colour226'

          # statusbar
          set -g status-position top
          set -g status-justify left
          set -g status-style 'fg=red bg=colour22'


          # Show hostname in top-left
          set -g status-left-style 'fg=colour226 bg=colour0'
          set -g status-left ' #(hostname) '
          set -g status-left-length 30

          set -g status-right-style 'fg=colour0 bg=colour226'
          set -g status-right '%Y-%m-%d %H:%M '
          set -g status-right-length 50

          # Tab Styles
          setw -g window-status-current-style 'fg=colour231 bg=blue'
          setw -g window-status-current-format ' #I #W #F '
          setw -g window-status-style 'fg=white bg=colour0'
          setw -g window-status-format ' #I #[fg=white]#W #[fg=colour226]#F '
          setw -g window-status-bell-style 'fg=colour226 bg=red bold'

          # messages
          set -g message-style 'fg=colour226 bg=red bold'
        '';
      };

    };
  };
}
