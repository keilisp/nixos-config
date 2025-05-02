# modules/desktop/apps/ue.nix --- https://unrealengine.com

{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.ue;
in {
  options.modules.desktop.apps.ue = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ue4
    ];
  };
}
