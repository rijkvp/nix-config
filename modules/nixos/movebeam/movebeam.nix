with import <nixpkgs> { };
{ lib, rustPlatform, fetchFromGitHub }: rustPlatform.buildRustPackage rec {
  pname = "movebeam";
  version = "v0.0.4";

  src = fetchFromGitHub {
    owner = "rijkvp";
    repo = pname;
    rev = version;
    sha256 = "sha256-1CUx057JjRR1WBAWxlxVJvgUgtz+n1sTcmeZs2t+VVA=";
  };

  cargoSha256 = "sha256-R40nhkGhXWjKOpOfEc22JspQVEpNfLJnM81Byh/IAz0=";

  meta = with lib; {
    homepage = "https://github.com/rijkvp/movebeam";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
  };
}
