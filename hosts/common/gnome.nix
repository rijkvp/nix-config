{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome.gnome-session
    gnome-extension-manager
    gnomeExtensions.burn-my-windows
  ];
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-terminal
    epiphany
    geary
    gnome-calendar
  ]);
}
