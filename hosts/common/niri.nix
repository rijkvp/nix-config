{ inputs, ... }:
{
  imports = [ inputs.niri.nixosModules.niri ];

  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.enable = true;

  environment.etc = {
    "greetd/sessions/niri.desktop" = {
      text = ''
        [Desktop Entry]
        Name=niri
        Exec=niri-session
      '';
    };
  };
}
