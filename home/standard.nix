{ inputs, outputs, lib, config, pkgs, theme, ... }: {
  imports = [
    ./firefox.nix
    ./newsboat.nix
    ./shell.nix
    ./fd.nix
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
    jq
    tldr
    tokei
    nodePackages.prettier
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

    brave

    # Media
    yt-dlp
    mpc-cli
    beets

    # Backup
    borgbackup

    # GUI Programs
    appimage-run
    keepassxc

    # Spell checker
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_NL

    # Audio Management
    pavucontrol
    pulseaudio
  ];

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
      pull.rebase = "true";
      init.defaultBranch = "main";
      rebase.autoStash = "true";
    };
    aliases = {
      s = "status";
      st = "status";
      d = "diff";
      df = "diff";
      a = "add";
      c = "commit";
    };
  };


  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        decorations = "full";
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
          family = "CodeNewRoman Nerd Font";
          style = "regular";
        };
        bold = {
          family = "CodeNewRoman Nerd Font";
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
    settings = {
      user_interface = "alternative";
    };
    bindings = [
      # Vim-like keybindings for ncmpcpp
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "J"; command = [ "select_item" "scroll_down" ]; }
      { key = "K"; command = [ "select_item" "scroll_up" ]; }
      { key = "h"; command = "previous_column"; }
      { key = "l"; command = "next_column"; }
      { key = "n"; command = "next"; }
      { key = "N"; command = "next"; }
      { key = "i"; command = "seek_backward"; }
      { key = "o"; command = "seek_forward"; }
      { key = "space"; command = "pause"; }
      { key = "x"; command = "delete_playlist_items"; }
      { key = "c"; command = "clear_playlist"; }
      { key = "a"; command = "add_item_to_playlist"; }
      # Menus
      { key = "p"; command = "show_playlist"; }
      { key = "m"; command = "show_media_library"; }
      { key = "t"; command = "show_tag_editor"; }
      { key = "f"; command = "show_browser"; }
      { key = "v"; command = "show_visualizer"; }
    ];
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
        "text/html" = [ "brave-browser.desktop" ];
        "x-scheme-handler/http" = [ "brave-browser.desktop" ];
        "x-scheme-handler/https" = [ "brave-browser.desktop" ];
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
      name = "Catppuccin-Mocha-Compact-Sky-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "sky" ];
        size = "compact";
        tweaks = [ "normal" ];
        variant = "mocha";
      };
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
