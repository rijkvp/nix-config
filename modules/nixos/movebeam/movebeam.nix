with import <nixpkgs> { };
{ lib, rustPlatform, fetchFromGitHub }: rustPlatform.buildRustPackage rec {
  pname = "movebeam";
  version = "v0.0.3";

  src = fetchFromGitHub {
    owner = "rijkvp";
    repo = pname;
    rev = version;
    sha256 = "sha256-llJIsDOBHRNPSExiie6MXX/ZunORbp/Sz+retvFIhd4=";
  };

  cargoSha256 = "sha256-QTCVk8bzVmbxlcRPTVtkDWDdkTeYe0/HSLEVe8AaDCM=";

  meta = with lib; {
    homepage = "https://github.com/rijkvp/movebeam";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
