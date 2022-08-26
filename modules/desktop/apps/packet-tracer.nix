{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.packet-tracer;
in {
  options.modules.desktop.apps.packet-tracer = {
    enable = mkEnableOption false;
  };

  config =
    mkIf cfg.enable { user.packages = with pkgs; [ my.cisco-packet-tracer ]; };
}
