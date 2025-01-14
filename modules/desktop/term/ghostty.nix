{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.term.ghostty;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.ghostty = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ ghostty ];

    home.configFile = {
      "ghostty" = {
        source = "${configDir}/ghostty";
        recursive = true;
      };
    };
  };
}
