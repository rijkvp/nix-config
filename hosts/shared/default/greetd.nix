{ pkgs, ... }:
{
  # Greeter: greetd + tuigreet
  environment.systemPackages = [
    pkgs.greetd.tuigreet
    pkgs.cage
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /etc/greetd/sessions";
        user = "greeter";
      };
      # First session autologins to Niri
      initial_session = {
        command = "niri-session";
        user = "rijk";
      };
    };
  };
  environment.etc = {
    "greetd/sessions/hyprland.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Hyprland
        Exec=Hyprland
      '';
    };
    "greetd/sessions/niri.desktop" = {
      text = ''
        [Desktop Entry]
        Name=niri
        Exec=niri-session
      '';
    };
  };
}
