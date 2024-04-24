{ lib, stdenvNoCC, fetchFromGitHub, kdePackages }:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm";
  version = "6c5f9de";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "6c5f9de6ded7ceb2d97051b6b437392332e36e47";
    hash = "sha256-TMElu+90/qtk4ipwfoALt7vKxxB9wxW81ZVbTfZI4kA=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  buildInputs = with kdePackages; [
    qtdeclarative
    qtsvg
  ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/catppuccin
  '';

}
