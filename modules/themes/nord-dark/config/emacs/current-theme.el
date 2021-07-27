;;; current-theme.el -*- lexical-binding: t; -*-

(use-package nord-theme
  :ensure t
  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme 'nord t)
    (use-package! evil-terminal-cursor-changer
                  :hook (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme 'nord t))
