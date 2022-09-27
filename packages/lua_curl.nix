{ lib, stdenv, pkgs, ... }:

let
  name = "Lua-cURL";
  version = "0.3.13";
in stdenv.mkDerivation {
  inherit name version;

  src = pkgs.fetchFromGitHub {
    owner = "Lua-cURL";
    repo = "Lua-cURLv3";
    rev = "9f8b6dba8b5ef1b26309a571ae75cda4034279e5";
    sha256 = "1q05qjr4ssrx9vl29qjnhl6a2z0542wm61x9li829qvppmami1g0";
  };

  buildInputs = with pkgs; [ luajit pkg-config curl ];

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out
    cp ./lcurl.so $out/
  '';

  meta = {
    homepage = "https://github.com/Lua-cURL/Lua-cURLv3";
    description = "Lua-cURLv3";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
