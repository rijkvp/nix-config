{ ... }: {
  imports = [
    ./common.nix
  ];

  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor=DP-1,highrr,auto,1
      monitor=Unknown-1,disable

      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      # remove following if causes crashes
      env = GBM_BACKEND,nvidia-drm
    '';
  };
}
