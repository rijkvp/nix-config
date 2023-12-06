{ lib, pkgs, theme, ... }: {
  programs.fish = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "v" = "nvim";
      "fm" = "joshuto";
      "nb" = "newsboat";
      "mp" = "ncmpcpp";
      "ns" = ''nix-shell --command "fish"'';
      "nd" = ''nix develop --command "fish"'';
      "g" = "git";
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
      "gds" = "GIT_EXTERNAL_DIFF=difft git diff --staged";
      # To-Do
      "todo" = "nvim $XDG_DOCUMENTS_DIR/todo.txt";
    };
    shellInit = ''
      set -U fish_greeting
      function ,
        set -l pkgs
        for arg in $argv
            set pkgs $pkgs nixpkgs#$arg
        end
        nix shell $pkgs
      end
      function tecw
        while inotifywait -q "$argv[1]"
          tectonic -c minimal "$argv[1]"
        end
      end
      function mdw
        set out "$(basename $argv[1] .md).pdf"
        while inotifywait -q "$argv[1]"
          pandoc --pdf-engine tectonic -f markdown -o $out $argv[1]
        end
      end
      function tm
        tmux new-session -AD -c $HOME -s main
      end
      function td
        set dev_dir $(realpath "$PWD")
        set session_name "$(basename $dev_dir)"
        echo "Starting session '$shell_name' on $dev_dir"
        tmux new -AD -s "$session_name" -c "$dev_dir"
      end
      function devopen
        set dev_dir "./$(fd -t d . | fzf)"
        cd "$dev_dir"
        td
      end

      # Keybindings
      bind \cf 'fm'
      bind \cg 'devopen'
      bind \ce 'nvim'
      bind --erase \cm
      bind \cm 'mp'
    '';
  };
}
