# modules/themes/modus-operandi/default.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "modus-operandi") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.jpg;
          gtk = {
            theme = "vimix-laptop-amethyst";
            iconTheme = "Arc";
            cursorTheme = "Breeze";
          };
          fonts = {
            sans.name = "IBM Plex Mono";
            mono.name = "IBM Plex Mono";
          };
          colors = {
            black = "#000000";
            red = "#a60000";
            green = "#006800";
            yellow = "#813e00";
            blue = "#0030a6";
            magenta = "#721045";
            cyan = "#00538b";
            silver = "#e2e2dc";
            grey = "#5B6268";
            brightred = "#7f1010";
            brightgreen = "#104410";
            brightyellow = "#5f4400";
            brightblue = "#002f88";
            brightmagenta = "#752f50";
            brightcyan = "#12506f";
            white = "#eeeeee";

            types.fg = "#000000";
            types.panelbg = "#21242b";
            types.border = "#1a1c25";
          };
        };

        shell.zsh.rcInit = ''
          export THEME="modus-operandi"
          export BAT_THEME="ansi"
        '';

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
        };
      };

      env = {
        THEME = "modus-operandi";
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
        packages = with pkgs; [
          iosevka
          fira-code
          fira-code-symbols
          ibm-plex
          hack-font
          font-awesome
        ];
        fontconfig.defaultFonts = {
          sansSerif = [ "IBM Plex Mono" ];
          monospace = [ "IBM Plex Mono" ];
          # sansSerif = [ "Hack" ];
          # monospace = [ "Hack" ];
          # sansSerif = [ "Iosevka" ];
          # monospace = [ "Iosevka" ];
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
          {
            # Sourced from sessionCommands in modules/themes/default.nix
            # "xtheme/90-theme".source = ./config/Xresources;
          }
          (mkIf desktop.awesome.enable {
            "awesome/themes/current-theme".source =
              ./config/awesome/themes/current-theme;
          })

          (mkIf desktop.term.alacritty.enable {
            "alacritty/current-theme.toml".source =
              ./config/alacritty/current-theme.toml;
          })

          (mkIf desktop.term.ghostty.enable {
            "ghostty/current-theme".source =
              ./config/ghostty/current-theme;
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
