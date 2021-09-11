# modules/dev/clojure.nix --- https://clojure.org/

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.clojure;
    configDir = config.dotfiles.configDir;
in {
  options.modules.dev.clojure = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ openjdk clojure joker leiningen ];

    env = {
      LEIN_HOME="$XDG_DATA_HOME/lein";
    };

    # FIXME do something about .m2 (profiles.clj seems not to work)
    home.dataFile."lein/profiles.clj".source = "${configDir}/lein/profiles.clj";
  };

}
