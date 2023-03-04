{ inputs, outputs, lib, config, pkgs, ... }: {
   imports = [
    ./standard.nix
    ./waybar.nix
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
  ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor=,1600x900, 0x0, 1
      '';
    };
}
