{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.idea;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.idea = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ jetbrains.idea-community ];

    env = {
      DVDCSS_CACHE = "$XDG_DATA_HOME/dvdcss";
    };
  };
}
