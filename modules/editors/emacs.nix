# Emacs is my main driver.

{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    native-comp = mkBoolOpt false;
    server = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [{

    # services.emacs.enable = mkIf cfg.server true;

    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      ## Emacs itself
      # emacsGit # 27
      # (mkIf (cfg.native-comp) emacsPgtkGcc) # 28 + pgtk + native-comp

      binutils # native-comp needs 'as', provided by this

      ## Emacs dependencies
      git

      (ripgrep.override { withPCRE2 = true; })

      gnutls # for TLS connectivity

      ## Optional dependencies
      fd # faster projectile indexing

      imagemagick # for image-dired

      (mkIf (config.programs.gnupg.agent.enable)
        pinentry-emacs) # in-emacs gnupg prompts

      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies

      # :term vterm
      # ((emacsPackagesFor emacsGit).emacsWithPackages (epkgs: [ epkgs.vterm ]))
      # FIXME
      (mkIf (cfg.native-comp == false)
        ((emacsPackagesFor emacsGit).emacsWithPackages
          (epkgs: [ epkgs.vterm ])))

      (mkIf (cfg.native-comp == true)
        ((emacsPackagesFor emacs-unstable).emacsWithPackages
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
      # FIXME
      (mkIf (cfg.native-comp == false)
        ((emacsPackagesFor emacsGit).emacsWithPackages
          (epkgs: [ epkgs.pdf-tools ])))

      (mkIf (cfg.native-comp == true)
        ((emacsPackagesFor emacs-unstable).emacsWithPackages
          (epkgs: [ epkgs.pdf-tools ])))

      # :lang cc
      ccls
      lldb

      # :lang javascript
      nodePackages.javascript-typescript-langserver

      # :lang latex & :lang org (latex previews)
      texlive.combined.scheme-full
      # (texlive.combine {
      #   inherit (texlive) scheme-full wrapfig titling titlesec fontspec;
      # })

      # :lang clojure
      clojure-lsp
      clj-kondo

      # :lang rust
      rustfmt
      unstable.rust-analyzer

      # :lang haskell
      haskell-language-server
      haskellPackages.happy
      haskellPackages.hindent
      # haskellPackages.structured-haskell-mode


      # :lang nix
      nixfmt-classic

      # :lang sh
      shfmt
      nodePackages.bash-language-server

      # :lang python
      # black

      # :lang lua
      luaformatter

      # :lang fennel
      fnlfmt

      # :lang sql
      pgformatter
    ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.packages = [ pkgs.emacs-all-the-icons-fonts ];
  }]);
}
