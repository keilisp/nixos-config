{ options, fetchFromGitHub, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.awesome;
in {
  options.modules.desktop.awesome = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # modules.theme.onReload.bspwm = ''
    #   ${pkgs.bspwm}/bin/bspc wm -r
    #   source $XDG_CONFIG_HOME/bspwm/bspwmrc
    # '';

    environment.systemPackages = with pkgs; [
      lightdm
      # dunst
      libnotify
      blueberry
      gnome3.networkmanagerapplet
      unclutter
      # (polybar.override {
      #   pulseSupport = true;
      #   nlSupport = true;
      # })
    ];

    services = {
      picom.enable = true;
      # redshift.enable = true;
      xserver = {
        # autoRepeatDelay = 300;
        # autoRepeatInterval = 50;
        enable = true;
        displayManager = {
          defaultSession = "none+awesome";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.awesome.enable = true;
      };
    };

    # systemd.user.services."dunst" = {
    #   enable = true;
    #   description = "";
    #   wantedBy = [ "default.target" ];
    #   serviceConfig.Restart = "always";
    #   serviceConfig.RestartSec = 2;
    #   serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    # };

    # link recursively so other modules can link files in their folders

    home.configFile = {
      # "sxhkd".source = "${configDir}/sxhkd";
      "awesome" = {
        source = "${configDir}/awesome";
        recursive = true;
      };
      # "awesome/modalbind".source = pkgs.fetchFromGitHub {
      #   owner = "crater2150";
      #   repo = "awesome-modalbind";
      #   rev = "0ba5c286ace89e2fbb600383ba9e988af42a9250";
      #   sha256 = "0sdabnhzms226sg878bylpp8z78xh5wi21vy26bj3ihda453jhpp";
      # };
      # "awesome/awesome-wm-widgets".source = pkgs.fetchFromGitHub {
      #   owner = "streetturtle";
      #   repo = "awesome-wm-widgets";
      #   rev = "ccd6bd4359593195a84458857efa7a9670b1b4cd";
      #   sha256 = "1kym67h5c9q72pabnhk0qcqyxpinjycrfc9b0cgq6azjlqw87j8d";
      # };

      "awesome/modalbind".source = pkgs.fetchzip {
        url =
          "https://github.com/crater2150/awesome-modalbind/archive/master.zip";
        sha256 = "0sdabnhzms226sg878bylpp8z78xh5wi21vy26bj3ihda453jhpp";
      };
      "awesome/awesome-wm-widgets".source = pkgs.fetchzip {
        url =
          "https://github.com/streetturtle/awesome-wm-widgets/archive/master.zip";
        sha256 = "1h2km2vfhzwgbnchbwrchz9g3cgram66fc6c4q9fq0nmrk1m4hsr";
      };
    };

  };
}
