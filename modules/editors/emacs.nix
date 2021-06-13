# Emacs is my main driver.

{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    native-comp = mkBoolOpt false;
    doom = {
      enable = mkBoolOpt true;
      fromSSH = mkBoolOpt false;
    };
    chemacs = { enable = mkBoolOpt false; };

    keimacs = { enable = mkBoolOpt false; };
  };

  config = mkIf cfg.enable (mkMerge [{

    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      ## Emacs itself
      # emacsGit # 27
      # (mkIf (cfg.native-comp) emacsPgtkGcc) # 28 + pgtk + native-comp
      binutils # native-comp needs 'as', provided by this

      ## Doom dependencies
      git
      (ripgrep.override { withPCRE2 = true; })
      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing
      imagemagick # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs) # in-emacs gnupg prompts
      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :term vterm
      # ((emacsPackagesNgGen emacsGit).emacsWithPackages (epkgs: [ epkgs.vterm ]))

      #FIXME
      (mkIf (cfg.native-comp == false)
        ((emacsPackagesNgGen emacsGit).emacsWithPackages
          (epkgs: [ epkgs.vterm ])))

      (mkIf (cfg.native-comp == true)
        ((emacsPackagesNgGen emacsGcc).emacsWithPackages
          # ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages
          (epkgs: [ epkgs.vterm ])))

      libtool
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ru uk ]))
      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :tools pdf

      #FIXME
      (mkIf (cfg.native-comp == false)
        ((emacsPackagesNgGen emacsGit).emacsWithPackages
          (epkgs: [ epkgs.pdf-tools ])))

      (mkIf (cfg.native-comp == true)
        ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages
          (epkgs: [ epkgs.pdf-tools ])))

      # :lang cc
      ccls
      lldb
      # :lang javascript
      nodePackages.javascript-typescript-langserver
      # :lang latex & :lang org (latex previews)
      # texlive.combined.scheme-medium
      (texlive.combine {
        inherit (texlive) scheme-full wrapfig titling titlesec fontspec;
      })

      # :lang rust
      rustfmt
      unstable.rust-analyzer
      # :lang nix
      nixfmt
      # :lang sh
      shfmt
      nodePackages.bash-language-server
      # :lang python
      # black
      # :lang lua
      # luaformatter
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/doom-emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    home.configFile = (mkMerge [
      (mkIf cfg.chemacs.enable {
        # "emacs".source = pkgs.fetchFromGitHub {
        #   owner = "plexus";
        #   repo = "chemacs2";
        #   rev = "30a20db";
        #   sha256 = "0ghry3v05y31vgpwr2hc4gzn8s6sr6fvqh88fsnj9448lrim38f9";
        # };

        "chemacs" = {
          source = "${configDir}/emacs/chemacs";
          recursive = true;
        };
      })

      # (mkIf cfg.keimacs.enable {
      #   "keimacs" = {
      #     source = "${configDir}/emacs/keimacs";
      #     recursive = true;
      #   };
      # })

      (mkIf cfg.doom.enable {
        "doom" = {
          source = "${configDir}/emacs/doom";
          recursive = true;
        };
      })

    ]);

    system.userActivationScripts.keimacs.text = ''

      ${optionalString cfg.chemacs.enable ''
        ${pkgs.git}/bin/git clone https://github.com/plexus/chemacs2.git $HOME/.config/emacs
      ''}

      ${optionalString cfg.keimacs.enable ''
        ${pkgs.git}/bin/git clone https://github.com/keilisp/keimacs.git $HOME/.config/keimacs
      ''}

    '';

    # init.doomEmacs = (mkIf cfg.doom.enable ''
    #   if [ -d $HOME/.config/emacs ]; then
    #   ${optionalString cfg.doom.fromSSH ''
    #     	git clone https://github.com/keilisp/jiran_keimap $HOME/.config/emacs
    #     	''}
    #   ${optionalString (cfg.doom.fromSSH == false) ''
    #     	git clone https://github.com/hlissner/doom-emacs $HOME/.config/emacs
    #     # git clone https://github.com/hlissner/doom-emacs-private $HOME/.config/doom
    #     	''}
    #   fi
    # '');
  }]);
}
