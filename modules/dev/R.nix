# modules/dev/R.nix

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.R;
  configDir = config.dotfiles.configDir;
in {
  options.modules.dev.R = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { user.packages = with pkgs; [ R ]; };
}
