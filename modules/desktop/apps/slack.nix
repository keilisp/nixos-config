{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.slack;
in {
  options.modules.desktop.apps.slack = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ slack ]; };
}
