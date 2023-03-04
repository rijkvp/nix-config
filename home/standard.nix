{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./firefox.nix
    ./newsboat.nix
    ./nvim
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
    # GTK
    glib

    # Desktop
    wayland
    wl-clipboard
    swaybg
    swaylock
    wtype
    libnotify

    # screenshots
    grim
    slurp

    # Programs
    brave
    gimp
    libreoffice
    geeqie
    signal-desktop
    newsflash
    yt-dlp
    mpc-cli
    restic
    borgbackup
    keepassxc
    du-dust
    xdg-utils
    tectonic
    watchexec
    sshfs
    btop
    sfz

    thunderbird
    obsidian
    # BitTorrent clients
    qbittorrent
    transmission-gtk

    zola
    appimage-run
    zip
    unzip
    ffmpeg
    imagemagick

    neofetch
    ripgrep
    tokei
    fd

    python3

    # Spell checker
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_NL

    # Manage commands
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
      "dupl" = "rsync -rlptDhP --delete-after --stats";
    };
    profileExtra = ''
      tecw() {
        watchexec -e tex "tectonic -c minimal $1"
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland.override { plugins = [ pkgs.rofi-calc ]; };
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
    difftastic.enable = true;
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
      shell = {
        program = "${pkgs.tmux}/bin/tmux";
        args = [ "new-session" "-A" "-D" "-s" "main" ];
      };
      colors = {
        primary = {
          background = "#000000";
          foreground = "#ffffff";
        };
      };
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.zsh}/bin/zsh";
    prefix = "C-a";
    extraConfig = ''
      unbind C-b

      # Vim keys
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      bind -r C-k resize-pane -U
      bind -r C-j resize-pane -D
      bind -r C-h resize-pane -L
      bind -r C-l resize-pane -R

      # Status bar
      set -g status-style 'bg=#111111 fg=#eeeeee'
      set-option -g status-right '#(date +"%m-%d %H:%M")'
    '';
  };

  programs.mako = {
    enable = true;
    defaultTimeout = 10000;
    borderRadius = 7;
    backgroundColor = "#00000077";
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
  home.file."${config.home.homeDirectory}/.local/bin/lockscreen" = {
    text = ''
      #!/bin/sh
      swaylock -eF --color '#000000' --font 'Iosevka Nerd Font'
    '';
    executable = true;
  };
  home.file."${config.home.homeDirectory}/.local/bin/powermenu" = {
    text = ''
      #!/bin/sh
      choice="$(printf '%s\n' Lock Suspend Hibernate Poweroff Reboot | rofi -dmenu -i -p 'Powermenu')"
      if [ "$choice" = "Lock" ]
      then
          lockscreen
          exit 0
      fi
      if [ "$choice" = "Suspend" ]
      then
          systemctl suspend
          exit 0
      fi
      if [ "$choice" = "Hibernate" ]
      then
          systemctl hibernate
          exit 0
      fi
      if [ "$choice" = "Poweroff" ]
      then
          systemctl poweroff
          exit 0
      fi
      if [ "$choice" = "Reboot" ]
      then
          systemctl reboot
          exit 0
      fi
    '';
    executable = true;
  };

  # Emoji picker
  xdg.dataFile."emoji".source = ./emoji;
  home.file."${config.home.homeDirectory}/.local/bin/emojipicker" = {
    text = ''
      #!/bin/sh
      chosen=$(cut -d ';' -f1 ~/.local/share/emoji | rofi -dmenu -i -p Emoji | sed "s/ .*//")
      [ -z "$chosen" ] && exit
      wtype "$chosen"
    '';
    executable = true;
  };

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
