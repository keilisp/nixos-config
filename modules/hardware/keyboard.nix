{ options, config, lib, pkgs, inputs, ... }:

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
    kmonad = {
      enable = mkBoolOpt false;
    };
  };

  imports = [ inputs.kmonad.nixosModules.default ];
  config = mkIf cfg.enable (mkMerge [
    {
      services.udev.extraRules = mkIf cfg.kmonad.enable ''
        # KMonad user access to /dev/uinput
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';

      users.groups = mkIf cfg.kmonad.enable { uinput = { }; };

      user.extraGroups = mkIf cfg.kmonad.enable [ "input" "uinput" ];

      services.kmonad = mkIf cfg.kmonad.enable {
        enable = true;

      };

      user.packages = with pkgs; [ xorg.xmodmap ];
      # services.udev.extraRules = ''
      #   ACTION=="add", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="3735",  ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/tmp/Xauthority", ENV{HOME}="/home/kei", RUN+="${pkgs.systemd}/bin/systemctl --no-block --user restart setup-keyboard"
      # '';
    }

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

