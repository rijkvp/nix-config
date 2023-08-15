{ config, pkgs, theme, ... }: {
  imports = [
    ./eww
    ./rofi
    ./hyprland.nix
    ./waybar.nix
  ];

  home.packages = with pkgs; [
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
  ];

  # Make scripts in ~/.local/bin executable form PATH
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Lockscreen script using swaylock
  home.file."${config.home.homeDirectory}/.local/bin/lockscreen" = {
    text = ''
      #!/bin/sh
      swaylock -eF --color '#000000' --font 'Iosevka Nerd Font'
    '';
    executable = true;
  };

  # Desktop services
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
    mako = {
      enable = true;
      defaultTimeout = 10000;
      borderRadius = 7;
      backgroundColor = "${theme.background}60";
      font = "Iosevka Nerd Font";
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
