{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.hardware.keyboard;
  layoutShiftcapsNone = pkgs.writeText "xkb-layout" ''
    ! Caps for changing group
    ! Shift+Caps does nothing

    keycode  66 = ISO_Next_Group NoSymbol ISO_Next_Group NoSymbol ISO_Next_Group NoSymbol
  '';
in {
  # TODO
  # move layout config there, make it modular like
  #   {
  #     us = mkBoolOpt true;
  #     ru = mkBoolOpt true;
  #     ua = mkBoolOpt false;
  #   }
  # and dynamically generate settings

  options.modules.hardware.keyboard = { xmodmap = mkBoolOpt false; };

  config = mkIf cfg.xmodmap {

    user.packages = with pkgs;
      [ xorg.xmodmap ];
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xmodmap}/bin/xmodmap ${layoutShiftcapsNone}
    '';

 # RUN+="/usr/bin/su cjr -c \"DISPLAY=:1 XAUTHORITY=/home/cjr/.Xauthority xset r rate 200 36\""

    # ACTION=="add", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="3735",  ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/tmp/.Xauthority", ENV{HOME}="/home/kei", RUN+="${pkgs.xorg.xset}/bin/xset r rate 300 50"
    services.udev.extraRules = ''
      ACTION=="add", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="3735",  ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/tmp/Xauthority", ENV{HOME}="/home/kei", RUN+="${pkgs.systemd}/bin/systemctl --no-block --user restart setup-keyboard"
    '';
  };
}
