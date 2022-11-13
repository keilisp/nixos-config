{ lib, stdenv, pkgs, my, ... }:

#TODO patch Setting.xml to be able to save builds (nix store is read-only obv)

let
  name = "PathOfBuilding";
  version = "2.21.1";
in stdenv.mkDerivation {
  inherit name version;

  src = pkgs.fetchFromGitHub {
    owner = "PathOfBuildingCommunity";
    repo = "PathOfBuilding";
    rev = "09abce610c2555692120e67afa63a7bba9e52f63";
    sha256 = "0h4j8kls4vsl30b0bcx1xjgyl3rx6hbjzybkq1pcm6vvxabbgzda";
  };

  buildInputs = with pkgs; [ luajit unzip my.lua_curl my.pobfrontend ];

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
    cd $out
    for f in ./tree*.zip; do unzip $f;done
    unzip ./runtime-win32.zip lua/xml.lua lua/base64.lua lua/sha1.lua
    mv lua/*.lua .
    rmdir lua
    rm runtime-win32.zip
    cp ${my.lua_curl}/lcurl.so .

  '';

  meta = {
    homepage = "https://pathofbuilding.community/";
    description = "Path Of Building Community Fork";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
