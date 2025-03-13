{ pkgs, config, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.nvidia-vaapi-driver
    ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # can be buggy
    powerManagement.enable = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    # temporary fix: https://github.com/NixOS/nixpkgs/issues/375730 TOUPDATE
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.86.16"; # use new 570 drivers
      sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
      usePersistenced = false;
    };
  };
  boot.kernelModules = [
    "nvidia"
    "nvidia-modeset"
    "nvidia-uvm"
    "nvidia-drm"
    "i2c-nvidia_gpu"
  ];
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = with pkgs; [ egl-wayland ];
}
