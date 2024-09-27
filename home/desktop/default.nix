{ config, pkgs, settings, inputs, ... }:
let
  launcher-pkg = inputs.launcher.packages.${pkgs.system}.default;
in
{
  imports = [
    ./launcher
    ./hyprland.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    launcher-pkg
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
    # Applets
    networkmanagerapplet
  ];

  # Make scripts in ~/.local/bin executable form PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Lockscreen script using swaylock
  home.file."${config.home.homeDirectory}/.local/bin/lockscreen" = {
    text = ''
      #!/bin/sh
      swaylock -eF --color '#000000' --font '${settings.font}'
    '';
    executable = true;
  };

  # Desktop services
  services = {
    ssh-agent.enable = true;
    mako = {
      enable = true;
      defaultTimeout = 10000;
      borderRadius = 4;
      backgroundColor = "#${config.colorScheme.palette.base00}60";
      font = "${settings.font}";
    };
    mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire"
        }
      '';
    };
    syncthing.enable = true;
  };
}
