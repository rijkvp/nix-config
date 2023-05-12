{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./standard.nix
    inputs.hyprland.homeManagerModules.default
    ./hyprland.nix
  ];

  wayland.windowManager.hyprland = {
    nvidiaPatches = true;
  };
}

