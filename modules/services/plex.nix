{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.plex;
in {
  options.modules.services.plex = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.plex.enable = true;
    services.plex.openFirewall = true;
    services.plex.user = "kei";
    services.plex.group = "plex";

    # networking.firewall = {
    #   allowedTCPPorts = [ 32400 ];
    #   allowedUDPPorts = [ 32400 ];
    # };

    # user.extraGroups = [ "plex" ];
  };
}
