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
      xorg.xbacklight
      brightnessctl
    ];

    services = {
      # picom.enable = true;
      redshift.enable = false;
      displayManager = {
        defaultSession = "none+awesome";
      };
      xserver = {
        # autoRepeatDelay = 300;
        # autoRepeatInterval = 50;
        enable = true;
        displayManager = {
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
          rev = "9c6dc31a7fb6bffceef4501cda5267fba8d72669";
          sha256 = "011mfnmmwb8jj4816pydyxz69m2y02q49sy5056agw6xry24bq7z";
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
