{ pkgs, lib, stdenv, fetchFromGitHub, my, ... }:

stdenv.mkDerivation {
  name = "solarc-theme";

  # src = fetchFromGitHub {
  #   owner = "schemar";
  #   repo = "solarc-theme";
  #   rev = "0a017126a05b9e8b9e71304bfab55922840c503e";
  #   sha256 = "1zkl9wv5i1nzhv3i6nc8nlqypk4i3dlhmd1ckfjbjfrnmwwz9k8l";
  # };

  src = fetchFromGitHub {
    owner = "horst3180";
    repo = "arc-theme";
    rev = "8290cb813f157a22e64ae58ac3dfb5983b0416e6";
    sha256 = "1lxiw5iq9n62xzs0fks572c5vkz202jigndxaankxb44wcgn9zyf";
  };

  buildInputs = with pkgs; [ automake autoconf autoreconfHook ];

  # TODO make buildPhase
  phases = "installPhase";
  installPhase = ''
    sh $src/autogen.sh --prefix=$HOME/.local
    sudo make install
  '';

  meta = {
    homepage = "https://github.com/RaitaroH/adl";
    description = "popcorn anime-downloader + trackma wrapper";
    license = lib.licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
