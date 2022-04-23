# modules/dev/fennel.nix

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.fennel;
  configDir = config.dotfiles.configDir;
in {
  options.modules.dev.fennel = {
    enable = mkBoolOpt false;
    jit = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf (cfg.jit == true) my.fenneljit)
      (mkIf (cfg.jit == false) fennel)
    ];
  };
}
