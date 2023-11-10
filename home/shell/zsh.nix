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
      "gc" = "git add . && git commit";
      "gp" = "git add . && git commit && git push";
      "tm" = "tmux new-session -A -D -s main";
      # Duplicate folder
      "dupl" = "rsync -rlptDhP --delete-after --stats";
      # yt-dlp
      "dlaudio" = ''yt-dlp -f "ba[acodec=opus]/ba/b" --extract-audio --audio-format opus --embed-thumbnail --embed-metadata --xattrs -o "%(artist,channel,uploader)s - %(title)s.%(ext)s"'';
      "dlalbum" = ''yt-dlp -f "ba[acodec=opus]/ba/b" --extract-audio --audio-format opus --embed-thumbnail --embed-metadata --xattrs -o "%(album)s/%(artist,channel,uploader)s - %(title)s.%(ext)s"'';
      "dlvid" = ''yt-dlp -f "(bv[vcodec^=vp9][height<=1080]/bv[height<=1080]/bv)+(ba[acodec=opus]/ba/b)" --merge-output-format mkv --embed-thumbnail --embed-metadata --xattrs -o "%(artist,channel,uploader)s - %(title)s.%(ext)s"'';
      # Difftastic
      "gd" = "GIT_EXTERNAL_DIFF=difft git diff";
      # To-Do
      "todo" = "vim $XDG_DOCUMENTS_DIR/todo.txt";
    };
    initExtra = ''
      ,() { 
        nix shell "nixpkgs#$1"
      }
      tecw() {
        while inotifywait -q "$1"; do
          tectonic -c minimal "$1"
        done
      }
      mdw() {
        out="$(basename $1 .md).pdf"
        watchexec -e md "pandoc --pdf-engine tectonic -f markdown -o $out $1"
      }
      tm() {
        tmux new-session -AD -c $HOME -s main
      }
      td() {
        dev_dir=$(realpath "$PWD")
        session_name="$(basename $dev_dir)"
        echo "Starting session '$shell_name' on $dev_dir"
        tmux new -AD -s "$session_name" -c "$dev_dir"
      }
      devopen() {
        dev_dir="./$(fd -t d . | fzf)"
        cd "$dev_dir"
        td
      }
      zle -N tmux-dev
      zle -N tmux-main
      bindkey -r ^f
      bindkey -s ^f "fm\n"
      bindkey -r ^g
      bindkey -s ^g "devopen\n"
      bindkey -r ^n
      bindkey -s ^n "tmux-main\n"
      bindkey -r ^b
      bindkey -s ^b "mp\n"
      bindkey -r ^v
      bindkey -s ^v "nvim .\n"
    '';
  };
}
