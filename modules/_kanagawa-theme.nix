{ pkgs }:

pkgs.kanagawa-gtk-theme.overrideAttrs (old: {
  version = "0-unstable-2025-10-23";
  src = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Kanagawa-GKT-Theme";
    rev = "55ca4ba249eba21f861b9866b71ab41bb8930318";
    hash = "sha256-UdMoMx2DoovcxSp/zBZ3PRv/Qpj+prd0uPm1gmdak2E=";
  };
  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.sassc ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes
    cd themes
    HOME=$out bash install.sh -n Kanagawa --dest $out/share/themes --tweaks dragon outline

    runHook postInstall
  '';
})
