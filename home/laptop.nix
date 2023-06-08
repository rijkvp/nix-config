{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./standard.nix
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
  ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      input {
          sensitivity = -0.1;
        }
    '';
  };
}
