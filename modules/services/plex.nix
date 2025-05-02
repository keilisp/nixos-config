{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.plex;
in {
  options.modules.services.plex = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    systemd.services.plex.serviceConfig.ProtectHome = lib.mkForce false;

    services.plex = {
      enable = true;
      openFirewall = true;
      user = "kei";
      group = "plex";
    };

    # networking.firewall = {
    #   allowedTCPPorts = [ 32400 ];
    #   allowedUDPPorts = [ 32400 ];
    # };

    # user.extraGroups = [ "plex" ];
  };
}
