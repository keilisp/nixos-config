;;; current-theme.el -*- lexical-binding: t; -*-

(defvar theme-name 'modus-operandi)

(use-package modus-themes
  :ensure t
  :custom
  ;; (modus-themes-syntax '(faint yellow-comments alt-syntax))
  ;; (modus-themes-deuteranopia t)
  ;; (modus-themes-completions 'moderate)
  (modus-themes-region '(no-extend bg-only))
  (modus-themes-org-blocks 'gray-background)
  (modus-themes-paren-match '(bold))
  (modus-themes-hl-line '(accented))
  (modus-themes-italic-constructs t)
  (modus-themes-lang-checkers '(background text-also))
  (modus-themes-links '(no-underline background))
  (modus-themes-mode-line '(borderless 4))
  (modus-themes-prompts '(bold))
  :init
  ;; Terminal mode
  (unless (display-graphic-p)
    (load-theme theme-name t)
    (use-package evil-terminal-cursor-changer
      :after evil
      :ensure t
      :hook
      (tty-setup . evil-terminal-cursor-changer-activate)))

  (load-theme theme-name t))


;; (use-package ef-themes
;;   :ensure t
;;   :init
;;   ;; Terminal mode
;;   (unless (display-graphic-p)
;;     (load-theme theme-name t)
;;     (use-package evil-terminal-cursor-changer
;;       :after evil
;;       :ensure t
;;       :hook
;;       (tty-setup . evil-terminal-cursor-changer-activate)))

;;   (load-theme theme-name t))
