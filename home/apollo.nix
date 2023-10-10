{ pkgs, ... }: {
  imports = [
    ./common.nix
  ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor = ,preferred,auto,1.0
      input {
          sensitivity = -0.1;
        }
    '';
  };

  home.packages = with pkgs; [
    blueman
  ];
}
