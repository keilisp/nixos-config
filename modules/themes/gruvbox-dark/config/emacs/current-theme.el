;;; current-theme.el -*- lexical-binding: t; -*-

;; Terminal mode
(unless (display-graphic-p)
  (setq doom-theme 'doom-gruvbox)
  (use-package! evil-terminal-cursor-changer
    :hook (tty-setup . evil-terminal-cursor-changer-activate)))


(setq doom-theme 'doom-gruvbox)
(setq calendar-location-name "Europe, Kiev")
(setq calendar-latitude 50.43)
(setq calendar-longitude 30.52)
(use-package theme-changer)
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(select-frame frame)
		(if (display-graphic-p)
		    (setq doom-theme 'doom-gruvbox)
		  ))))
