{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.shell.newsboat;
in {
  options.modules.desktop.shell.newsboat = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ newsboat ]; };
}
