{ lib, pkgs, config, ... }:
with lib;
{
  options.modules.gnome = {
    enable = mkEnableOption "GNOME Desktop";
  };

  config = mkIf config.modules.kde.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
    };
    nixpkgs.overlays = [
      (final: prev: {
        xdg-desktop-portal-gtk = prev.xdg-desktop-portal-gtk.overrideAttrs (oldAttrs: {
          meta = oldAttrs.meta // {
            priority = 1;
          };
        });
      })
    ];
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnomeExtensions.burn-my-windows
    ];
  };
}
