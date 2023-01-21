{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.stumpwm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.stumpwm = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
    ];

    ## REVIEW
    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    # master.services.picom.enable = true;
    services = {
      redshift.enable = false;
      xserver = {
        enable = true;
        # displayManager.defaultSession = "none+stumpwm";
        windowManager.stumpwm.enable = true;
        displayManager.lightdm.enable = true;
        # displayManager.lightdm.greeters.mini.enable = true;
        displayManager.lightdm.greeters.gtk.enable = true;
      };
    };

    # link recursively so other modules can link files in their folders
    home.configFile."stumpwm" = {
      source = "${configDir}/stumpwm";
      recursive = true;
    };
  };
}
