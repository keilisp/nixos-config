{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.ledger;
in {
  options.modules.desktop.apps.ledger = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ hledger ];

    env = { LEDGER_FILE = "/home/${config.user.name}/dox/finance/main.journal"; };
  };
}
