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
        zoom.enable = true;
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
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        firefox.enable = true;
        nyxt.enable = true;
      };
      gaming = {
        steam.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
        # lutris.enable = true;
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
        virtualbox.enable = true;
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
      nvidia.enable = true;
      sensors.enable = true;
      udiskie.enable = true;
      keyboard.xmodmap = true;
      # fs.enable = true;
      bluetooth.enable = true;
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

  # hybrid sleep when press power button
  services.logind.extraConfig = ''
    # HandlePowerKey=suspend
    IdleAction=ignore
    IdleActionSec=1m
  '';

  # screen locker
  programs.xss-lock.enable = false;

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # Configure keymap
  
  # services.xserver.extraLayouts.caps_grp_shiftcaps_none = {
  #   description = "US layout with alt-gr greek";
  #   languages   = [ "eng"];
  #   # symbolsFile = "${config.dotfiles.configDir}/kbdlayout/caps_grp_shiftcaps_none";
  #   symbolsFile = "${config.dotfiles.configDir}/kbdlayout/symbols/caps_grp_shiftcaps_none";
  # };

  services.xserver.extraLayouts.us-greek = {
    description = "US layout with alt-gr greek";
    languages   = [ "eng" ];
    symbolsFile = "/home/kei/nix/nixos-config/config/kbdlayout/symbols/us-greek";
  };
  # services.xserver.xkbOptions = "grp:caps_toggle";
  services.xserver.layout = "us, ru, ua";

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
    ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --pos 4480x0 --rotate right --output HDMI-0 --mode 1920x1080 --pos 0x362 --rotate normal --output DP-0 --primary --mode 2560x1080 --pos 1920x362 --rotate normal --output DP-1 --off
    # 3 monitors 24-horizontal
    # ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-D-0 --mode 1920x1080 --pos 4480x362 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x362 --rotate normal --output DP-0 --primary --mode 2560x1080 --pos 1920x362 --rotate normal --output DP-1 --off
    ${pkgs.xorg.xset}/bin/xset r rate 300 50
    ${pkgs.xorg.xinput}/bin/xinput --set-prop 'SINOWEALTH Wired Gaming Mouse' 'libinput Accel Speed' -0.8
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

  # services.xserver.config = ''
  #   Section "ServerLayout"
  #       Identifier     "Layout0"
  #       Screen      0  "Screen0" 0 0
  #       InputDevice    "Keyboard0" "CoreKeyboard"
  #       InputDevice    "Mouse0" "CorePointer"
  #       Option         "Xinerama" "0"
  #   EndSection

  #   Section "Files"
  #   EndSection

  #   Section "InputDevice"
  #       # generated from default
  #       Identifier     "Mouse0"
  #       Driver         "mouse"
  #       Option         "Protocol" "auto"
  #       Option         "Device" "/dev/input/mice"
  #       Option         "Emulate3Buttons" "no"
  #       Option         "ZAxisMapping" "4 5"
  #   EndSection

  #   Section "InputDevice"
  #       # generated from default
  #       Identifier     "Keyboard0"
  #       Driver         "kbd"
  #   EndSection

  #   Section "Monitor"
  #       # HorizSync source: edid, VertRefresh source: edid
  #       Identifier     "Monitor0"
  #       VendorName     "Unknown"
  #       ModelName      "BenQ G2420HDBL"
  #       HorizSync       24.0 - 83.0
  #       VertRefresh     50.0 - 76.0
  #       Option         "DPMS"
  #   EndSection

  #   Section "Device"
  #       Identifier     "Device0"
  #       Driver         "nvidia"
  #       VendorName     "NVIDIA Corporation"
  #       BoardName      "NVIDIA GeForce GTX 1050 Ti"
  #   EndSection

  #   Section "Screen"
  #       Identifier     "Screen0"
  #       Device         "Device0"
  #       Monitor        "Monitor0"
  #       DefaultDepth    24
  #       Option         "Stereo" "0"
  #       Option         "nvidiaXineramaInfoOrder" "DFP-2"
  #       Option         "metamodes" "DVI-D-0: nvidia-auto-select +4480+0 {rotation=right, ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: nvidia-auto-select +0+420 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: nvidia-auto-select +1920+420 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
  #       Option         "SLI" "Off"
  #       Option         "MultiGPU" "Off"
  #       Option         "BaseMosaic" "off"
  #       SubSection     "Display"
  #           Depth       24
  #       EndSubSection
  #   EndSection

  # '';


  # hardware.opengl.enable = true;

}
