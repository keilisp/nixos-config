{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.youtube-dl;
in {
  options.modules.shell.youtube-dl = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ youtube-dl ]; };
}
