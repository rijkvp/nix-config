{ pkgs, theme, ... }: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-a";
    extraConfig = ''
      unbind C-b

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

      set -sg escape-time 0

      # Status bar
      set -g status-style 'bg=${theme.background} fg=${theme.foreground}'
      set-option -g status-right '#(date +"%m-%d %H:%M")'

      # Set colors
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };
}
