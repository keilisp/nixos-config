{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.mullvadvpn;
in {
  options.modules.services.mullvadvpn = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.mullvad-vpn.enable = true;

    services.mullvad-vpn.package = pkgs.mullvad-vpn;
  };
}
