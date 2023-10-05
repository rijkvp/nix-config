{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./beets.nix
    ./firefox.nix
    ./git.nix
    ./joshuto.nix
    ./mpv.nix
    ./ncmpcpp.nix
    ./neovim.nix
    ./newsboat.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    # CLI Tools
    du-dust
    dua
    file
    jq
    ripgrep
    sl
    tldr
    trashy
    unzip
    inotify-tools
    xdg-utils
    zip

    ffmpeg # Swiss knife for videos
    imagemagick # Swiss knife for images

    # Document editing / LaTeX
    pandoc
    tectonic

    # Dev
    difftastic
    just
    nodePackages.prettier
    sfz
    tokei
    zola
    onefetch

    sshfs
    btop

    # Media
    yt-dlp
    mpc-cli

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

  services.kdeconnect = {
    enable = true;
  };

  # Default programs
  xdg.mimeApps.defaultApplications = {
    # Firefox web browser
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
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
}
