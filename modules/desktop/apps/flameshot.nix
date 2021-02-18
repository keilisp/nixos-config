{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.flameshot;
in {
  options.modules.desktop.apps.flameshot = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ flameshot ]; };
}
