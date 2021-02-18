{ lib, stdenv, fetchzip, my, ... }:

stdenv.mkDerivation {
  name = "modalbind";

  src = fetchzip {
    url = "https://github.com/crater2150/awesome-modalbind/archive/master.zip";
    sha256 = "0sdabnhzms226sg878bylpp8z78xh5wi21vy26bj3ihda453jhpp";
  };

  phases = "installPhase";
  installPhase = ''
    mkdir $HOME/kek
  '';

  meta = {
    homepage = "https://github.com/crater2150/awesome-modalbind";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
