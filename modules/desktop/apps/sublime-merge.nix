{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.sublime-merge;
in {
  options.modules.desktop.apps.sublime-merge = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ sublime-merge ];
  };
}
