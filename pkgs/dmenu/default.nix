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
  version = "unstable-20250525";

  src = fetchFromGitHub {
    owner = "zexk";
    repo = "dmenu";
    rev = "ef7f63e5b9e0e1bee2aa986c4568bd2c4b65cf85";
    hash = "sha256-KTV2iJpf7Mlt6453eXcZW13jRwvylaU6xiMrPCerBlQ=";
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
