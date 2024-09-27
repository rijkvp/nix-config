{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    # Remove packages that are not needed
  ];

  environment.etc = {
    "greetd/sessions/i3.desktop" = {
      text = ''
        [Desktop Entry]
        Name=plasma6
        Exec=startplasma-wayland
      '';
    };
  };
}
