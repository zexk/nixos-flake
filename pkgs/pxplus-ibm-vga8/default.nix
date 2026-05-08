{ stdenv, fetchFromGitHub, fontforge, lib }:

stdenv.mkDerivation {
  pname = "pxplus-ibm-vga8-bin";
  version = "2022-06-02-r8";

  src = fetchFromGitHub {
    owner = "pocketfood";
    repo = "Fontpkg-PxPlus_IBM_VGA8";
    rev = "bf08976574bbaf4c9efb208025c71109a07e259f";
    sha256 = "sha256-WMNqehxLBeo4YC8QrH/UFSh3scvs7oAAPenPhyJ+UVA=";
  };

  nativeBuildInputs = [ fontforge ];

  buildPhase = ''
    runHook preBuild
    fontforge -lang=py -c "import fontforge; from sys import argv; \
      f = fontforge.open(argv[1]); f.generate(argv[2]);" "PxPlus_IBM_VGA8.ttf" "pxplus-ibm-vga8-bin.otf"
    runHook postBuild
  '';

  installPhase = ''
    install -Dm 444 "pxplus-ibm-vga8-bin.otf" "$out/share/fonts/truetype/pxplus-ibm-vga8-bin.otf"
  '';

  meta = with lib; {
    description = "monospace pixel font";
    homepage = "https://int10h.org/oldschool-pc-fonts/fontlist/font?ibm_vga_8x16";
    license = with licenses; [ cc-by-sa-40 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ lolisamurai ];
  };
}