{ pkgs, ... }:
let
  pname = "beeper";
  version = "4.0.522";

  src = pkgs.fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-4.0.551.AppImage"; # TOUPDATE
    hash = "sha256-OLwLjgWFOiBS5RkEpvhH7hreri8EF+JRvKy+Kdre8gM=";
  };
  beeper = pkgs.appimageTools.wrapType2 {
    inherit pname version src;
  };
in
{
  home.packages = [
    beeper
  ];

  xdg.desktopEntries = {
    beeper = {
      name = "Beeper";
      exec = "${beeper}/bin/beeper";
    };
  };
}
