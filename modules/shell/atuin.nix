{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.atuin;
in {
  options.modules.shell.atuin = { enable = mkBoolOpt false; };

  # atuin register -u <USERNAME> -e <EMAIL> -p <PASSWORD>
  # atuin import auto
  # atuin sync

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ atuin ];
    modules.shell.zsh.rcInit = ''

  autoload -U add-zsh-hook

  export ATUIN_SESSION=$(atuin uuid)
  export ATUIN_HISTORY="atuin history list"

  _atuin_preexec(){
      id=$(atuin history start "$1")
      export ATUIN_HISTORY_ID="$id"
  }

  _atuin_precmd(){
      local EXIT="$?"

      [[ -z "''${ATUIN_HISTORY_ID}" ]] && return


      (RUST_LOG=error atuin history end $ATUIN_HISTORY_ID --exit $EXIT &) > /dev/null 2>&1
  }

  _atuin_search(){
      emulate -L zsh
      zle -I

      # Switch to cursor mode, then back to application
      echoti rmkx
      # swap stderr and stdout, so that the tui stuff works
      # TODO: not this
      output=$(RUST_LOG=error atuin search -i $BUFFER 3>&1 1>&2 2>&3)
      echoti smkx

      if [[ -n $output ]] ; then
    	  LBUFFER=$output
      fi

      zle reset-prompt
  }

  add-zsh-hook preexec _atuin_preexec
  add-zsh-hook precmd _atuin_precmd

 '';
  };
}
