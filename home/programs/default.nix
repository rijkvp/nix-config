{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./beets.nix
    ./firefox.nix
    ./foot.nix
    ./git.nix
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
    gimp

    # Spell checker
    hunspell
    hunspellDicts.en_US
    hunspellDicts.nl_NL

    # Audio Management
    pavucontrol
    pulseaudio

    # Email
    meli
    msmtp # SMTP client
    w3m # HTML viewer

    # AI
    ollama
  ];

  # Default programs
  xdg.mimeApps.defaultApplications = {
    # Firefox web browser
    "text/html" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/obsidian" = [ "obsidian.desktop" ];
    # GIMP image editor
    "image/png" = [ "gimp.desktop" ];
    "image/jpeg" = [ "gimp.desktop" ];
    "image/jpg" = [ "gimp.desktop" ];
    # Thunar file manager
    "inode/directory" = [ "thunar.desktop" ];
    # Zathura pdf reader
    "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
    "application/epub+zip" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
    # LibreOffice 
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
    "application/vnd.oasis.opendocument.spreadsheet" = [ "calc.desktop" ];
  };
}
