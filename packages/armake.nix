{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "armake";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "KoffeinFlummi";
    repo = "armake";
    rev = "v${version}";
    hash = "sha256-cAlXQe/WUs7EuQDYRKifAU5XH1LL+AEUpz96COfrTdo=";
  };

  nativeBuildInputs = with pkgs; [
    gcc
    openssl
  ];

  meta = {
    description = "A C implementation of Arma modding tools (PAA conversion, binarization/rapification, PBO packing). (WIP";
    homepage = "https://github.com/KoffeinFlummi/armake";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "armake";
    platforms = lib.platforms.all;
  };
}
