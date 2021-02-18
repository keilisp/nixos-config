{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.thunar;
in {
  options.modules.desktop.apps.thunar = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      xfce.thunar
      xfce.tumbler # for previews
    ];
  };
}
