{ pkgs, ... }: {
  # Greeter: greetd + tuigreet
  environment.systemPackages = [
    pkgs.greetd.tuigreet
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /etc/greetd/sessions";
        user = "greeter";
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
    "greetd/sessions/sway.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Sway
        Exec=sway
      '';
    };
    "greetd/sessions/sway-unsupported-gpu.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Sway (unsupported GPU)
        Exec=sway --unsupported-gpu
      '';
    };
  };
}
