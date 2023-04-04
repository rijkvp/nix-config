with import <nixpkgs> { };
{ lib, rustPlatform, fetchFromGitHub }: rustPlatform.buildRustPackage rec {
  pname = "movebeam";
  version = "v0.0.5";

  src = fetchFromGitHub {
    owner = "rijkvp";
    repo = pname;
    rev = version;
    sha256 = "sha256-mXld9n27VnD5GqFPovEaZo2pBxoDsJWhxq8LxjuEjkA=";
  };

  cargoSha256 = "sha256-86k/Qyech9lWNZeMP9gVJ9Tsaa6hFkgDaI1dFR1Nx6M=";

  meta = with lib; {
    homepage = "https://github.com/rijkvp/movebeam";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
