{ lib, pkgs, config, ... }:
with lib;
{
  options.modules.kde = {
    enable = mkEnableOption "KDE Desktop";
  };

  config = mkIf config.modules.kde.enable {
    services.xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
    };
  };
}
