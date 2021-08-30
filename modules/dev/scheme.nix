# modules/dev/scheme.nix
#
# I don't use scheme. Perhaps one day...

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.scheme;
in {
  options.modules.dev.scheme = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ guile racket ]; };
}
