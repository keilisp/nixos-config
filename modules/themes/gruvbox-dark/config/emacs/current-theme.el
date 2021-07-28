;;; current-theme.el -*- lexical-binding: t; -*-

(use-package gruvbox-theme
  :ensure t
  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme 'gruvbox t)
    (use-package evil-terminal-cursor-changer
      :ensure t
      :hook
      (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme 'gruvbox t))
