{pkgs, config, ... }: {
  imports = [ ../personal.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      awesome = {
        enable = true;
        laptop = true;
      };
      # bspwm.enable = true;
      stumpwm.enable = true;
      apps = {
        telegram.enable = true;
        dmenu.enable = true;
        thunar.enable = true;
        lxappearance.enable = true;
        libreoffice.enable = true;
        discord.enable = true;
        dbeaver.enable = true;
        zoom.enable = true;
        msteams.enable = true;
        etcher.enable = false;
        flameshot.enable = true;
        dar.enable = true;
        keepassxc.enable = true;
        betterlockscreen.enable = true;
        ngrok.enable = true;
        # skype.enable = true;
        # unity3d.enable = true;
        # rofi.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
      };
      gaming = {
      steam.enable = true;
      # emulators.enable = true;
      # emulators.psx.enable = true;
      };

      media = {
        documents.enable = true;
        # graphics.enable = true;
        spotify.enable = true;
        mpv.enable = true;
        # ncmpcpp.enable = true;
        pavucontrol.enable = true;
        # recording.enable = true;
        # spotify.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      # vm = {
      # qemu.enable = true;
      # };
    };
    editors = {
      default = "nvim";
      emacs = {
        enable = true;
        native-comp = true;
      };
      # idea.enable = true;
      vim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      # gnupg.enable  = true;
      newsboat.enable = true;
      babashka.enable = true;
      atuin.enable = true;
      # pass.enable   = true;
      ranger.enable = true;
      tmux.enable = true;
      youtube-dl.enable = true;
      zsh.enable = true;
    };
    services = {
      ssh.enable = true;
      syncthing.enable = true;
      lorri.enable = true;
      openvpn.enable = true;
      # calibre.enable = true;
      docker.enable = true;
      # nginx.enable = true;
      transmission.enable = true;
      # Needed occasionally to help the parental units with PC problems
      teamviewer.enable = true;
    };
    # theme.active = "tomorrow-day";
    # theme.active = "modus-operandi";
    theme.active = "modus-vivendi";
    # theme.active = "nord-dark";
    # theme.active = "gruvbox-dark";
    # theme.active = "solarized-light";
    dev = {
      cc.enable = true;
      python.enable = true;
      java.enable = true;
      clojure.enable = true;
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
      udiskie.enable = true;
      bluetooth.enable = true;
      keyboard = {
        enable = true;
        capsctrlswap = true;
      };
      # sensors.enable = true;
    };
  };

  boot.loader = {
    # systemd-boot.enable = true;
    efi = {
      #canTouchEfiVariables = mkDefault true;
      # canTouchEfiVariables = true;
    };
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
  services.xserver.layout = "us, ru, ua";
  # services.xserver.xkbOptions = "grp:caps_toggle,ctrl:swap_lalt_lctl";
  # services.xserver.xkbOptions = "grp:rctrl_toggle,ctrl:swapcaps";
  # services.xserver.xkbOptions = "grp:caps_toggle";

  # xset r rate 300 50
  services.xserver.autoRepeatDelay = 300;
  services.xserver.autoRepeatInterval = 50;

  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp0s3.useDHCP = false;

  # services.mysql = { 
  #   enable = true; 
  #   package = pkgs.mysql80;
  # };

  services.xserver.displayManager.setupCommands = ''
  # bunker
  # ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-2-1 --mode 2560x1080 --pos 1920x0 --rotate normal --output DP-2-2 --off --output DP-2-3 --off
    ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output VGA-1 --off --output DP-1 --off --output HDMI-1 --off --output DP-2 --off --output HDMI-2 --off --output DP-2-1 --primary --mode 2560x1080 --pos 1920x0 --rotate normal --output DP-2-2 --off --output DP-2-3 --off
    ${pkgs.xorg.xset}/bin/xset r rate 300 50
  '';

  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/15 * * * *      ${config.user.name}    ${pkgs.newsboat}/bin/newsboat -x reload >/dev/null 2>&1"
      # "*/15 * * * *      ${config.user.name}    date >> /tmp/cron.log"
    ];
  };

}
