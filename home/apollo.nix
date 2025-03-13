{ pkgs, ... }:
{
  imports = [ ./shared.nix ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor = eDP-1,preferred,auto,1
      monitor = ,preferred,auto,1,mirror,eDP-1
      input {
        sensitivity = -0.1;
      }
      exec-once = powerprofilesctl set power-saver
    '';
  };

  home.packages = with pkgs; [ blueman ];
}
