{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/virt-manager.nix
    ../common/steam.nix
    ../common/backup.nix
    ../common/podman.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  # Network
  networking = {
    hostName = "rnixpc";
    networkmanager.enable = true;
  };

  # Hardware
  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    # Nvidia modesetting
    nvidia = {
      modesetting.enable = true;
      # Testing open drivers
      # open = true;
    };
  };
  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];

  # Nvida support variables
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    WLR_DRM_NO_ATOMIC = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    _JAVA_AWT_WM_NONREPARENTING = "1";
    XCURSOR_SIZE = "24";

    LIBSEAT_BACKEND = "logind";
  };

  # Internal Hard Drive
  boot.initrd.luks.devices."crypthdint".device = "/dev/disk/by-uuid/57038b2d-ddf7-47b2-b253-7fd30605f4bf";
  fileSystems."/mnt/hdint" = {
    device = "/dev/mapper/crypthdint";
    mountPoint = "/mnt/hdint";
    fsType = "btrfs";
    options = [ "autodefrag" "compress=zstd" ];
  };
}
