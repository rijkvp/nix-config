{ pkgs, ... }:
let
  pname = "beeper";
  version = "4.0.604";

  src = pkgs.fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-4.0.604.AppImage"; # TOUPDATE
    hash = "sha256-60PBTfbgYf73bCY2Qxqy8I2vMCziHf5Nuw78cpbVi/8=";
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
