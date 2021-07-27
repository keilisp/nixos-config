# modules/desktop/term/st.nix
#
# I like (x)st. This appears to be a controversial opinion; don't tell anyone,
# mkay?

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.alacritty;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.alacritty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      alacritty
      (makeDesktopItem {
        name = "alacritty";
        desktopName = "Alacritty Terminal";
        genericName = "Default terminal";
        icon = "utilities-terminal";
        exec = "${alacritty}/bin/alacritty";
        categories = "Development;System;Utility";
      })
    ];

    home.configFile = {
      "alacritty" = {
        source = "${configDir}/alacritty";
        recursive = true;
      };
    };
  };
}
