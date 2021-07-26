{ ... }: {
  imports = [ ../personal.nix ./hardware-configuration.nix ];

  ## Modules
  modules = {
    desktop = {
      awesome = {
        enable = true;
        laptop = true;
      };
      # bspwm.eanble = true;
      # stumpwm.eanble = true;
      apps = {
        telegram.enable = true;
        dmenu.enable = true;
        thunar.enable = true;
        lxappearance.enable = true;
        libreoffice.enable = true;
        discord.enable = true;
        zoom.enable = true;
        msteams.enable = true;
        etcher.enable = true;
        flameshot.enable = true;
        dar.enable = true;
        keepassxc.enable = true;
        betterlockscreen.enable = true;
        # skype.enable = true;
        # unity3d.enable = true;
        # rofi.enable = true;
      };
      browsers = {
        default = "brave";
        brave.enable = true;
        # firefox.enable = true;
        # qutebrowser.enable = true;
      };
      # gaming = {
      # steam.enable = true;
      # emulators.enable = true;
      # emulators.psx.enable = true;
      # };
      media = {
        # daw.enable = true;
        documents.enable = true;
        # graphics.enable = true;
        mpv.enable = true;
        ncmpcpp.enable = true;
        pavucontrol.enable = true;
        # recording.enable = true;
        # spotify.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
        # st.enable = true;
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
        chemacs = { enable = true; };
        keimacs = { enable = true; };
      };
      vim.enable = true;
    };
    shell = {
      # adl.enable = true;
      # bitwarden.enable = true;
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
      lorri.enable = true;
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
      # clojure.enable = true;
      common-lisp.enable = true;
      lua.enable = true;
      node.enable = true;
      rust.enable = true;
      # scala.enable = true;
      shell.enable = true;
    };

    hardware = { audio.enable = true; };
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
      #efiSupport = true;
      # efiInstallAsRemovable = true;
      device = "/dev/sda";
    };
  };

  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  # Configure keymap
  services.xserver.layout = "us, ru, ua";
  services.xserver.xkbOptions = "grp:caps_toggle";

  # xset r rate 300 50
  services.xserver.autoRepeatDelay = 300;
  services.xserver.autoRepeatInterval = 50;

  networking.networkmanager.enable = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so this
  # generated config replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp0s3.useDHCP = false;

}
