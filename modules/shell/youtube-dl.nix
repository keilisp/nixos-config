{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.shell.youtube-dl;
in {
  options.modules.desktop.shell.youtube-dl = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ youtube-dl ]; };
}
