{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.dmenu;
in {
  options.modules.desktop.apps.dmenu = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    # TODO mb export it to func

    user.packages = with pkgs; [
      ### Modus Operandi
      (mkIf (config.modules.theme.active == "modus-operandi")
        (writeScriptBin "dmenu" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu -nb '#ffffff' -sf '#721045' -sb '#f8f8f8' -nf '#282828' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "modus-operandi")
        (writeScriptBin "dmenu_run" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_run -nb '#ffffff' -sf '#721045' -sb '#f8f8f8' -nf '#282828' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "modus-operandi")
        (writeScriptBin "dmenu_path" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_path -nb '#ffffff' -sf '#721045' -sb '#f8f8f8' -nf '#282828' -fn 'Iosevka:pixelsize=13' "$@"
        ''))

      ### Modus Vivendi
      (mkIf (config.modules.theme.active == "modus-vivendi")
        (writeScriptBin "dmenu" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu -nb '#000000' -sf '#feacd0' -sb '#110b11' -nf '#ffffff' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "modus-vivendi")
        (writeScriptBin "dmenu_run" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_run -nb '#000000' -sf '#feacd0' -sb '#110b11' -nf '#ffffff' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "modus-vivendi")
        (writeScriptBin "dmenu_path" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_path -nb '#000000' -sf '#feacd0' -sb '#110b11' -nf '#ffffff' -fn 'Iosevka:pixelsize=13' "$@"
        ''))

      ### Solarized Light
      (mkIf (config.modules.theme.active == "solarized-light")
        (writeScriptBin "dmenu" ''
          #!${stdenv.shell}
          exec ${
            pkgs.dmenu.overrideAttrs
              (oldAttrs: rec {
                # patches = [ ./patches/dmenu-password-5.0.diff ];
              })
          }/bin/dmenu -nb '#eee8d5' -sf '#268bd2' -sb '#fdf6e3' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@" ''))
      (mkIf (config.modules.theme.active == "solarized-light")
        (writeScriptBin "dmenu_run" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_run -nb '#eee8d5' -sf '#268bd2' -sb '#fdf6e3' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "solarized-light")
        (writeScriptBin "dmenu_path" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_path -nb '#eee8d5' -sf '#268bd2' -sb '#fdf6e3' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))

      ### Gruvbox Dark
      (mkIf (config.modules.theme.active == "gruvbox-dark")
        (writeScriptBin "dmenu" ''
          #!${stdenv.shell}
          exec ${
            pkgs.dmenu.overrideAttrs
              (oldAttrs: rec {
                # patches = [ ./patches/dmenu-password-5.0.diff ];
              })
          }/bin/dmenu -nb '#282828' -sf '#fabd2f' -sb '#504945' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "gruvbox-dark")
        (writeScriptBin "dmenu_run" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_run -nb '#282828' -sf '#fabd2f' -sb '#504945' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "gruvbox-dark")
        (writeScriptBin "dmenu_path" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_path -nb '#282828' -sf '#fabd2f' -sb '#504945' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))

      ### Tomorrow Day
      (mkIf (config.modules.theme.active == "tomorrow-day")
        (writeScriptBin "dmenu" ''
          #!${stdenv.shell}
          exec ${
            pkgs.dmenu.overrideAttrs
              (oldAttrs: rec {
                # patches = [ ./patches/dmenu-password-5.0.diff ];
              })
          }/bin/dmenu -nb '#ffffff' -sf '#fabd2f' -sb '#4271ae' -nf '#eab700' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "tomorrow-day")
        (writeScriptBin "dmenu_run" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_run -nb '#ffffff' -sf '#fabd2f' -sb '#4271ae' -nf '#eab700' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "tomorrow-day")
        (writeScriptBin "dmenu_path" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_path -nb '#ffffff' -sf '#fabd2f' -sb '#4271ae' -nf '#eab700' -fn 'Iosevka:pixelsize=13' "$@"
        ''))

      ### Nord Dark
      (mkIf (config.modules.theme.active == "nord-dark")
        (writeScriptBin "dmenu" ''
          #!${stdenv.shell}
          exec ${
            pkgs.dmenu.overrideAttrs
              (oldAttrs: rec {
                # patches = [ ./patches/dmenu-password-5.0.diff ];
              })
          }/bin/dmenu -nb '#3b4252' -sf '#88c0d0' -sb '#4c566a' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "nord-dark")
        (writeScriptBin "dmenu_run" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_run -nb '#3b4252' -sf '#88c0d0' -sb '#4c566a' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
      (mkIf (config.modules.theme.active == "nord-dark")
        (writeScriptBin "dmenu_path" ''
          #!${stdenv.shell}
           exec ${
             pkgs.dmenu.overrideAttrs (oldAttrs: rec {
               # patches = [ ./patches/dmenu-password-5.0.diff ];
             })
           }/bin/dmenu_path -nb '#3b4252' -sf '#88c0d0' -sb '#4c566a' -nf '#a89984' -fn 'Iosevka:pixelsize=13' "$@"
        ''))
    ];
  };
}
