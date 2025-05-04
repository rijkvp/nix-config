{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/backup.nix
    ../shared/distrobox.nix
    ../shared/nvidia.nix
    ../shared/podman.nix
    ../shared/steam.nix
    ../shared/virt-manager.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest; # latest stable kernel

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

  # Internal Hard Drive
  boot.initrd.luks.devices."crypthdint".device =
    "/dev/disk/by-uuid/57038b2d-ddf7-47b2-b253-7fd30605f4bf";
  boot.initrd.compressor = "zstd";
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
