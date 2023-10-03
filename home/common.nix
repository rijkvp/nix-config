{ inputs, outputs, lib, config, pkgs, theme, ... }: {
  imports = [
    ./desktop
    ./shell
    ./programs
  ];
  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home = {
    username = "rijk";
    homeDirectory = "/home/rijk";
    stateVersion = "23.05"; # Don't change
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
