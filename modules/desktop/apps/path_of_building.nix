{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.path-of-building;
in {
  options.modules.desktop.apps.path-of-building = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      my.path_of_building
      my.pobfrontend
      qt5.full

      (writeScriptBin "path-of-building" ''
          #!${stdenv.shell}
        cd ${my.path_of_building} && exec ${my.pobfrontend}/pobfrontend
      '')
    ];
  };
}
