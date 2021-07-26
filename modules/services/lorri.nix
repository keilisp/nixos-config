{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.lorri;
in {
  options.modules.services.lorri = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.lorri.enable = true;
  };
}
