# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vim;
in {
  options.modules.editors.vim = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ editorconfig-core-c unstable.neovim ];

    # This is for non-neovim, so it loads my nvim config
    # env.VIMINIT = "let \\$MYVIMRC='\\$XDG_CONFIG_HOME/nvim/init.vim' | source \\$MYVIMRC";

    environment.shellAliases = {
      vim = "nvim";
      v = "nvim";
    };

    env = {
      MYVIMRC = "$XDG_CONFIG_HOME/vim/.vimrc";
      VIMINIT = ":set runtimepath+=$XDG_CONFIG_HOME/.vim|:source $MYVIMRC";
    };

    home.configFile = {
      "vim" = {
        source = "${configDir}/vim";
        recursive = true;
      };
      # "vim/.vim/bundle/Vundle.vim".source = pkgs.fetchFromGitHub {
      #   owner = "VundleVim";
      #   repo = "Vundle.vim";
      #   rev = "b255382d6242d7ea3877bf059d2934125e0c4d95";
      #   sha256 = "0fkmklcq3fgvd6x6irz9bgyvcdaxafykk3k89gsi9p6b0ikw3rw6";
      # };

      "vim/.vim/bundle/Vundle.vim".source = pkgs.fetchzip {
        url = "https://github.com/VundleVim/Vundle.vim/archive/master.zip";
        sha256 = "0fkmklcq3fgvd6x6irz9bgyvcdaxafykk3k89gsi9p6b0ikw3rw6";
      };
    };
  };
}
