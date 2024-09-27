{ ... }:
{
  imports = [ ./common.nix ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor = ,preferred,auto,1
      input {
          sensitivity = -0.1;
        }
    '';
  };
}
