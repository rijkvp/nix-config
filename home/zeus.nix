{ ... }: {
  imports = [
    ./common.nix
  ];

  wayland.windowManager.hyprland = {
    enableNvidiaPatches = true;
    extraConfig = ''
      monitor=,highrr,auto,1

      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      # remove following if causes crashes
      env = GBM_BACKEND,nvidia-drm
    '';
  };
}
