let
  borgbackupMonitor = { config, pkgs, lib, ... }: with lib; {
    key = "borgbackupMonitor";
    _file = "borgbackupMonitor";
    # See Nix Wiki: this ensures backups are made if device was powered off at scheduled time
    config.systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (name: value:
      nameValuePair "borgbackup-job-${name}" {
        timerConfig.Persistent = mkForce true;
      }
    );
  };
in
{ inputs, outputs, lib, config, pkgs, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      ../common
      borgbackupMonitor
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  # Wireguard keys
  age.secrets.wg-desktop = {
    file = ../../secrets/wg-desktop.age;
    path = "/etc/wireguard/wg-desktop.conf";
  };

  # Network/wireguard
  networking.hostName = "rnixpc";
  networking.wg-quick.interfaces.wg-desktop.configFile = config.age.secrets.wg-desktop.path;

  # Hardware
  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
    # Nvidia modesetting
    nvidia.modesetting.enable = true;
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

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Internal Hard Drive
  boot.initrd.luks.devices."crypthdint".device = "/dev/disk/by-uuid/69f1b535-d8e7-496e-ab3e-53d78d45c0c5";
  fileSystems."/mnt/hdint" = {
    device = "/dev/mapper/crypthdint";
    mountPoint = "/mnt/hdint";
    fsType = "btrfs";
    options = [ "autodefrag" "compress=zstd" ];
  };

  # Borg Backup
  services.borgbackup.jobs.home-backup = {
    paths = "/home/rijk";
    exclude = [
      ".cache"
      ".local/share/Steam"
      "*/.cache"
      "*/.git"
      "**/target"
    ];
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat /etc/home-backup-passphrase";
    };
    repo = "/mnt/hdint/home-backup";
    compression = "zstd,8";
    startAt = "daily";
    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = -1;
    };
  };

  # Steam
  programs.steam = {
    enable = true;
  };
}
