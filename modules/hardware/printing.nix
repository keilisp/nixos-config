{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.printing;
in {
  options.modules.hardware.printing = { enable = mkEnableOption false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ canon-cups-ufr2 cnijfilter2];
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns = true;
    # for a WiFi printer
    services.avahi.openFirewall = true;
  };
}
