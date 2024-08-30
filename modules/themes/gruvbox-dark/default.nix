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
          ## FIXME
          gtk = {
            theme = "Gruvbox-Dark-Yellow";
            iconTheme = "oomox-gruvbox";
            cursorTheme = "Breeze";
          };
          fonts = {
            sans.name = "Iosevka";
            mono.name = "Iosevka";
          };
          colors = {
            black = "#282828";
            red = "#fb4934";
            green = "#b8bb26";
            yellow = "#fabd2f";
            blue = "#83a598";
            magenta = "#d3869b";
            cyan = "#8ec07c";
            silver = "#e2e2dc";
            grey = "#5B6268";
            brightred = "#fb4934";
            brightgreen = "#b8bb26";
            brightyellow = "#fabd2f";
            brightblue = "#83a598";
            brightmagenta = "#d3869b";
            brightcyan = "#8ec07c";
            white = "#ebdbb2";

            types.fg = "#ebdbb2";
            types.panelbg = "#21242b";
            types.border = "#1a1c25";
          };
        };

        shell.zsh.rcInit = ''
          export THEME="gruvbox-dark"
          export BAT_THEME="gruvbox"
        '';

        shell.zsh.rcFiles = [ ./config/zsh/prompt.zsh ];
        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile
            [ ./config/firefox/userChrome.css ];
        };
      };

      env = {
        THEME = "gruvbox-dark";
        BAT_THEME = "gruvbox";
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

      # GTK Themes
      # home.dataFile = with pkgs;
      #   mkMerge [
      #     {
      #       "themes/Gruvbox-Dark-Yellow".source = fetchFromGitHub {
      #         owner = "4rtzel";
      #         repo = "Gruvbox-Dark-Yellow";
      #         rev = "da38ec8c41cb88b7c4450c387960e12e4f5ac7fa";
      #         sha256 = "0fxk7vzmgvdshal3qagn731fyfmm7kzzlgqzam647b3q6lb1vg0f";
      #       };

      #       # "themes/Gruvbox-Dark-Yellow".source = fetchzip {
      #       #   url =
      #       #     "https://github.com/4rtzel/Gruvbox-Dark-Yellow/archive/master.zip";
      #       #   sha256 = "12z7q18ky0nw9j0hyqkn9h0si0b2wcx1izlz7bcfmils9dykflri";
      #       # };
      #     }
      #     {
      #       "icons/Gruvbox".source = fetchFromGitHub {
      #         owner = "jkehler";
      #         repo = "gruvbox-icons";
      #         rev = "c55ceb452883d8f999a01731a74c72e1813119a5";
      #         sha256 = "0yvzax2c4qzfcg7d4jrcpkjk7w8kdf0a8j9brjigjjsi8cvnic47";
      #       };
      #       # "icons/Gruvbox".source = fetchzip {
      #       #   url =
      #       #     "https://github.com/jkehler/gruvbox-icons/archive/master.zip";
      #       #   sha256 = "05n0qzf2i8dqpddpz9yg502vqa0gm9q9hmc35jb0cqac6rnjjzjm";
      #       # };
      #     }
      #   ];

      # Other dotfiles
      home.configFile = with config.modules;
        mkMerge [
          (mkIf desktop.awesome.enable {
            "awesome/themes/current-theme".source =
              ./config/awesome/themes/current-theme;
          })

          (mkIf desktop.term.alacritty.enable {
            "alacritty/current-theme.toml".source =
              ./config/alacritty/current-theme.toml;
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
