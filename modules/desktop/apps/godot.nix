# modules/dev/godot.nix --- https://godotengine.org/

{ lib, config, options, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.godot;
in {
  options.modules.desktop.apps.godot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      godot_4
      godot_4-export-templates
      gdtoolkit_4
    ];
  };
}
