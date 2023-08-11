{ pkgs, ... }: {
  imports = [
    ./standard.nix
  ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      input {
          sensitivity = -0.1;
        }
    '';
  };

  # Packges for only for laptop
  home.packages = with pkgs; [
    blueman
  ];
}
