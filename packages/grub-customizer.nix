{ lib, stdenv, fetchzip, my, pkgs, ... }:

stdenv.mkDerivation {
  name = "grub-customizer";

  src = fetchzip {
    url =
      "https://launchpadlibrarian.net/393088879/grub-customizer_5.1.0.tar.gz";
    sha256 = "0k63vcvxz2l2rh9dh9w2kj1fiy1xhljzrh0wmvf09z2ncvpzd0m2";
  };

  buildInputs = with pkgs; [ cmake gnome3.gtkmm gettext openssl libarchive ];

  phases = "installPhase";
  installPhase = ''
    tar xf $src; cd grub-customizer-*
    cmake . && make
    sudo make install
  '';

  # meta = {
  #   homepage = "https://github.com/RaitaroH/adl";
  #   description = "popcorn anime-downloader + trackma wrapper";
  #   license = lib.licenses.gpl3;
  #   platforms = [ "x86_64-linux" ];
  #   maintainers = [ ];
  # };
}
