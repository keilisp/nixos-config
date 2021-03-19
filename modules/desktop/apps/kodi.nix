{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.kodi;
in {
  options.modules.desktop.apps.kodi = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ kodi ]; };
}
