{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/virt-manager.nix
    ../common/steam.nix
    ../common/backup.nix
    ../common/podman.nix
  ];

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "btrfs" ];

  # Regularly trim SSD
  services.fstrim.enable = true;
  boot.initrd.luks.devices."cryptroot".allowDiscards = true;

  # Network
  networking = {
    hostName = "rnixpc";
    networkmanager.enable = true;
  };

  # Hardware
  hardware.enableAllFirmware = true;

  # Bluetooth - disabled for now
  #  hardware.bluetooth.enable = true;
  #  services.blueman.enable = true;
  #  boot.kernelModules = [
  #    "btusb"
  #    "bluetooth"
  #  ];

  # Nvidia graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.nvidia-vaapi-driver
    ];
  };
  boot.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
    "i2c-nvidia_gpu"
  ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # can be buggy
    powerManagement.enable = true;
  };
  # temporary fix: https://github.com/NixOS/nixpkgs/issues/375730
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.86.16"; # use new 570 drivers
    sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
    openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
    settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
    usePersistenced = false;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  #boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ]; already defined above
  environment.systemPackages = with pkgs; [ egl-wayland ];

  # Internal Hard Drive
  boot.initrd.luks.devices."crypthdint".device =
    "/dev/disk/by-uuid/57038b2d-ddf7-47b2-b253-7fd30605f4bf";
  fileSystems."/mnt/hdint" = {
    device = "/dev/mapper/crypthdint";
    mountPoint = "/mnt/hdint";
    fsType = "btrfs";
    options = [
      "autodefrag"
      "compress=zstd"
    ];
  };
}
