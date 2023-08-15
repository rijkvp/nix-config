{ ... }: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./mpv.nix
    ./ncmpcpp.nix
    ./neovim.nix
    ./newsboat.nix
    ./zathura.nix
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
