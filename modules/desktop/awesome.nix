{ options, fetchFromGitHub, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.awesome;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.awesome = {
    enable = mkBoolOpt false;
    laptop = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.theme.onReload.awesome = ''
      ${pkgs.coreutils}/bin/echo 'awesome.restart()' | ${pkgs.awesome}/bin/awesome-client 
    '';

    environment.systemPackages = with pkgs; [
      lightdm
      libnotify
      blueberry
      networkmanagerapplet
      unclutter
      # FIXME
      xorg.xf86videointel
      xorg.xbacklight
      brightnessctl
    ];

    services = {
      # picom.enable = true;
      redshift.enable = true;
      xserver = {
        # autoRepeatDelay = 300;
        # autoRepeatInterval = 50;
        enable = true;
        displayManager = {
          defaultSession = "none+awesome";
          lightdm.enable = true;
          # lightdm.greeters.mini.enable = true;
          lightdm.greeters.gtk.enable = true;
        };
        windowManager.awesome.enable = true;
      };
    };

    home.configFile = mkMerge [
      {
        "awesome" = {
          source = "${configDir}/awesome";
          recursive = true;
        };

        "awesome/modalbind".source = pkgs.fetchFromGitHub {
          owner = "crater2150";
          repo = "awesome-modalbind";
          rev = "0ba5c286ace89e2fbb600383ba9e988af42a9250";
          sha256 = "0sdabnhzms226sg878bylpp8z78xh5wi21vy26bj3ihda453jhpp";
        };

        "awesome/awesome-wm-widgets".source = pkgs.fetchFromGitHub {
          owner = "streetturtle";
          repo = "awesome-wm-widgets";
          rev = "ccd6bd4359593195a84458857efa7a9670b1b4cd";
          sha256 = "1kym67h5c9q72pabnhk0qcqyxpinjycrfc9b0cgq6azjlqw87j8d";
        };
      }

      (mkIf (cfg.laptop == true) {
        "awesome/rc.lua" = { source = "${configDir}/awesome/laptop/rc.lua"; };

        "awesome/autostart.sh" = mkIf cfg.laptop {
          source = "${configDir}/awesome/laptop/autostart.sh";
        };
      })

      (mkIf (cfg.laptop == false) {
        "awesome/rc.lua" = { source = "${configDir}/awesome/desktop/rc.lua"; };
        "awesome/autostart.sh" = {
          source = "${configDir}/awesome/desktop/autostart.sh";
        };
      })

    ];

  };
}
