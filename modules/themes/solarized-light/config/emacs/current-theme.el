;;; current-theme.el -*- lexical-binding: t; -*-

(use-package solarized-theme
  :ensure t
  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme 'solarized-light t)
    (use-package evil-terminal-cursor-changer
      :after evil
      :ensure t
      :hook
      (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme 'solarized-light t))
