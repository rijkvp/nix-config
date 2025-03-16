{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/bluetooth.nix
    ../shared/distrobox.nix
    ../shared/podman.nix
    ../shared/virt-manager.nix
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

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # Laptop power management
  powerManagement.enable = true;
  services.power-profiles-daemon.enable = true; # power-profiles-daemon is compatible with GNOME
}
