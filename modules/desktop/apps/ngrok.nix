{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.ngrok;
in {
  options.modules.desktop.apps.ngrok = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ ngrok ]; };
}
