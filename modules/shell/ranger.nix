{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.shell.ranger;
in {
  options.modules.desktop.shell.ranger = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ ranger ueberzug ]; };
}
