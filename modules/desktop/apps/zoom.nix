{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.zoom;
in {
  options.modules.desktop.apps.zoom = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ zoom-us ];

    env = {
	    SSB_HOME="$XDG_DATA_HOME/zoom";
    };
  };
}
