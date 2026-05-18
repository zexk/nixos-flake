{
  stdenv,
  fetchurl,
  unzip,
  otf2bdf,
  bdfresize,
  fonttosfnt,
  lib,
}:

stdenv.mkDerivation {
  pname = "pxplus-ibm-vga8-2x";
  version = "2.2";

  src = fetchurl {
    url = "https://int10h.org/oldschool-pc-fonts/download/oldschool_pc_font_pack_v2.2_linux.zip";
    sha256 = "sha256-sw3D7MmTGtLdi+dRfdAYE8iDShkRtYKrdkMZG0Gj11k=";
  };

  nativeBuildInputs = [
    unzip
    otf2bdf
    bdfresize
    fonttosfnt
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip $src
    runHook postUnpack
  '';

  buildPhase = ''
    runHook preBuild
    otf2bdf -r 72 -p 16 "ttf - Px (pixel outline)/PxPlus_IBM_VGA_8x16.ttf" > ibm_vga_8x16.bdf || true
    bdfresize -f 2.0 ibm_vga_8x16.bdf > ibm_vga_8x16-2x.bdf
    fonttosfnt -o pxplus-ibm-vga8-2x.otb ibm_vga_8x16-2x.bdf
    runHook postBuild
  '';

  installPhase = ''
    install -Dm 444 "pxplus-ibm-vga8-2x.otb" "$out/share/fonts/opentype/pxplus-ibm-vga8-2x.otb"
  '';

  meta = with lib; {
    description = "PxPlus IBM VGA 8x16 bitmap font scaled 2x via bdfresize";
    homepage = "https://int10h.org/oldschool-pc-fonts/";
    license = with licenses; [ cc-by-sa-40 ];
    platforms = platforms.all;
  };
}
