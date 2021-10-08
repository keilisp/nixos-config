{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.lutris;
in {
  options.modules.desktop.gaming.lutris = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (wineWowPackages.full.override {
        wineRelease = "staging";
        mingwSupport = true;
      })
      (winetricks.override { wine = wineWowPackages.staging; })
      lutris

      # wineWowPackages.stable
      # (winetricks.override { wine = wineWowPackages.stable; })
    ];
    # system.userActivationScripts.setupSteamDir = ''mkdir -p "${cfg.libDir}"'';
  };
}
