{ pkgs, ... }:
let
  pname = "beeper";
  version = "4.0.478";

  src = pkgs.fetchurl {
    url = "https://beeper-desktop.download.beeper.com/builds/Beeper-4.0.478.AppImage";
    hash = "sha256-SaYOYrSvzhYC8uPPEbBMTTZjOBSDxg4iU3qAf5ZaQTs=";
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
