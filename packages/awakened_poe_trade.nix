{ lib, stdenv, pkgs, my, ... }:

let
  name = "Awakened-PoE-Trade";
  version = "3.19.10002";
in pkgs.appimageTools.wrapType2 {
  inherit name version;
  
  src = pkgs.fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${version}/${name}-${version}.AppImage";
    sha256 = "/ojEoH0dEM14GvxnS8KLYAYRLbZMkP8smRQZdtTnSrk=";

  };
}
