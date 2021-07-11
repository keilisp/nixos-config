# modules/browser/brave.nix --- https://publishers.basicattentiontoken.org
#
# A hackable browser written in Commmon Lisp

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.nyxt;
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
