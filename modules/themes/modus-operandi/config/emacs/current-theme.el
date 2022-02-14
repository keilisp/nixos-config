;;; current-theme.el -*- lexical-binding: t; -*-

(use-package modus-themes
  :ensure t
  ;; :custom
  ;; (modus-themes-completions 'moderate)
  ;; (modus-themes-mode-line 'borderless)
  ;; (modus-themes-region 'accent-no-extend)
  ;; (modus-themes-org-blocks 'tinted-background)
  ;; (modus-themes-variable-pitch-headings t)
  ;; (modus-themes-lang-checkers nil)
  ;; (modus-themes-paren-match 'intense)
  ;; (modus-themes-hl-line 'accented-background)
  ;; (modus-themes-slanted-constructs t)
  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme 'modus-operandi t)
    (use-package evil-terminal-cursor-changer
      :after evil
      :ensure t
      :hook
      (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme 'modus-operandi t))
