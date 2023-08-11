{ inputs, outputs, lib, config, pkgs, theme, ... }: {
  imports = [
    ./desktop
    ./shell
    ./programs
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

  programs.home-manager.enable = true;
  home = {
    username = "rijk";
    homeDirectory = "/home/rijk";
    stateVersion = "23.05"; # Don't change
  };

  home.packages = with pkgs; [
    # CLI Tools
    zip
    unzip
    jq
    ripgrep
    sl
    tldr
    du-dust
    xdg-utils
    neofetch
    watchexec

    ffmpeg # Swiss knife for videos
    imagemagick # Swiss knife for images

    # Document editing / LaTeX
    pandoc
    tectonic

    # Dev
    difftastic
    nodePackages.prettier
    sfz
    tokei
    zola

    sshfs
    btop

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
    mimeApps.enable = true;
  };

  gtk = {
    enable = true;
    font = {
      name = "Fira Sans";
      package = pkgs.fira;
    };
    theme = {
      # GTK theme
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
}
