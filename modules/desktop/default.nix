{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message =
          "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion = let srv = config.services;
        in srv.xserver.enable || srv.sway.enable || !(anyAttrs
          (n: v: isAttrs v && anyAttrs (n: v: isAttrs v && v.enable)) cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      feh # image viewer
      xclip
      xdotool
      xorg.xwininfo
      xorg.xkill
      libqalculate # calculator cli w/ currency conversion
      # (makeDesktopItem {
      #   name = "scratch-calc";
      #   desktopName = "Calculator";
      #   icon = "calc";
      #   exec = ''scratch "${tmux}/bin/tmux new-session -s calc -n calc qalc"'';
      #   categories = "Development";
      # })
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        ubuntu_font_family
        dejavu_fonts
        symbola
        open-sans
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        hack-font
        iosevka
        ibm-plex
        nerdfonts
      ];
    };

    ## Apps/Services
    services.xserver.displayManager.lightdm.greeters.mini.user =
      config.user.name;

    services.picom = {
      # backend = "glx";
      backend = "xrender";
      vSync = true;
      opacityRules = [
        "100:class_g = 'Firefox'"
        "100:class_g = 'Brave-browser'"
        "100:class_g = 'discord'"
        "100:class_g = 'TelegramDesktop'"
        "100:class_g = 'VirtualBox Machine'"
        "95:class_g = 'Alacritty'"
        "95:class_g = 'Emacs'"
        # Art/image programs where we need fidelity
        "100:class_g = 'Gimp'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'dmenu'"
        "100:class_g = 'feh'"
        "100:class_g = 'flameshot'"
        "100:class_g = 'zoom'"
        "100:class_g = 'mpv'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'Peek'"
        "100:_NET_WM_STATE@:32a = '_NET_WM_STATE_FULLSCREEN'"
      ];
      shadow = true;
      # shadowExclude = [
      #   # Put shadows on notifications, the scratch popup and rofi only
      #   "! name~='(rofi|scratch|Dunst|dmenu)$'"
      # ];
      settings = {
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "class_g = 'Rofi'"
          "class_g = 'dmenu'"
          "_GTK_FRAME_EXTENTS@:c"
        ];

        # Unredirect all windows if a full-screen opaque window is detected, to
        # maximize performance for full-screen windows. Known to cause
        # flickering when redirecting/unredirecting windows.
        unredir-if-possible = true;

        # GLX backend: Avoid using stencil buffer, useful if you don't have a
        # stencil buffer. Might cause incorrect opacity when rendering
        # transparent content (but never practically happened) and may not work
        # with blur-background. My tests show a 15% performance boost.
        # Recommended.
        glx-no-stencil = true;

        # Use X Sync fence to sync clients' draw calls, to make sure all draw
        # calls are finished before picom starts drawing. Needed on
        # nvidia-drivers with GLX backend for some users.
        xrender-sync-fence = true;
      };
    };

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gtk2";
    qt = {
      style = "gtk2";
      platformTheme = "gtk2";
    };

    env.GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc";

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg .android \
      .eclipse .java .m2 .screenlayout .swt .tldrc
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
