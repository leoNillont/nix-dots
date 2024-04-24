{ stdenv, fetchFromGitHub }:
{
  catppuccin-sddm = stdenv.mkDerivation rec {
    pname = "catppuccin-sddm";
    version = "1.0.0";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/catppuccin
    '';
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "sddm";
      rev = "v${version}";
      sha256 = "qtk4ipwfoALt7vKxxB9wxW81ZVbTfZI4kA=";
    };
  };
}
