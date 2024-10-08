{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.printing;
in {
  options.modules.hardware.printing = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # carps-cups
      # cups-bjnp
      # canon-cups-ufr2
      # cnijfilter2
      # gutenprintBin
      cups-filters
    ];
    services.printing.drivers = with pkgs; [
      cnijfilter2
      gutenprintBin
      cups-bjnp
      carps-cups
      canon-cups-ufr2
    ];
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    # for a WiFi printer
    services.avahi.openFirewall = true;
  };
}
