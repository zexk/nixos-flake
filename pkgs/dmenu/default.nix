{
  stdenv,
  fetchFromGitHub,
  lib,
  libx11,
  libxinerama,
  libxft,
  freetype,
  fontconfig,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "dmenu";
  version = "unstable-20260526";

  src = fetchFromGitHub {
    owner = "zexk";
    repo = "dmenu";
    rev = "20a82f9ff9afa47295d39abeb440eb82276fc59b";
    hash = "sha256-RUFCX7J6KRH0P1oTR10s56r2qN22p4yYr3zMt1/EQVs=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libx11
    libxinerama
    libxft
    freetype
    fontconfig
  ];

  preBuild = ''
    makeFlagsArray+=(PREFIX="$out" "CC=$CC -lm")
  '';

  meta = {
    description = "Dynamic menu for X, zexk's fork";
    homepage = "https://github.com/zexk/dmenu";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "dmenu";
  };
}
