{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.dmenu;
in {
  options.modules.desktop.apps.dmenu = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    # user.packages = with pkgs; [ dmenu ];

    user.packages = with pkgs; [
      (writeScriptBin "dmenu" ''
        #!${stdenv.shell}
        exec ${pkgs.dmenu}/bin/dmenu -nb '#ffffff' -sf '#0030a6' -sb '#f8f8f8' -nf '#282828' -fn 'IBM Plex Mono:bold:pixelsize=13' "$@"
      '')
      (writeScriptBin "dmenu_run" ''
        #!${stdenv.shell}
        exec ${pkgs.dmenu}/bin/dmenu_run -nb '#ffffff' -sf '#0030a6' -sb '#f8f8f8' -nf '#282828' -fn 'IBM Plex Mono:bold:pixelsize=13' "$@"
      '')
      (writeScriptBin "dmenu_path" ''
        #!${stdenv.shell}
        exec ${pkgs.dmenu}/bin/dmenu_path -nb '#ffffff' -sf '#0030a6' -sb '#f8f8f8' -nf '#282828' -fn 'IBM Plex Mono:bold:pixelsize=13' "$@"
      '')
    ];
  };
}
