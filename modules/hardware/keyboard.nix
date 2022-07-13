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
    user.packages = with pkgs; [ xorg.xmodmap ];
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xmodmap}/bin/xmodmap ${layoutShiftcapsNone}
    '';
  };
}
