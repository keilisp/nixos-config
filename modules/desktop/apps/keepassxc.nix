{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.keepassxc;
in {
  options.modules.desktop.apps.keepassxc = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ keepassxc ]; };
}
