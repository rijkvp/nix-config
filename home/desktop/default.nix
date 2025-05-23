{
  config,
  pkgs,
  settings,
  inputs,
  ...
}:
let
  launchr = inputs.launchr.packages.${pkgs.system}.default;
in
{
  imports = [
    ./hyprland.nix
    ./launchr
    ./niri
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    launchr
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
    wf-recorder
    # Applets
    networkmanagerapplet
  ];

  # Make scripts in ~/.local/bin executable form PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

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
      settings = {
        default-timeout = 10000;
        border-radius = 4;
        background-color = "#${config.colorScheme.palette.base00}60";
        font = "${settings.font}";
      };
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
