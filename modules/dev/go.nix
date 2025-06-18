# modules/dev/go.nix --- Go

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.golang;
in {
  options.modules.dev.golang = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      go
      gopls
    ];
  };
}
