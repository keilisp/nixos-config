;;; current-theme.el -*- lexical-binding: t; -*-

(use-package modus-themes
  :ensure t
  :custom
  (modus-themes-completions nil)
  (modus-themes-variable-pitch-ui t)
  (modus-themes-mixed-fonts t)
  (modus-themes-org-blocks 'gray-background)
  (modus-themes-italic-constructs t)
  (modus-themes-prompts '(bold))
  (modus-themes-headings '((1 . (light variable-pitch 1.1))
                           (agenda-date . (1.1))
                           (agenda-structure . (variable-pitch light 1.2))
                           (t . (medium))))
  (modus-themes-common-palette-overrides 
   `(
     ;; Make the mode-line borderless and stand out less
     (bg-mode-line-active bg-inactive)
     (fg-mode-line-active fg-main)
     (bg-mode-line-inactive bg-inactive)
     (fg-mode-line-active fg-dim)

     (border-mode-line-active bg-main)
     (border-mode-line-inactive bg-inactive)

     ;; Globally use faint instead of warm blue and disable underlines for links
     (fg-link blue-faint)
     (underline-link unspecified)
     (underline-link-visited unspecified)
     (underline-link-symbolic unspecified)
     
     ;; Enable underlines for parens
     ;; (bg-paren-match bg-magenta-intense) ; set highlight color to magenta
     (underline-paren-match fg-main)
   
     ;; Make linters underlines less intense
     (underline-err red-faint)
     (underline-warning yellow-faint)
     (underline-note cyan-faint)))

  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme 'modus-vivendi t)
    (use-package evil-terminal-cursor-changer
      :after evil
      :ensure t
      :hook
      (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme 'modus-vivendi t))
