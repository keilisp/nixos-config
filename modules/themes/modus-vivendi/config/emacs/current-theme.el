;;; current-theme.el -*- lexical-binding: t; -*-

;; Terminal mode
(unless (display-graphic-p)
  (setq doom-theme 'modus-vivendi)
  (use-package! evil-terminal-cursor-changer
    :hook (tty-setup . evil-terminal-cursor-changer-activate)))


(setq doom-theme 'modus-vivendi)
(setq calendar-location-name "Europe, Kiev")
(setq calendar-latitude 49.50)
(setq calendar-longitude 24.1)
(use-package theme-changer)
(if (daemonp)
    (add-hook 'after-make-frame-functions
	      (lambda (frame)
		(select-frame frame)
		(if (display-graphic-p)
		    (setq doom-theme 'modus-vivendi)
		  ))))
