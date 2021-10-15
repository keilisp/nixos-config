{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.teamviewer;
in {
  options.modules.services.teamviewer = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.teamviewer.enable = true;
    # systemd.services.teamviewerd.serviceConfig = lib.mkForce {
    #   Type = "forking";
    #   ExecStart = "${pkgs.teamviewer}/bin/teamviewerd daemon start";
    #   GuessMainPID = true;
    #   ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    #   Restart = "on-abort";
    #   StartLimitInterval = "60";
    #   StartLimitBurst = "10";
    # };
  };
}
