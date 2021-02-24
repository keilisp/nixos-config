# modules/shell/grub-customizer.nix

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.grub-customizer;
in {
  options.modules.desktop.apps.grub-customizer = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ hwinfo my.grub-customizer ];
  };
}
