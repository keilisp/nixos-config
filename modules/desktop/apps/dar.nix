{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.dar;
in {
  options.modules.desktop.apps.dar = { enable = mkEnableOption false; };

  config =
    mkIf cfg.enable { user.packages = with pkgs; [ dar file-roller ]; };
}
