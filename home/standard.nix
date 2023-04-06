{ inputs, outputs, lib, config, pkgs, theme, ... }: {
  imports = [
    ./firefox.nix
    ./newsboat.nix
    ./starship.nix
    ./rofi
    ./nvim
    ./waybar
  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  systemd.user.startServices = "sd-switch";

  home = {
    username = "rijk";
    homeDirectory = "/home/rijk";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Desktop
    glib # GTK
    wayland
    swww
    swaylock
    wtype
    wl-clipboard
    libnotify
    # Screenshots
    grim
    slurp

    # CLI Tools
    zip
    unzip
    zola
    ffmpeg # Swiss knife for videos
    imagemagick # Swiss knife for images
    pandoc # Swiss knife for documents

    neofetch
    ripgrep
    tokei
    fd
    difftastic
    sl

    du-dust
    xdg-utils
    tectonic
    watchexec
    sshfs
    btop
    sfz

    # Media
    yt-dlp
    mpc-cli
    beets

    # Backup
    restic
    borgbackup

    # GUI Programs
    brave
    gimp
    geeqie
    signal-desktop
    thunderbird
    obsidian
    appimage-run
    keepassxc
    qbittorrent
    transmission-gtk
    libreoffice-fresh

    # Spell checker
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_NL

    # Audio Management
    pavucontrol
    pulseaudio
  ];

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
    profileExtra = ''
      tecw() {
        watchexec -e tex "tectonic -c minimal $1"
      }
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

  programs.zathura = {
    enable = true;
    options = {
      adjust-open = "best-fit";
      page-padding = 1;
      guioptions = "v";
      recolor-keephue = "true";
      selection-clipboard = "clipboard";
    };
    mappings = {
      p = "navigate previous";
      n = "navigate next";
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      O = "zoom in";
      I = "zoom out";
      i = "recolor";
      "<C-p>" = "print";
    };
  };

  programs.git = {
    enable = true;
    userName = "rijkvp";
    userEmail = "rijk@rijkvp.nl";
    signing = {
      key = "~/.ssh/id_ed25519";
      signByDefault = true;
    };
    extraConfig = {
      gpg.format = "ssh";
    };
    aliases = {
      st = "status";
    };
  };


  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        decorations = "full";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
        opacity = 0.8;
        padding = {
          x = 12;
          y = 6;
        };
      };
      font = {
        normal = {
          family = "Iosevka Nerd Font";
          style = "regular";
        };
        bold = {
          family = "Iosevka Nerd Font";
          style = "bold";
        };
        size = 12.0;
      };
      mouse = {
        hide_when_typing = true;
      };
      colors = {
        primary = {
          background = theme.background;
          foreground = theme.foreground;
        };
        normal = theme.terminalColors.normal;
        bright = theme.terminalColors.bright;
      };
    };
  };

  home.file."${config.home.homeDirectory}/.local/bin/lockscreen" = {
    text = ''
      #!/bin/sh
      swaylock -eF --color '#000000' --font 'Iosevka Nerd Font'
    '';
    executable = true;
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

  services.mako = {
    enable = true;
    defaultTimeout = 10000;
    borderRadius = 7;
    backgroundColor = "${theme.background}60";
    font = "Iosevka Nerd Font";
  };

  programs.mpv = {
    enable = true;
    # Change the size of the subtitles
    bindings = {
      "ALT+k" = "add sub-scale +0.1";
      "ALT+j" = "add sub-scale -0.1";
    };
  };

  services.syncthing = {
    enable = true;
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };
  programs.ncmpcpp = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "${config.home.homeDirectory}/.dt";
      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/dl";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pics";
      videos = "${config.home.homeDirectory}/vids";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        # Firefox web browser
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "application/x-extension-htm" = [ "firefox.desktop" ];
        "application/x-extension-html" = [ "firefox.desktop" ];
        "application/x-extension-shtml" = [ "firefox.desktop" ];
        "application/xhtml+xml" = [ "firefox.desktop" ];
        "application/x-extension-xhtml" = [ "firefox.desktop" ];
        "application/x-extension-xht" = [ "firefox.desktop" ];
        # GIMP image editor
        "image/png" = [ "gimp.desktop" ];
        "image/jpeg" = [ "gimp.desktop" ];
        "image/jpg" = [ "gimp.desktop" ];
        # Thunar file manager
        "inode/directory" = [ "thunar.desktop" ];
        # Zathura pdf reader
        "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
        "application/epub+zip" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
      };
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  gtk = {
    enable = true;
    font = {
      name = "Fira Sans";
      package = pkgs.fira;
    };
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Quintom_Ink";
      package = pkgs.quintom-cursor-theme;
    };
  };

  home.stateVersion = "23.05";
}
