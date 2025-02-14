{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.pavucontrol;
in {
  options.modules.desktop.media.pavucontrol = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ pwvucontrol ]; };
}
