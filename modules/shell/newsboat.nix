{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.newsboat;
in {
  options.modules.shell.newsboat = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ newsboat ];

    home.configFile = {
      "newsboat" = {
        source = "${configDir}/newsboat";
        recursive = true;
      };
    };
  };
}
