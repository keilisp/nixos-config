;;; current-theme.el -*- lexical-binding: t; -*-

(defvar theme-name 'modus-operandi)

(use-package modus-themes
  :ensure t
  :custom
  (modus-themes-completions nil)
  (modus-themes-variable-pitch-ui t)
  (modus-themes-mixed-fonts t)
  (modus-themes-org-blocks 'gray-background)
  (modus-themes-italic-constructs t)
  (modus-themes-prompts '(bold))
  (modus-themes-headings '((1 . (variable-pitch light 1.1))
                           (agenda-date . (1.1))
                           (agenda-structure . (variable-pitch light 1.2))
                           (t . (regular))))
  (modus-themes-common-palette-overrides 
   `(
     ;; Make the mode-line borderless and stand out less
     (bg-mode-line-active bg-inactive)
     (fg-mode-line-active fg-main)
     (bg-mode-line-inactive bg-inactive)
     (fg-mode-line-active fg-dim)

     (border-mode-line-active bg-main)
     (border-mode-line-inactive bg-inactive)

     ;; Keep the background unspecified (like the default), but use a faint
     ;; foreground color.
     ;; (fg-prompt cyan-faint)
     ;; (bg-prompt unspecified)

     ;; Globally use faint instead of warm blue and disable underlines for links
     (fg-link blue-faint)
     (underline-link unspecified)
     (underline-link-visited unspecified)
     (underline-link-symbolic unspecified)

     ;; Add a nuanced background color to completion matches, while keeping
     ;; their foreground intact (foregrounds do not need to be specified in
     ;; this case, but we do it for didactic purposes).
     ;; (fg-completion-match-0 blue)
     ;; (fg-completion-match-1 magenta-warmer)
     ;; (fg-completion-match-2 cyan)
     ;; (fg-completion-match-3 red)
     ;; (bg-completion-match-0 bg-blue-nuanced)
     ;; (bg-completion-match-1 bg-magenta-nuanced)
     ;; (bg-completion-match-2 bg-cyan-nuanced)
     ;; (bg-completion-match-3 bg-red-nuanced)
     
     ;; Enable underlines for parens
     ;; (bg-paren-match bg-magenta-intense) ; set highlight color to magenta
     (underline-paren-match fg-main)
     (bg-paren-match bg-magenta-intense)
   
     ;; Make linters underlines less intense
     ;; (underline-err red-faint)
     ;; (underline-warning yellow-faint)
     ;; (underline-note cyan-faint)

     ;; Make the fringe invisible
     (fringe unspecified)

     ;; Make the Org agenda use faint colors.
     (date-common cyan-faint) ; for timestamps and more
     (date-deadline red-faint)
     (date-event fg-alt) ; default
     (date-holiday magenta) ; default (for M-x calendar)
     (date-now fg-main) ; default
     (date-scheduled yellow-faint)
     (date-weekday fg-dim)
     (date-weekend fg-dim)

     ;; hl-line and region selection
     (bg-hl-line bg-dim)
     (bg-region bg-lavender)
     (fg-region unspecified)

     ;; Basically unsaved buffer color
     (modeline-err magenta-cooler)))
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
