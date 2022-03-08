# modules/themes/tomorrow-day/default.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "tomorrow-day") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.jpg;
          gtk = {
            theme = "vimix-laptop-doder";
            iconTheme = "Arc";
            cursorTheme = "Breeze";
          };
          fonts = {
            sans.name = "Iosevka";
            mono.name = "Iosevka";
          };
          colors = {
            black = "#696c77";
            red = "#e45649";
            green = "#50a14f";
            yellow = "#c18401";
            blue = "#4078f2";
            magenta = "#a626a4";
            cyan = "#0184bc";
            silver = "#e2e2dc";
            grey = "#5B6268";
            brightred = "#e45649";
            brightgreen = "#50a14f";
            brightyellow = "#c18401";
            brightblue = "#4078f2";
            brightmagenta = "#a626a4";
            brightcyan = "#0184bc";
            white = "#ffffff";
            types.fg = "#383a42";
            types.panelbg = "#21242b";
            types.border = "#1a1c25";
          };
        };

        shell.zsh.rcInit = ''
          export THEME="tomorrow-day"
          export BAT_THEME="ansi"
        '';

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        # shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
        };
      };

      env = {
        THEME = "tomorrow-day";
        BAT_THEME = "ansi";
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      user.packages = with pkgs; [
        arc-theme
        vimix-gtk-themes
        breeze-gtk
        arc-icon-theme
      ];
      fonts = {
        fonts = with pkgs; [
          iosevka
          fira-code
          fira-code-symbols
          ibm-plex
          hack-font
          font-awesome
        ];
        fontconfig.defaultFonts = {
          # sansSerif = [ "IBM Plex Mono" ];
          # monospace = [ "IBM Plex Mono" ];
          # sansSerif = [ "Hack" ];
          # monospace = [ "Hack" ];
          sansSerif = [ "Iosevka" ];
          monospace = [ "Iosevka" ];
        };
      };

      # Compositor
      services.picom = {
        fade = true;
        fadeDelta = 1;
        fadeSteps = [ 1.0e-2 1.2e-2 ];
        shadow = true;
        shadowOffsets = [ (-10) (-10) ];
        shadowOpacity = 0.22;
        activeOpacity = 1.0;
        inactiveOpacity = 0.8;
        settings = {
          shadow-radius = 12;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
        };
      };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "${cfg.colors.magenta}"
        password-color = "${cfg.colors.magenta}"
        password-background-color = "${cfg.colors.black}"
        window-color = "${cfg.colors.types.border}"
        border-color = "${cfg.colors.types.border}"
        error-color = "${cfg.colors.red}"
      '';

      # Other dotfiles
      home.configFile = with config.modules;
        mkMerge [
          (mkIf desktop.awesome.enable {
            "awesome/themes/current-theme".source =
              ./config/awesome/themes/current-theme;
          })

          (mkIf desktop.term.alacritty.enable {
            "alacritty/current-theme.yml".source =
              ./config/alacritty/current-theme.yml;
          })

          (mkIf editors.emacs.enable {
            "emacs/current-theme.el".source = ./config/emacs/current-theme.el;
          })

          (mkIf desktop.stumpwm.enable {
            "dunst/dunstrc".text = import ./config/dunstrc cfg;
          })

          (mkIf editors.vim.enable {
            "vim/current-theme.vim".source = ./config/vim/current-theme.vim;
          })

          (mkIf desktop.media.graphics.vector.enable {
            "inkscape/templates/default.svg".source =
              ./config/inkscape/default-template.svg;
          })
        ];
    })
  ]);
}
