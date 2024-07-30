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
      hhkb-colemak-dh = mkBoolOpt false;
      t440p-colemak-dh = mkBoolOpt false;
      legion-colemak-dh = mkBoolOpt false;
    };
  };

  imports = [ inputs.kmonad.nixosModules.default ];
  config = mkIf cfg.enable (mkMerge [
    {
      # FIXME make options langs change
      services.xserver.layout = "us, ru, ua";
      services.xserver.xkbOptions =
        mkIf (cfg.kmonad.t440p-colemak-dh || cfg.kmonad.legion-colemak-dh) "grp:caps_toggle";

      services.udev.extraRules = mkIf cfg.kmonad.enable ''
        # KMonad user access to /dev/uinput
        KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
      '';

      users.groups = mkIf cfg.kmonad.enable { uinput = { }; };

      user.extraGroups = mkIf cfg.kmonad.enable [ "input" "uinput" ];

      services.kmonad = mkIf cfg.kmonad.enable {
        enable = true;

        keyboards.hhkb = mkIf cfg.kmonad.hhkb-colemak-dh {
          device =
            "/dev/input/by-id/usb-Topre_Corporation_HHKB_Professional-event-kbd";
          config = builtins.readFile ../../config/kmonad/hhkb.kbd;

          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = true;
          };
        };

        keyboards.t440p-colemak-dh = mkIf cfg.kmonad.t440p-colemak-dh {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ../../config/kmonad/t440p.kbd;

          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = true;
          };
        };

        keyboards.legion-colemak-dh = mkIf cfg.kmonad.legion-colemak-dh {
          device = "/dev/input/by-id/usb-ITE_Tech._Inc._ITE_Device_8910_-event-kbd";
          config = builtins.readFile ../../config/kmonad/legion.kbd;

          defcfg = {
            enable = true;
            fallthrough = true;
            allowCommands = true;
          };
        };
      };

      user.packages = with pkgs; [ xorg.xmodmap ];
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

