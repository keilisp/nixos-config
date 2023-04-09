{ lib, stdenv, pkgs, my, ... }:

let
  name = "Awakened-PoE-Trade";
  version = "3.20.10008";
in pkgs.appimageTools.wrapType2 {
  inherit name version;
  
  # TODO check out --no-overlay flag
  src = pkgs.fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${version}/${name}-${version}.AppImage";
    sha256 = "05XSA+7CymwvRTGGeBO2m+CGGIYqapzY9o9u2DzQGiY=";

  };
}
