# modules/dev/common-lisp.nix --- https://common-lisp.net/

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.common-lisp;
    configDir = config.dotfiles.configDir;
in {
  options.modules.dev.common-lisp = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ sbcl lispPackages.quicklisp ];

    home.file.".sbclrc".source = "${configDir}/sbcl/sbclrc";
  };

}
