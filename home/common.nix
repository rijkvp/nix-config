{ inputs, config, pkgs, ... }: {
  imports = [
    ./desktop
    ./shell
    ./programs
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # Nix Colors
  colorScheme = {
    slug = "my-theme";
    name = "my-theme";
    author = "rijkvp";
    palette = {
      base00 = "#161616";
      base01 = "#262626";
      base02 = "#393939";
      base03 = "#525252";
      base04 = "#dde1e6";
      base05 = "#f2f4f8";
      base06 = "#ffffff";
      base07 = "#ffffff";
      base08 = "#ed4553"; #e06c75
      base09 = "#ee9949"; #d19a66
      base0A = "#edb245"; #e5c07b
      base0B = "#8ed85a"; #98c379
      base0C = "#1cd1e9"; #56b6c2
      base0D = "#4dacf9"; #61afef
      base0E = "#cd5def"; #c678dd
      base0F = "#c63b2f"; #be5046
    };
  };

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

  # Dark theme
  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    font = {
      name = "Fira Sans";
      package = pkgs.fira;
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
