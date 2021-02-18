{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.lxappearance;
in {
  options.modules.desktop.apps.lxappearance = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      lxappearance
      gsettings_desktop_schemas
      gtk-engine-murrine
      gtk_engines
    ];
  };
}
