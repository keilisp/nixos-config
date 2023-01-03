{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.awakened-poe-trade;
in {
  options.modules.desktop.gaming.awakened-poe-trade = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ appimage-run my.awakened_poe_trade ];
  };
}
