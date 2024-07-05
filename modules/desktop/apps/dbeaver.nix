{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.dbeaver;
in {
  options.modules.desktop.apps.dbeaver = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ unstable.dbeaver-bin ]; };
}
