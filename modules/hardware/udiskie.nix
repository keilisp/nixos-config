{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.udiskie;
in {
  options.modules.hardware.udiskie = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ udiskie ]; };
}
