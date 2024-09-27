{
  imports = [
    ./hardware-configuration.nix
    ../common
    ../common/sway.nix
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

  # Network: connman
  networking.wireless.enable = true;
  services.connman.enable = true;
  networking = {
    hostName = "rnixlaptop";
  };

  # OpenGL
  hardware = {
    enableAllFirmware = true;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  services = {
    # Power management
    tlp.enable = true;
    # Touchpad support
    libinput.enable = true;
  };
}
