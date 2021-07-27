{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.betterlockscreen;
in {
  options.modules.desktop.apps.betterlockscreen = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ betterlockscreen ];

    ## FIXME
    # systemd.services.betterlockscreen = {
    #   enable = true;
    #   # unitConfig = {
    #   description = "Lock screen when going to sleep/suspend";
    #   before = [ "sleep.target" "suspend.target" ];
    #   # Before = "suspend.target";
    #   # };

    #   wantedBy = [ "sleep.target" "suspend.target" ];

    #   serviceConfig = {
    #     User = "kei";
    #     Type = "forking";
    #     Environment = "DISPLAY=:0";
    #     ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
    #     TimeoutSec = "infinity";
    #     # ExecStartPost = ''${pkgs.sleep}/bin/sleep 1'';
    #   };
    # };
  };
}

