{ pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./beeper.nix
    ./beets.nix
    ./devenv.nix
    ./firefox.nix
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
    yazi
    libqalculate # calculator

    ffmpeg # Swiss knife for videos
    imagemagick # Swiss knife for images

    # Document editing / LaTeX
    pandoc
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        xifthen
        ifmtarg
        framed
        paralist
        titlesec
        biblatex
        blindtext
        ;
    })
    biber

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
    transmission_4-gtk

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
