{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.msteams;
in {
  options.modules.desktop.apps.msteams = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ teams-for-linux ]; };
}
