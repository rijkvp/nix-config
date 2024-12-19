{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/virt-manager.nix
    ../common/steam.nix
    ../common/backup.nix
    ../common/podman.nix
  ];

  # Zen kernel with full preemption
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = [
    "preempt=full"
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

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  boot.kernelModules = [
    "btusb"
    "bluetooth"
  ];

  # Nvidia graphics
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  #boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ]; already defined above
  environment.systemPackages = with pkgs; [ egl-wayland ];

  # Internal Hard Drive
  boot.initrd.luks.devices."crypthdint".device = "/dev/disk/by-uuid/57038b2d-ddf7-47b2-b253-7fd30605f4bf";
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
