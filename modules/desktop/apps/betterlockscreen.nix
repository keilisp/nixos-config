{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.betterlockscreen;
in {
  options.modules.desktop.apps.betterlockscreen = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ betterlockscreen ]; };
}
