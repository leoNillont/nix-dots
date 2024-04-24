{ lib, stdenvNoCC, fetchzip, kdePackages }:

stdenvNoCC.mkDerivation {
  pname = "catppuccin-sddm";
  version = "6c5f9de";

  src = fetchzip {
    url = "https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip";
    hash = "sha256-+YxKzuu2p46QoCZykXLYFwkXcJ+uJ7scwDU7vJ4b1pA=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapQtApps = true;

  propagatedUserEnvPkgs = with kdePackages; [
    qtdeclarative
    qtsvg
  ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/
    cp -aR $src $out/share/sddm/themes/catppuccin-mocha
  '';

}
