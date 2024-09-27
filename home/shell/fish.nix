{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "v" = "nvim";
      "fm" = "yazi";
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
      # AI
      "ai" = "ollama run llama3.1";
      # Org mode
      "org" = "cd $XDG_DOCUMENTS_DIR/org && nvim todo.org";
      # Zellij main session
      "zj" = "zellij attach main --create";
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
        set out "$(basename $argv[1] .tex).pdf"
        xdg-open "$out" &
        tectonic -c minimal "$argv[1]"
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
      function orgw
        pandoc -f org -o index.html "$argv[1]"
        while inotifywait -q "$argv[1]"
          pandoc -f org -o index.html "$argv[1]"
        end
      end
      function has_flake
          set dir (pwd)
          while test $dir != "/"
              if test -e $dir/flake.nix
                  set -g FLAKE_DIR (realpath $dir)
                  return 0
              end
              set dir (dirname $dir)
          end
          return 1
      end
      function tm
        tmux new-session -A -c $HOME -s main
      end
      function td
        set dev_dir $(realpath "$PWD")
        set session_name "$(basename $dev_dir)"
        set start_cmd "fish"
        echo "Starting session '$shell_name' on $dev_dir"
        if has_flake
          echo "Entering Nix dev shell '$FLAKE_DIR'"
          set start_cmd "nix develop "$FLAKE_DIR" --command fish"
        end
        if set -q ZELLIJ
          # Detach & switch if already in tmux
          # tmux attach -AD -s "$session_name" -c "$dev_dir" -d "$start_cmd"
          # zellij switch -t "$session_name"
          echo "Already in session!"
        else
          tmux new -AD -s "$session_name" -c "$dev_dir" "$start_cmd"
        end
        # tmux send-keys -t "$session_name" "nvim" C-m
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
