# modules/browser/nyxt.nix
#
# A hackable browser written in Commmon Lisp

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.nyxt;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.nyxt = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ nyxt ];

    home.configFile."nyxt/init.lisp" = {
      source = "${configDir}/nyxt/init.lisp";
      recursive = true;
    };

  };
}
