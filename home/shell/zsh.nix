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
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "fm" = "joshuto";
      "nb" = "newsboat";
      "mp" = "ncmpcpp";
      "ns" = ''nix-shell --command "zsh"'';
      "nd" = ''nix develop --command "zsh"'';
      "," = ''nix-shell --command "zsh" -p'';
      "gp" = "git add . && git commit && git push";
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
        dir=$(readlink -f "$2")
        while [ "$dir" != "/" ]; do
            if [ -e "$dir/$file" ]; then
                return 0
            fi
            dir=$(dirname "$dir")
        done
        return 1
      }
      tmux-main() {
        tmux new-session -A -D -c $HOME -s main
      }
      tmux-dev() {
        dev_dir="./$(fd -t d . | fzf)"
        shell_name="dev-$(basename $dev_dir)"
        echo "Starting dev session '$shell_name' on $dev_dir"
        if fileinparent flake.nix $dev_dir; then
          tmux new -A -D -s "$shell_name" -c "$dev_dir" "nix develop --command zsh"
        else
          tmux new -A -D -s "$shell_name" -c "$dev_dir" zsh
        fi
      }
      zle -N tmux-dev
      zle -N tmux-main
      bindkey -r ^f
      bindkey -s ^f "fm\n"
      bindkey -r ^g
      bindkey -s ^g "tmux-dev\n"
      bindkey -r ^n
      bindkey -s ^n "tmux-main\n"
      bindkey -r ^b
      bindkey -s ^b "mp\n"
      bindkey -r ^v
      bindkey -s ^v "nvim .\n"
    '';
  };
}
