;;; current-theme.el -*- lexical-binding: t; -*-

(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme 'sanityinc-tomorrow-day t)
    (use-package! evil-terminal-cursor-changer
                  :hook (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme 'sanityinc-tomorrow-day t))
