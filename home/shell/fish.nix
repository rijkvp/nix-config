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
      "nb" = "newsboat";
      "mp" = "ncmpcpp";
      "ns" = ''nix-shell --command "fish"'';
      "nd" = ''nix develop --command "fish"'';
      "g" = "git";
      "gc" = "ssh-add -l > /dev/null || ssh-add && git add . && git commit";
      "gp" = "ssh-add -l > /dev/null || ssh-add && git add . && git commit && git push";
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
      "org" = "cd $XDG_DOCUMENTS_DIR/org && commandline -f repaint && nvim todo.org";
      # Zellij
      "zj" = "zellij";
      # Lazygit
      "lg" = "lazygit";
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
      function latexw
        set build_dir $(mktemp -d)
        mkdir -p "$build_dir"
        echo "Compiling $argv[1] to $build_dir"
        set latexcmd "latexmk -pdf -halt-on-error -quiet -output-directory=$build_dir"
        set out "$(basename $argv[1] .tex).pdf"
        xdg-open "$out" &
        eval $latexcmd "$argv[1]" && cp "$build_dir/$out" .
        while inotifywait -q "$argv[1]"
          eval $latexcmd "$argv[1]" && cp "$build_dir/$out" .
        end
      end
      function mdw
        set out "$(basename $argv[1] .md).pdf"
        while inotifywait -q "$argv[1]"
          pandoc -f markdown -o $out $argv[1]
        end
      end
      function orgtohtml
        pandoc -f org -o index.html "$argv[1]"
        while inotifywait -q "$argv[1]"
          pandoc -f org -o index.html "$argv[1]"
        end
      end
      function orgtopdf
        set out "$(basename $argv[1] .org).pdf"
        pandoc -f org -o "$out" "$argv[1]"
        while inotifywait -q "$argv[1]"
          pandoc -f org -o "$out" "$argv[1]"
        end
      end
      # switch directory using yazi
      function yy
          set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file=$tmp
	      if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- $cwd
              commandline -f repaint # update prompt
          end
          rm -f -- $tmp
      end

      # Keybindings
      bind \cf 'yy'
      bind \ce 'nvim'
      bind \cn 'mp'
      bind \co 'org'
      bind \cw 'zi; commandline -f repaint'

      # Less direnv output
      set -gx DIRENV_LOG_FORMAT ""
    '';
  };
}
