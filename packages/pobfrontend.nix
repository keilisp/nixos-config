{ lib, stdenv, pkgs, ... }:

let name = "PoBFrontend";
    version = "1.0.0";
in stdenv.mkDerivation {
  inherit name version;

  src = pkgs.fetchFromGitHub {
    owner = "bcareil";
    repo = "pobfrontend";
    rev = "29feacd42e1f11274bad66514e6ad1a8d732ec21";
    sha256 = "060zdg2z2hda6mf6974k32z9i30myhfym8kn9s56l46hwk58r4p0";
  };

  buildInputs = with pkgs; [
    qt5.full
    # qt5.qttools
    luajit
    curl
    zlib
    libGL
    ttf_bitstream_vera
    liberation_ttf
    meson
    pkg-config
    ninja
  ];

  buildPhase = ''
    meson -Dbuildtype=release $src build
    cd build
    ninja
  '';

  installPhase = ''
    mkdir -p $out
    ls -lah
    cp -r ./* $out/
    '';

  meta = {
    homepage = "https://gitlab.com/bcareil/pobfrontend#branch=luajit";
    description = "pobfrontend";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
