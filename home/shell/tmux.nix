{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
    prefix = "C-a";
    extraConfig = ''
      unbind C-b

      set -g mouse on
      set -sg escape-time 0

      # Vim keys
      bind ^ last-window
      bind k select-pane -U
      bind j select-pane -D
      bind h select-pane -L
      bind l select-pane -R
      bind -r C-k resize-pane -U
      bind -r C-j resize-pane -D
      bind -r C-h resize-pane -L
      bind -r C-l resize-pane -R

      # Status bar
      set -g status-style 'bg=#${config.colorScheme.palette.base00} fg=#${config.colorScheme.palette.base05}'
      set-option -g status-right '#(date +"%m-%d %H:%M")'

      # Set colors
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
