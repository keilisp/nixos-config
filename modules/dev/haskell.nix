# modules/dev/haskell.nix --- https://www.haskell.org/

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.haskell;
  configDir = config.dotfiles.configDir;
in {
  # TODO make options for stack, cabal
  options.modules.dev.haskell = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ghc
      stack
      cabal-install
      # stack2nix
      # cabal2nix 
    ];

    env = {
      STACK_ROOT = "$XDG_DATA_HOME/stack";
      CABAL_CONFIG = "$XDG_CONFIG_HOME/cabal/config";
      CABAL_DIR = "$XDG_CACHE_HOME/cabal";
    };
  };

}
