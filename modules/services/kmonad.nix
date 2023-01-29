{ config, options, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.kmonad;
in {
  options.modules.services.kmonad = { enable = mkBoolOpt false; };
  imports = [ inputs.kmonad.nixosModules.default ];
  config = mkIf cfg.enable {
    services.kmonad = {
      enable = true;

      # keyboards.internal = {
      #   device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
      #   config = builtins.readFile ../support/keyboard/us_60.kbd;

      #   defcfg = {
      #     enable = true;
      #     fallthrough = true;
      #   };
      # };
    };

  };
}
