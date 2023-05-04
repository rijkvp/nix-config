{ lib, pkgs, theme, ... }: {
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    completionInit = "autoload -U compinit && compinit -u";
    enableAutosuggestions = true;
    shellAliases = {
      "ls" = "exa --icons -1 -s extension --group-directories-first";
      "lsa" = "exa --icons -1 -lah -s extension --group-directories-first";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "fm" = "joshuto";
      "nb" = "newsboat";
      "mp" = "ncmpcpp";
      "ns" = ''nix-shell --command "zsh"'';
      "nd" = ''nix develop --command "zsh"'';
      "np" = ''nix-shell --command "zsh" -p'';
      "gc" = "git add . && git commit && git push";
      "tm" = "tmux new-session -A -D -s main";
      # Duplicate folder
      "dupl" = "rsync -rlptDhP --delete-after --stats";
      # yt-dlp
      "dlaudio" = ''yt-dlp -f "ba[acodec=opus]/ba/b" --extract-audio --audio-format opus --embed-thumbnail --embed-metadata --xattrs -o "%(artist,channel,uploader)s - %(title)s.%(ext)s"'';
      "dlalbum" = ''yt-dlp -f "ba[acodec=opus]/ba/b" --extract-audio --audio-format opus --embed-thumbnail --embed-metadata --xattrs -o "%(album)s/%(artist,channel,uploader)s - %(title)s.%(ext)s"'';
      "dlvid" = ''yt-dlp -f "(bv[vcodec^=vp9][height<=1080]/bv[height<=1080]/bv)+(ba[acodec=opus]/ba/b)" --merge-output-format mkv --embed-thumbnail --embed-metadata --xattrs -o "%(artist,channel,uploader)s - %(title)s.%(ext)s"'';
      # Difftastic
      "gitdt" = "GIT_EXTERNAL_DIFF=difft git diff";
    };
    initExtra = ''
      tecw() {
        watchexec -e tex "tectonic -c minimal $1"
      }
      mdw() {
        out="$(basename $1 .md).pdf"
        watchexec -e md "pandoc --pdf-engine tectonic -o $out $1"
      }
      fileinparent() {
        file=$1
        dir=$2
        while [ "$dir" != "/" ]; do
            if [ -e "$dir/$file" ]; then
                return 0
            fi
            dir=$(dirname "$dir")
        done
        return 1
      }
      tmux-main() {
        tmux new-session -A -D -s main
      }
      tmux-dev() {
        dev_dir="./$(fd -t d . | fzf)"
        shell_name="dev-$(basename $dev_dir)"
        echo "Starting dev session on $dev_dir"
        if fileinparent flake.nix $dev_dir; then
          tmux new -A -D -s "$shell_name" -c "$dev_dir" "nix develop --command zsh"
        else
          tmux new -A -D -s "$shell_name" -c "$dev_dir"
        fi
      }
      zle -N tmux-main
      zle -N tmux-dev
      bindkey -s ^n "tmux-main\n"
      bindkey -s ^f "tmux-dev\n"
    '';
  };

  programs.exa = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

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

      # Status bar
      set -g status-style 'bg=${theme.background} fg=${theme.foreground}'
      set-option -g status-right '#(date +"%m-%d %H:%M")'

      # Set colors
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
    '';
  };

}
