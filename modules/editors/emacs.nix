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
  };

  config = mkIf cfg.enable {
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
      ((emacsPackagesNgGen emacsGit).emacsWithPackages (epkgs: [ epkgs.vterm ]))

      (mkIf (cfg.native-comp)
        ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages
          (epkgs: [ epkgs.vterm ])))

      libtool
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ru ]))
      # :checkers grammar
      languagetool
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang cc
      ccls
      # :lang javascript
      nodePackages.javascript-typescript-langserver
      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-medium
      # :lang rust
      rustfmt
      unstable.rust-analyzer
      # :lang nix
      nixfmt
      # lang sh
      shfmt
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    home.configFile = mkIf cfg.doom.enable {
      # "emacs".source = pkgs.fetchFromGitHub {
      # owner = "hlissner";
      # repo = "doom-emacs";
      # rev = "cf5b7adb6352ff17c00d24febe4a4545c3a1170b";
      # sha256 = "0kcjrghfqk3r32s4rmwk3alk3sb73hjdzc1ms2a3zf7nn64i41p9";
      # };
      "doom" = {
        source = "${configDir}/emacs/doom";
        recursive = true;
      };
    };

    # init.doomEmacs = (mkIf cfg.doom.enable ''
    #	if [ -d $HOME/.config/emacs ]; then
    #	${optionalString cfg.doom.fromSSH ''
    #	git clone git@github.com:hlissner/doom-emacs.git $HOME/.config/emacs
    # # git clone git@github.com:hlissner/doom-emacs-private.git $HOME/.config/doom
    #	''}
    #	${optionalString (cfg.doom.fromSSH == false) ''
    #	git clone https://github.com/hlissner/doom-emacs $HOME/.config/emacs
    # # git clone https://github.com/hlissner/doom-emacs-private $HOME/.config/doom
    #	''}
    #	fi
    #	'');
  };
}
