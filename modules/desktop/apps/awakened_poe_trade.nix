{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.awakened-poe-trade;
in {
  options.modules.desktop.apps.awakened-poe-trade = { enable = mkEnableOption false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ my.awakened_poe_trade ]; };
}
