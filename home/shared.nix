{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./desktop
    ./shell
    ./programs
    ./backup.nix
    inputs.nix-colors.homeManagerModules.default
  ];
  nix = {
    settings.substituters = [ "http://nixvps/" ];
  };

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # Nix Colors
  # https://github.com/EdenEast/nightfox.nvim
  colorScheme = {
    slug = "nightfox";
    name = "nightfox";
    author = "EdenEast";
    palette = {
      base00 = "#192330";
      base01 = "#212e3f";
      base02 = "#29394f";
      base03 = "#575860";
      base04 = "#71839b";
      base05 = "#cdcecf";
      base06 = "#aeafb0";
      base07 = "#e4e4e5";
      base08 = "#c94f6d";
      base09 = "#f4a261";
      base0A = "#dbc074";
      base0B = "#81b29a";
      base0C = "#63cdcf";
      base0D = "#719cd6";
      base0E = "#9d79d6";
      base0F = "#d67ad2";
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
