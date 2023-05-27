{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common
  ];

  # BIOS boot with GRUB
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; 
  };

  # LUKS encryption
  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/142580f9-79be-4adb-b194-eddaffb4b945";
    preLVM = true;
  };

  # Use ConnMann as network manager
  networking.wireless.enable = true;
  services.connman.enable = true;


  # Wireguard keys
  age.secrets.wg-laptop = {
    file = ../../secrets/wg-laptop.age;
    path = "/etc/wireguard/wg-laptop.conf";
  };

  # Network/wireguard
  networking = {
    hostName = "rnixlaptop";
    wg-quick.interfaces.wg-laptop.configFile = config.age.secrets.wg-laptop.path;
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  services = {
    # Power management
    tlp.enable = true;
    # Touchpad support
    xserver.libinput.enable = true;
  };
}
