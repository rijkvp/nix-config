{ config, pkgs, nixosModules, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ] ++ (builtins.attrValues nixosModules);

  modules.virt-manager.enable = true;

  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Persistent files
  environment.persistence."/persist" = {
    directories = [
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/cups"
      "/var/lib/fprint"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/tailscale"
      "/var/db/sudo/lectured"
      "/var/lib/docker"
    ];
    files = [
      "/etc/machine-id"
      "/etc/nix/id_rsa"
      "/var/lib/cups/printers.conf"
      "/var/lib/logrotate.status"
    ];
  };

  # EFI bootloader: systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking: NetworkManager
  networking.hostName = "rnixbased";
  networking.networkmanager.enable = true;

  # Touchpad support
  services.xserver.libinput.enable = true;

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Laptop power management
  powerManagement.enable = true;
  services.tlp.enable = true;
}
