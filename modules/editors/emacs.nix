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
  };

  config = mkIf cfg.enable (mkMerge [{

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
        pinentry_emacs) # in-emacs gnupg prompts

      zstd # for undo-fu-session/undo-tree compression

      ## Module dependencies

      # :term vterm
      # ((emacsPackagesNgGen emacsGit).emacsWithPackages (epkgs: [ epkgs.vterm ]))
      # FIXME
      (mkIf (cfg.native-comp == false)
        ((emacsPackagesNgGen emacsGit).emacsWithPackages
          (epkgs: [ epkgs.vterm ])))

      (mkIf (cfg.native-comp == true)
        ((emacsPackagesNgGen emacsGcc).emacsWithPackages
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
        ((emacsPackagesNgGen emacsGit).emacsWithPackages
          (epkgs: [ epkgs.pdf-tools ])))

      (mkIf (cfg.native-comp == true)
        ((emacsPackagesNgGen emacsGcc).emacsWithPackages
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

      # :lang clojure
      clojure-lsp

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

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
  }]);
}
