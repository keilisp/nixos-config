{ pkgs, config, ... }: {
  imports = [ ../personal.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      awesome = {
        enable = true;
        laptop = false;
      };
      # bspwm.eanble = true;
      # stumpwm.eanble = true;
      apps = {
        telegram.enable = true;
        dmenu.enable = true;
        thunar.enable = true;
        lxappearance.enable = true;
        discord.enable = true;
        zoom.enable = true;
        msteams.enable = true;
        libreoffice.enable = true;
        etcher.enable = true;
        flameshot.enable = true;
        dar.enable = true;
        keepassxc.enable = true;
        betterlockscreen.enable = true;
        kodi.enable = true;
        # grub-customizer.enable = true;
        # skype.enable = true;
        # unity3d.enable = true;
        # rofi.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        # qutebrowser.enable = true;
      };
      # gaming = {
      # steam.enable = true;
      # emulators.enable = true;
      # emulators.psx.enable = true;
      # };
      media = {
        documents.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        ncmpcpp.enable = true;
        pavucontrol.enable = true;
        recording.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
        # st.enable = true;
      };
      vm = {
        # lxd.enable = true;
        qemu.enable = true;
        virtualbox.enable = true;
      };
    };
    editors = {
      default = "nvim";
      emacs = {
        enable = true;
        native-comp = true;
        chemacs = { enable = true; };
        keimacs = { enable = true; };
      };
      vim.enable = true;
    };
    shell = {
      # adl.enable = true;
      direnv.enable = true;
      git.enable = true;
      # gnupg.enable  = true;
      # tmux.enable   = true;
      newsboat.enable = true;
      # pass.enable   = true;
      ranger.enable = true;
      youtube-dl.enable = true;
      zsh.enable = true;
    };
    services = {
      ssh.enable = true;
      syncthing.enable = true;
      # calibre.enable = true;
      # docker.enable = true;
      # fail2ban.enable = true;
      # gitea.enable = true;
      # jellyfin.enable = true;
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
      python.enable = true;
      clojure.enable = true;
      common-lisp.enable = true;
      lua.enable = true;
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
      # fs.enable = true;
      # bluetooth.enable = true;
    };
  };

  boot.loader = {
    # systemd-boot.enable = true;
    efi = { canTouchEfiVariables = true; };
    grub = {
      enable = true;
      version = 2;
      useOSProber = true;
      efiSupport = true;
      # efiInstallAsRemovable = true;
      device = "nodev";
    };
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # Configure keymap
  # services.xserver.layout = "us, ru, ua";
  # FIXME temporarly disabling ua for testing qmk layout
  services.xserver.layout = "us, ru";
  services.xserver.xkbOptions = "grp:caps_toggle";

  # xset r rate 300 50
  # services.xserver.autoRepeatDelay = 300;
  # services.xserver.autoRepeatInterval = 50;

  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp0s3.useDHCP = true;

  ### TODO export (seems not working )
  services.xserver.displayManager.setupCommands = ''
    # 3 monitors 24-vertical
    ${pkgs.xlibs.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --pos 4480x0 --rotate right --output HDMI-0 --mode 1920x1080 --pos 0x362 --rotate normal --output DP-0 --primary --mode 2560x1080 --pos 1920x362 --rotate normal --output DP-1 --off
    # 3 monitors 24-horizontal
    # ${pkgs.xlibs.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --pos 4480x362 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x362 --rotate normal --output DP-0 --primary --mode 2560x1080 --pos 1920x362 --rotate normal --output DP-1 --off
    ${pkgs.xlibs.xset}/bin/xset r rate 300 50
    ${pkgs.xlibs.xinput}/bin/xinput --set-prop 'SINOWEALTH Wired Gaming Mouse' 'libinput Accel Speed' -0.8
  '';

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/15 * * * *      ${config.user.name}    ${pkgs.newsboat}/bin/newsboat -x reload >/dev/null 2>&1"
      # "*/15 * * * *      ${config.user.name}    date >> /tmp/cron.log"
    ];
  };

  hardware.pulseaudio.extraConfig =
    "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";

  # services.mpd = {
  #   enable = true;
  #   # FIXME
  #   # user = "${config.user.name}";
  #   # group = "users";
  #   # musicDirectory = "/home/kei/musx";
  #   # extraConfig = ''
  #   #   music_directory     "~/musx"
  #   #   bind_to_address     "any"
  #   #   bind_to_address     "~/.config/mpd/socket"
  #   #   port                "6600"
  #   #   auto_update         "yes"
  #   #   filesystem_charset  "UTF-8"
  #   #   audio_output {
  #   #     type    "alsa"
  #   #             name    "mpd-alsa"
  #   #             mixer_type    "software"
  #   #   }
  #   #   audio_output {
  #   #   type      "fifo"
  #   #             name        "toggle_visualizer"
  #   #             path        "/tmp/mpd.fifo"
  #   #             format      "44100:16:2"
  #   #   }
  #   # '';

  #   extraConfig = ''
  #     audio_output {
  #       type "pulse"
  #       name "Pulseaudio"
  #       server "127.0.0.1"
  #       }
  #   '';
  # };

}
