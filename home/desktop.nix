{ ... }: {
  imports = [
    ./standard.nix
  ];

  wayland.windowManager.hyprland = {
    nvidiaPatches = true;
  };
}

