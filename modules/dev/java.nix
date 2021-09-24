# modules/dev/java.nix --- Java

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.java;
in {
  options.modules.dev.java = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ openjdk maven ];

    env = {
      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    };

  };
}
