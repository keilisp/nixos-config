{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.hardware.keyboard;
  layoutShiftcapsNone = pkgs.writeText "xkb-layout" ''
    ! Caps for changing group
    ! Shift+Caps does nothing

    keycode 66 = ISO_Next_Group NoSymbol ISO_Next_Group NoSymbol ISO_Next_Group NoSymbol
  '';
  layoutCapsCtrlSwap = pkgs.writeText "xkb-layout" ''
    ! Swaps Caps and Ctrl with Caps to change groups

    remove Lock = Caps_Lock
    add Control = Caps_Lock
    keycode 37 = ISO_Next_Group NoSymbol ISO_Next_Group NoSymbol ISO_Next_Group NoSymbol
    keycode 66 = Control_L NoSymbol Control_L NoSymbol Control_L
  '';
in {
  options.modules.hardware.keyboard = {
    enable = mkBoolOpt false;
    shiftcapsnone = mkBoolOpt false;
    capsctrlswap = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    {

      user.packages = with pkgs; [ xorg.xmodmap ];

    #   services.udev.extraRules = ''
    #     ACTION=="add", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="3735",  ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/tmp/Xauthority", ENV{HOME}="/home/kei", RUN+="${pkgs.systemd}/bin/systemctl --no-block --user restart setup-keyboard"
    #   '';
    # }

    (mkIf cfg.shiftcapsnone {
      services.xserver.displayManager.sessionCommands = ''
        ${pkgs.xorg.xmodmap}/bin/xmodmap ${layoutShiftcapsNone}
      '';
    })

    (mkIf cfg.capsctrlswap {
      services.xserver.displayManager.sessionCommands = ''
        ${pkgs.xorg.xmodmap}/bin/xmodmap ${layoutCapsCtrlSwap}
      '';
    })

  ]);
}

