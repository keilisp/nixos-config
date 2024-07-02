{ config, options, pkgs, lib, my, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.transmission;
in {
  options.modules.services.transmission = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ transmission-gtk ];

    services.transmission = {
      enable = true;
      user = config.user.name;
      # home = "${config.user.home}/dwnlds/torrents";
      settings = {
        download-dir = "${config.user.home}/media/films";
        incomplete-dir-enabled = true;
        incomplete-dir = "${config.user.home}/media/incomplete"; 
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-host-whitelist = "*";
        rpc-host-whitelist-enabled = true;
        ratio-limit = 0;
        ratio-limit-enabled = true;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 51413 ];
      allowedUDPPorts = [ 51413 ];
    };

    user.extraGroups = [ "transmission" ];
  };
}
