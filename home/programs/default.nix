{ pkgs, ... }:
{
  imports = [
    ./beets.nix
    ./devenv.nix
    ./firefox.nix
    ./foot.nix
    ./git.nix
    ./mpv.nix
    ./ncmpcpp.nix
    ./neovim.nix
    ./newsboat.nix
    ./terminal.nix
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
    yazi

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
    lazygit

    sshfs
    btop

    # Media
    yt-dlp
    mpc-cli
    bluetui

    # Backup
    borgbackup

    # GUI Programs
    appimage-run
    keepassxc
    gimp
    gthumb
    libreoffice

    # Spell checker
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en_GB-large
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
    # gThumb image viewer
    "image/png" = [
      "org.gnome.gThumb.desktop"
      "gimp.desktop"
    ];
    "image/jpeg" = [
      "org.gnome.gThumb.desktop"
      "gimp.desktop"
    ];
    "image/jpg" = [
      "org.gnome.gThumb.desktop"
      "gimp.desktop"
    ];
    # Thunar file manager
    "inode/directory" = [ "thunar.desktop" ];
    # LibreOffice
    "application/vnd.oasis.opendocument.text" = [ "writer.desktop" ];
    "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
    "application/vnd.oasis.opendocument.spreadsheet" = [ "calc.desktop" ];
    # Zathura pdf reader
    "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
    "application/epub+zip" = [ "org.pwmt.zathura-pdf-mupdf.desktop" ];
  };
}
