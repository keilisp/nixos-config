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
          # gtk = {
          #   theme = "Vimix";
          #   iconTheme = "Arc";
          #   cursorTheme = "Breeze";
          # };
        };

        shell.zsh.rcInit = ''
          export THEME="modus-operandi"
          export BAT_THEME="ansi-light"
        '';

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        # shell.tmux.rcFiles = [ ./config/tmux.conf ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
        };
      };

      env = {
        THEME = "modus-operandi";
        BAT_THEME = "ansi-light";
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
          font-awesome-ttf
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
        text-color = "#721045"
        password-color = "#721045"
        password-background-color = "#f8f8f8"
        window-color = "#ffffff"
        border-color = "#ffffff"
        error-color = "#a60000"
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
            "alacritty/current-theme.yml".source =
              ./config/alacritty/current-theme.yml;
          })

          (mkIf editors.emacs.enable {
            "emacs/current-theme.el".source = ./config/emacs/current-theme.el;
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
