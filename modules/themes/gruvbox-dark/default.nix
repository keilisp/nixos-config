# modules/themes/gruvbox-dark/default.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "gruvbox-dark") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Gruvbox-Dark-Yellow";
            iconTheme = "Gruvbox";
            cursorTheme = "Breeze";
          };
        };

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        # shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
          # qutebrowser.userStyles = concatMapStringsSep "\n" readFile
          #   (map toCSSFile [
          #     ./config/qutebrowser/userstyles/monospace-textareas.scss
          #     ./config/qutebrowser/userstyles/stackoverflow.scss
          #     ./config/qutebrowser/userstyles/xkcd.scss
          #   ]);
        };
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
          fira-code
          fira-code-symbols
          ibm-plex
          font-awesome-ttf
        ];
        fontconfig.defaultFonts = {
          sansSerif = [ "IBM Plex Mono" ];
          monospace = [ "IBM Plex Mono" ];
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
        inactiveOpacity = 0.9;
        settings = {
          shadow-radius = 12;
          # blur-background = true;
          # blur-background-frame = true;
          # blur-background-fixed = true;
          blur-kern = "7x7box";
          blur-strength = 320;
        };
      };

      env = { THEME = "gruvbox-dark"; };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "#98971a"
        password-color = "#98971a"
        password-background-color = "#3c3836"
        window-color = "#282828"
        border-color = "#282828"
        error-color = "#cc241d"
      '';

      # GTK Themes
      home.dataFile = with pkgs;
        mkMerge [
          {
            "themes/Gruvbox-Dark-Yellow".source = fetchFromGitHub {
              owner = "4rtzel";
              repo = "Gruvbox-Dark-Yellow";
              rev = "da38ec8c41cb88b7c4450c387960e12e4f5ac7fa";
              sha256 = "12z7q18ky0nw9j0hyqkn9h0si0b2wcx1izlz7bcfmils9dykflri";
            };
          }
          {
            "icons/Gruvbox".source = fetchFromGitHub {
              owner = "jkehler";
              repo = "gruvbox-icons";
              rev = "c55ceb452883d8f999a01731a74c72e1813119a5";
              sha256 = "12z7q18ky0nw9j0hyqkn9h0si0b2wcx1izlz7bcfmils9dykflri";
            };
          }
        ];

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
            "doom/current-theme.el".source = ./config/emacs/current-theme.el;
          })

          (mkIf editors.vim.enable {
            "vim/current-theme.vim".source = ./config/vim/current-theme.vim;
          })

          # (mkIf desktop.apps.rofi.enable {
          #   "rofi/theme" = {
          #     source = ./config/rofi;
          #     recursive = true;
          #   };
          # })
          # (mkIf (desktop.bspwm.enable || desktop.stumpwm.enable) {
          #   "polybar" = {
          #     source = ./config/polybar;
          #     recursive = true;
          #   };
          #   "dunst/dunstrc".source = ./config/dunstrc;
          # })
          (mkIf desktop.media.graphics.vector.enable {
            "inkscape/templates/default.svg".source =
              ./config/inkscape/default-template.svg;
          })
          # (mkIf desktop.browsers.qutebrowser.enable {
          #   "qutebrowser/extra/theme.py".source = ./config/qutebrowser/theme.py;
          # })
        ];

    })
  ]);
}
