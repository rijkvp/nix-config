{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/virt-manager.nix
    ../common/steam.nix
    ../common/backup.nix
    ../common/podman.nix
    #    ../common/kde.nix
    #    ../common/niri.nix
    #    ../common/gnome.nix
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
  hardware = {
    enableAllFirmware = true;
    opengl.enable = true;
  };

  # Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    # Special config to load the newer 555 driver, see https://github.com/NixOS/nixpkgs/blob/c3aa7b8938b17aebd2deecf7be0636000d62a2b9/pkgs/os-specific/linux/nvidia-x11/default.nix#L44
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58.02";
      sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
      openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
      settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
    };
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
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
