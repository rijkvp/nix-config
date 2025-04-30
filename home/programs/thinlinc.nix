{
  pkgs,
  ...
}:

let
  thinlinc-client = pkgs.stdenv.mkDerivation {
    pname = "thinlinc-client";
    version = "4.18.0-3768";

    src = pkgs.fetchurl {
      url = "https://www.cendio.com/downloads/clients/tl-4.18.0-3768-client-linux-dynamic-x86_64.tar.gz";
      sha256 = "001cs7r22rdaqvzravrhixbnbjimb62ivsqk86248l7l34db6dvx";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = with pkgs; [
      xorg.libX11
      xorg.libXext
      xorg.libXrender
      xorg.libXfixes
      xorg.libXdamage
      xorg.libXcomposite
      xorg.libXrandr
      zlib
      openssl
      pcsclite
      alsa-lib
    ];

    unpackPhase = "tar xzf $src";

    installPhase = ''
      mkdir -p $out
      cp -r tl-4.18.0-3768-client-linux-dynamic-x86_64/* $out/
    '';
  };
in
{

  home.packages = [
    thinlinc-client
  ];
}
