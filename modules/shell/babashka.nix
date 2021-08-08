{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.babashka;
in {
  options.modules.shell.babashka = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ babashka ];
    modules.shell.zsh.rcInit = ''
      _bb_tasks() {
          local matches=(`bb tasks |tail -n +3 |cut -f1 -d ' '`)
          compadd -a matches
          _files # autocomplete filenames as well
      }
      compdef _bb_tasks bb
    '';
  };
}
