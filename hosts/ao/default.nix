{ pkgs, config, ... }: {
  imports = [ ../personal.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      awesome = {
        enable = true;
        laptop = false;
      };
      stumpwm.enable = false;
      apps = {
        telegram.enable = true;
        dmenu.enable = true;
        thunar.enable = true;
        lxappearance.enable = true;
        discord.enable = true;
        slack.enable = true;
        zoom.enable = true;
        zotero.enable = true;
        sublime-merge.enable = true;
        msteams.enable = true;
        libreoffice.enable = true;
        etcher.enable = false;
        dbeaver.enable = true;
        flameshot.enable = true;
        dar.enable = true;
        keepassxc.enable = true;
        # betterlockscreen.enable = true;
        kodi.enable = true;
        ngrok.enable = true;
        ledger.enable = true;
        # skype.enable = true;
        # unity3d.enable = true;
        packet-tracer.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        nyxt.enable = false;
      };
      gaming = {
        steam.enable = true;
        path-of-building.enable = true;
        awakened-poe-trade.enable = true;
        # exilence-next.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
        lutris.enable = true;
      };

      media = {
        documents.enable = true;
        spotify.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        ncmpcpp.enable = true;
        pavucontrol.enable = true;
        recording.enable = true;
      };

      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      vm = {
        # lxd.enable = true;
        qemu.enable = true;
        virtualbox.enable = false;
      };
    };
    editors = {
      default = "nvim";
      emacs = {
        enable = true;
        native-comp = true;
        server = true;
      };
      idea.enable = true;
      vim.enable = true;
    };

    shell = {
      zsh.enable = true;
      # adl.enable = true;
      direnv.enable = true;
      git.enable = true;
      # gnupg.enable  = true;
      tmux.enable = true;
      newsboat.enable = true;
      babashka.enable = true;
      atuin.enable = true;
      difftastic.enable = true;
      # pass.enable   = true;
      ranger.enable = true;
      youtube-dl.enable = true;
    };
    services = {
      ssh.enable = true;
      syncthing.enable = true;
      borgbackup.enable = true;
      lorri.enable = true;
      openvpn.enable = true;
      # calibre.enable = true;
      docker.enable = true;
      # fail2ban.enable = true;
      jellyfin.enable = false;
      plex.enable = true;
      # nginx.enable = true;
      transmission.enable = true;
      # Needed occasionally to help the parental units with PC problems
      teamviewer.enable = true;
    };
    # theme.active = "tomorrow-day";
    theme.active = "modus-operandi";
    # theme.active = "modus-vivendi";
    # theme.active = "nord-dark";
    # theme.active = "gruvbox-dark";
    # theme.active = "solarized-light";
    dev = {
      cc.enable = true;
      python.enable = false;
      java.enable = true;
      clojure.enable = true;
      haskell.enable = true;
      R.enable = true;
      scheme.enable = true;
      common-lisp.enable = true;
      lua.enable = true;
      fennel = {
        enable = true;
        jit = true;
      };
      node.enable = true;
      rust.enable = true;
      # scala.enable = true;
      shell.enable = true;
    };

    hardware = {
      audio.enable = true;
      nvidia.enable = true;
      sensors.enable = true;
      udiskie.enable = true;
      printing.enable = true;
      # fs.enable = true;
      bluetooth.enable = true;
      keyboard = {
        enable = true;
        shiftcapsnone = true;
        kmonad = {
          enable = true;
          hhkb-colemak-dh = true;
        };
      };
    };
  };

  boot.loader = {
    # systemd-boot.enable = true;
    efi = { canTouchEfiVariables = true; };
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      # efiInstallAsRemovable = true;
      device = "nodev";
      memtest86.enable = true;
    };
  };

  # hybrid sleep when press power button
  services.logind.extraConfig = ''
    # HandlePowerKey=suspend
    IdleAction=ignore
    IdleActionSec=1m
  '';

  services.smartd.enable = true;

  # screen locker
  programs.xss-lock.enable = false;

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # Configure keymap

  # services.xserver.xkb.options = "grp:caps_toggle";
  # services.xserver.xkb.layout = "us, ru, ua";
  # services.xserver.variant = "colemak_dh,,";

  # xset r rate 300 50
  services.xserver.autoRepeatDelay = 300;
  services.xserver.autoRepeatInterval = 50;
  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp0s3.useDHCP = true;

  ### TODO export (seems not working )
  services.xserver.displayManager.setupCommands = ''
    # 3 monitors 24-vertical
    # ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --mode 1920x1080 --pos 4480x0 --rotate right --output HDMI-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --mode 1920x1080 --pos 0x362 --rotate normal --output DP-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --primary --mode 2560x1080 --pos 1920x362 --rotate normal

    # 3 monitors 24-horizontal
    ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --pos 4480x0 --rotate normal --output HDMI-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --primary --mode 2560x1080 --pos 1920x0 --rotate normal

    # 2 monitors 24-vertical
    # ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --mode 1920x1080 --pos 2560x0 --rotate right --output HDMI-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --off --output DP-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --primary --mode 2560x1080 --pos 0x420 --rotate normal

    # 2 monitors 24-horizontal
    # ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --mode 1920x1080 --pos 2560x0 --rotate normal --output HDMI-0 --off --output DP-0 --brightness 1.0 --gamma 0.76:0.75:0.68 --primary --mode 2560x1080 --pos 0x0 --rotate normal

    ${pkgs.xorg.xset}/bin/xset r rate 300 50

    # FIXME If device is not present causes LIGHTDM to FAIL!!! FIXME
    # ${pkgs.xorg.xinput}/bin/xinput --set-prop 'SINOWEALTH Wired Gaming Mouse' 'libinput Accel Speed' -0.8

    # ${pkgs.xorg.setxkbmap}/bin/setxkbmap -layout "us, ru, ua"
  '';

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/15 * * * *      ${config.user.name}    ${pkgs.newsboat}/bin/newsboat -x reload >/dev/null 2>&1"
      # "*/15 * * * *      ${config.user.name}    date >> /tmp/cron.log"
    ];
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };
  };

  # hardware.opengl.enable = true;

}
