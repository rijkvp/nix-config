{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  # Persistent files
  environment.persistence."/persist" = {
    directories = [
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/cups"
      "/var/lib/fprint"
      "/var/db/sudo/lectured"
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
