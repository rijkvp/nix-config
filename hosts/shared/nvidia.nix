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
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #   version = "570.86.16"; # use new 570 drivers
    #   sha256_64bit = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
    #   openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
    #   settingsSha256 = "sha256-9rtqh64TyhDF5fFAYiWl3oDHzKJqyOW3abpcf2iNRT8=";
    #   usePersistenced = false;
    # };
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.124.04";
      sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q=";
      openSha256 = "sha256-KCGUyu/XtmgcBqJ8NLw/iXlaqB9/exg51KFx0Ta5ip0=";
      settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
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
