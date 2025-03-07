{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/virt-manager.nix
    ../common/podman.nix
    inputs.impermanence.nixosModules.impermanence
  ];

  # Persistent files
  environment.persistence."/persist" = {
    directories = [
      "/etc/ssh"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/var/lib/cups"
      "/var/lib/nixos" # required for permanent uids/gids
      "/var/lib/fprint"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/tailscale"
      "/var/db/sudo/lectured"
      "/var/lib/docker"
      "/var/lib/bluetooth"
      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
      }
    ];
    files = [
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
  networking.networkmanager = {
    enable = true;
    # disabled since this does not work with eduroam
    # wifi.backend = "iwd"; # is better than the default 'wpa_supplicant'
  };

  # Touchpad support
  services.libinput.enable = true;

  # OpenGL
  hardware.graphics.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Laptop power management
  powerManagement.enable = true;
  # Use power-profiles-daemon to be compatible with GNOME
  services.power-profiles-daemon.enable = true;
}
