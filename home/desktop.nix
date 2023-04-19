{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./standard.nix
    ./gaming.nix
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
  ];

  wayland.windowManager.hyprland = {
    nvidiaPatches = true;
  };
}

