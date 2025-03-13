{ pkgs, ... }:
let
  pname = "beeper";
  version = "4.0.522";

  src = pkgs.fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-4.0.522.AppImage"; # TOUPDATE
    hash = "sha256-qXVZEIk95p5sWdg6stQWUQn/w4+JQmDR6HySlGC5yAk=";
  };
  beeper = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
  };
in
{
  home.packages = [
    beeper
  ];
}
