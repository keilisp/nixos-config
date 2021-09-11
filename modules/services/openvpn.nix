{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.openvpn;
in {
  options.modules.services.openvpn = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.openvpn = {
      servers = {
        freshcodeVPN = {
          config = "config /home/kei/freshcode/vpn/client.ovpn ";
          autoStart = false;
        };
      };
    };
  };
}
