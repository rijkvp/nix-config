{ ... }: {
  imports = [
    ./common.nix
  ];

  wayland.windowManager.hyprland = {
    nvidiaPatches = true;
  };
}

