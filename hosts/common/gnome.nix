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
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      gnome-terminal
      epiphany
      geary
      gnome-calendar
    ]);

  environment.etc = {
    "greetd/sessions/gnome.desktop" = {
      text = ''
        [Desktop Entry]
        Name=GNOME
        Exec=/etc/greetd/scripts/gnome.sh
      '';
    };
    "greetd/scripts/gnome.sh" = {
      text = ''
        #!/bin/sh
        XDG_SESSION_TYPE=wayland dbus-run-session gnome-session
      '';
      mode = "555";
    };
  };
}
