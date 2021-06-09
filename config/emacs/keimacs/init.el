;;; -*- lexical-binding: t; -*-

;; TODO ssh setup [[https://github.com/tarsius/keychain-environment/blob/master/keychain-environment.el#L27-L48][Keychain]]
;; TODO org startup folded

(eval-and-compile
  (setq use-package-expand-minimally t)
  (setq use-package-enable-imenu-support t)
  (setq use-package-hook-name-suffix nil))


;;; Init packages
(require 'package)
(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up

;; the following lines tell emacs where on the internet to look up
;; for new packages.
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents)               ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

;; Setup use-package
(eval-when-compile
  (require 'use-package))


;;; quelpa
(use-package quelpa
  :ensure t
  :defer t
  :custom
  (quelpa-update-melpa-p nil "Don't update the MELPA git repo."))

;;; use-package-quelpa
(use-package quelpa-use-package
  :ensure t
  :init (setq quelpa-use-package-inhibit-loading-quelpa t))

;;; use-package custom-update
;; To be able update lists in custom
(use-package use-package-custom-update
  :quelpa
  (use-package-custom-update
   :repo "a13/use-package-custom-update"
   :fetcher github
   :version original))

;;; Garbage Collector Magic Hack
(use-package gcmh
  :ensure t
  :init
  (gcmh-mode 1))

;;; This one tries to speed up Emacs startup a little bit
(use-package fnhh
  :quelpa
  (fnhh :repo "a13/fnhh" :fetcher github)
  :config
  (fnhh-mode 1))

;;;; Utils
(defun kei/notify-send (title message)
  "Display a desktop notification by shelling MESSAGE with TITLE out to `notify-send'."
  (call-process-shell-command (format "notify-send -t 2000 \"%s\" \"%s\"" title message)))


;;; Interface tweaks
(use-package emacs
  :defer t
  :custom
  (indent-tabs-mode nil)
  (tab-width 4)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (scroll-step 1)
  (auto-window-vscroll nil)
  (tooltip-mode nil)
  (enable-recursive-minibuffers t)
  (completion-ignore-case t)
  (sentence-end-double-space nil)
  (column-number-mode t)
  (read-buffer-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (resize-mini-frames nil)
  (resize-mini-windows nil)
  (default-frame-alist '((menu-bar-lines . 0)
                         (tool-bar-lines . 0)
                         (scroll-bar . nil)
                         (vertical-scroll-bars . nil)
                         (left-fringe . 5)
                         (right-fringe . 0)))
  (user-full-name "Druk Oleksandr")

  :config
  (defun kei/toggle-line-numbers ()
    "Toggle line numbers.

Cycles through regular, relative and no line numbers. The order depends on what
`display-line-numbers-type' is set to. If you're using Emacs 26+, and
visual-line-mode is on, this skips relative and uses visual instead.

See `display-line-numbers' for what these values mean."
    (interactive)
    (defvar kei--line-number-style display-line-numbers-type)
    (let* ((styles `(t ,(if visual-line-mode 'visual 'relative) nil))
           (order (cons display-line-numbers-type (remq display-line-numbers-type styles)))
           (queue (memq kei--line-number-style order))
           (next (if (= (length queue) 1)
                     (car order)
                   (car (cdr queue)))))
      (setq kei--line-number-style next)
      (setq display-line-numbers next)
      (message "Switched to %s line numbers"
               (pcase next
                 (`t "normal")
                 (`nil "disabled")
                 (_ (symbol-name next))))))

  ;; Treat underscore as a part of a word in code
  (add-hook 'prog-mode-hook
            (lambda () (modify-syntax-entry ?_ "w")))
  (add-hook 'prog-mode-hook
            (lambda () (modify-syntax-entry ?- "w")))
  :bind
  (("C-c k n" . kei/toggle-line-numbers)
   ("C-c k u" . insert-char)
   ("C-c k f" . make-frame)
   ("C-c k z" . olivetty-mode)
   :map global-map
   ("<C-left>" . enlarge-window-horizontally)
   ("<C-down>" . shrink-window)
   ("<C-up>" . enlarge-window)
   ("<C-right>" . shrink-window-horizontally)))

;;; Isearch
(use-package isearch
  :demand
  :config
  (defun kei/search-isearch-abort-dwim ()
    "Delete failed `isearch' input, single char, or cancel search.

This is a modified variant of `isearch-abort' that allows us to
perform the following, based on the specifics of the case: (i)
delete the entirety of a non-matching part, when present; (ii)
delete a single character, when possible; (iii) exit current
search if no character is present and go back to point where the
search started."
    (interactive)
    (if (eq (length isearch-string) 0)
        (isearch-cancel)
      (isearch-del-char)
      (while (or (not isearch-success) isearch-error)
        (isearch-pop-state)))
    (isearch-update))

  :bind
  (:map isearch-mode-map
        ("<backspace>". kei/search-isearch-abort-dwim)))

;;; list-buffer->ibuffer
(use-package ibuffer
  :bind
  ([remap list-buffers] . ibuffer))

(use-package ibuffer-projectile
  :ensure t
  :hook
  (ibuffer-hook . (lambda ()
                    (progn
                      (ibuffer-projectile-set-filter-groups)
                      (unless (eq ibuffer-sorting-mode 'alphabetic)
                        (ibuffer-do-sort-by-alphabetic))))))

;;; Ripgrep
(use-package rg
  :bind
  (:map search-map
        ("g" . rg))
  :init
  (advice-add 'project-find-regexp :override #'rg-project))

;;; Files
(use-package files
  :hook
  (before-save . delete-trailing-whitespace)

  :custom
  (require-final-newline t)
  ;; backup settings
  (backup-by-copying t)
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t)
  (confirm-kill-emacs #'yes-or-no-p)
  :config

  (defun kei/find-file-in-org ()
    "Search for a file in `org'."
    (interactive)
    (projectile-find-file-in-directory "~/org"))

  (defun kei/find-file-in-keimacs()
    "Search for a file in `org'."
    (interactive)
    (projectile-find-file-in-directory "~/.config/keimacs"))

  (defun kei/find-config-in-nix ()
    "Search file in private Doom config in nix config."
    (interactive)
    (sudo-edit (projectile-find-file-in-directory "/etc/nixos/config/emacs/doom/")))

  :bind
  (:map global-map
        ("C-c f o" . kei/find-file-in-org)
        ("C-c f k" . kei/find-file-in-keimacs)
        ("C-c f p" . kei/find-config-in-nix)
        ("C-c f m" . rename-file)
        ("C-c f D" . delete-file)
        ("C-c f c" . copy-file)
        ("C-c f s" . sudo-edit)))

(use-package no-littering
  :ensure t
  :custom
  (auto-save-file-name-transforms .
                                  `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package recentf
  :defer 0.1
  :custom
  (recentf-auto-cleanup 30)
  :config
  (recentf-mode)
  (run-with-idle-timer 10 t 'recentf-save-list)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory))

(use-package autorevert
  :defer 0.1)

;;; Quick access to init file
(use-package iqa
  :ensure t
  :config
  (iqa-setup-default))

;;; custom file -> /dev/null
(use-package cus-edit
  :defer t
  :custom
  (custom-file null-device "Don't store customizations"))

;;; Edit as sudo
(use-package tramp
  :defer t
  ;; :config
  ;; (put 'temporary-file-directory 'standard-value `(,temporary-file-directory))
  :custom
  ;; (tramp-backup-directory-alist backup-directory-alist)
  (tramp-default-method "ssh")
  (tramp-default-proxies-alist nil))

(use-package sudo-edit
  :ensure t
  :config (sudo-edit-indicator-mode)
  :bind (:map ctl-x-map
              ("M-s" . sudo-edit)
              ("M-f" . sudo-edit-find-file)))

;;; Dired
(use-package dired
  :commands dired-jump
  :custom
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (dired-dwim-target t)
  (dired-auto-revert-buffer t))

(use-package dired-aux
  :after dired
  :custom
  (dired-create-destination-dirs 'ask)
  (dired-vc-rename-file t))

(use-package ranger
  :ensure t
  :after dired
  :custom
  (ranger-override-dired-mode t)
  (ranger-override-dired t)
  (ranger-cleanup-on-disable t)
  (ranger-deer-show-details t)
  (ranger-show-hidden nil)
  (ranger-footer-delay nil))

(use-package dired-async
  :hook
  (dired-mode-hook . dired-async-mode))

;;; Subr
(use-package subr
  :defer t
  :preface
  (provide 'subr)
  :init
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

;;; Startup
(use-package startup
  :defer t
  :preface
  (provide 'startup)
  :custom
  (user-mail-address "druksasha@ukr.net")
  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (inhibit-startup-echo-area-message t)
  (initial-major-mode #'org-mode))

;;; Scratch per major-mode
(use-package scratch
  :ensure
  :config
  (defun kei/scratch-buffer-setup ()
    "Add contents to `scratch' buffer and name it accordingly."
    (let* ((mode (format "%s" major-mode))
           (string (concat "Scratch buffer for: " mode "\n\n")))
      (when scratch-buffer
        (save-excursion
          (insert string)
          (goto-char (point-min))
          (comment-region (point-at-bol) (point-at-eol)))
        (forward-line 2))
      (rename-buffer (concat "*Scratch for " mode "*") t)))
  :hook (scratch-create-buffer-hook . kei/scratch-buffer-setup)
  :bind ("C-c s" . scratch))

;;; Winner
(use-package winner
  :config
  (winner-mode 1))

;;; Theme
(use-package modus-themes
  :ensure t
  :custom
  (modus-themes-completions 'moderate)
  (modus-themes-mode-line 'borderless)
  (modus-themes-region 'accent-no-extend)
  (modus-themes-org-blocks 'tinted-background)
  (modus-themes-variable-pitch-headings t)
  (modus-themes-lang-checkers nil)
  (modus-themes-paren-match 'intense)
  (modus-themes-hl-line 'accented-background)
  (modus-themes-slanted-constructs t)
  :init
  (load-theme 'modus-operandi t))
;; (load-theme 'modus-vivendi t))

;;; Faces
;; TODO
(use-package faces
  :defer t
  :bind
  (("C-=" . text-scale-increase)
   ("C-_" . text-scale-decrease))
  :custom-face
  (default ((t (:font "Iosevka"))))
  (fixed-pitch ((t (:font "Iosevka"))))
  (variable-pitch ((t (:font "Iosevka")))))

(use-package unicode-fonts
  :ensure t
  :init
  (unicode-fonts-setup))

;;; Cursor
(use-package frame
  :defer t
  :custom
  (blink-cursor-mode nil))

;;; Evil
(use-package evil
  :ensure t
  :custom
  (evil-want-Y-yank-to-eol t)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-split-window-below t)
  (evil-vsplit-window-right t)
  (evil-disable-insert-state-bindings t)
  ;; (evil-echo-state nil)
  (evil-undo-system 'undo-fu)
  (evil-search-module 'evil-search)
  (evil-respect-visual-line-mode t)
  :hook
  (after-init-hook . evil-mode)
  :config
  (evil-mode)
  (evil-escape-mode)
  ;; (evil-set-leader 'motion (kbd "SPC"))
  ;; (evil-set-leader 'motion (kbd ",") t)

  (defun custom-evil-force-normal-state ()
    "Delegate to evil-force-normal-state but also clear search highlighting"
    (interactive)
    (progn
      ;; (keyboard-escape-quit)
      (evil-force-normal-state)
      (evil-ex-nohighlight)))

;;; Maximize window
  (defun toggle-maximize-buffer () "Maximize buffer"
         (interactive)
         (if (= 1 (length (window-list)))
             (jump-to-register '_)
           (progn
             (window-configuration-to-register '_)
             (delete-other-windows))))


  :bind
  ( ; Is there a better way? (maybe use doom advice)
   :map evil-motion-state-map
   ("C-w Q" . kill-buffer-and-window)
   ("<escape>" . custom-evil-force-normal-state)
   ;; ([tab] . evil-jump-item)
   :map evil-normal-state-map
   ("<escape>" . custom-evil-force-normal-state)
   :map evil-insert-state-map
   ("<escape>" . custom-evil-force-normal-state)
   :map evil-window-map
   ("<escape>" . custom-evil-force-normal-state)
   ("m" . toggle-maximize-buffer)
   :map evil-operator-state-map
   ("<escape>" . custom-evil-force-normal-state)))

(use-package evil-collection
  :ensure t
  :hook
  (evil-mode-hook . evil-collection-init))

;;; Format all the code
;;; FIXME
;;; TODO format-all-formatters (("Nix" nixfmt) ("C" . clang) ...)
(use-package format-all
  :ensure t
  :bind
  (("C-c f f" . format-all-buffer))
  :init
  ;; (add-hook 'prog-mode-hook 'format-all-mode)
  ;; (add-hook 'format-all-mode-hook 'format-all-ensure-formatter)
  (add-hook 'before-save-hook (lambda () (call-interactively #'format-all-buffer)))
  ;; :hook
  ;; (prog-mode-hook . format-all-mode)
  ;; (format-all-mode-hook . format-all-ensure-formatter)
  ;; (prog-mode-hook . (lambda ()
  ;;                       (add-hook 'before-save-hook #'format-all-buffer)))
  ;; (before-save-hook . #'format-all-buffer)
  )


;;; Evil-commentary
(use-package evil-commentary
  :ensure t
  :bind
  (:map evil-motion-state-map
        ("gC" . evil-commentary-yank))
  :hook
  (evil-mode-hook . evil-commentary-mode))

;;; Evil-surround
(use-package evil-surround
  :ensure t
  :hook
  (evil-local-mode-hook . evil-surround-mode))


;;; Evil-multiedit
(use-package evil-multiedit
  :defer 0.2
  :ensure t
  :bind
  (:map evil-motion-state-map
        ("M-d" . evil-multiedit-match-symbol-and-next)
        ("M-D" . evil-multiedit-match-symbol-and-prev)
        ("M-R" . evil-multiedit-match-all)
        ("C-M-d" . evil-multiedit-restore)))

;; Smartparens
(use-package smartparens
  :hook
  (after-init-hook . smartparens-global-mode)
  (after-init-hook . show-smartparens-global-mode)
  :config
  (sp-pair "`" nil :actions nil)
  (sp-pair "'" nil :actions nil))

;;; Evil-cleverparens
(use-package evil-cleverparens
  :ensure t
  :preface
  (defun do-not-map-M-s-and-M-d (f)
    (let ((evil-cp-additional-bindings
           (progn
             (assoc-delete-all "M-s" evil-cp-additional-bindings)
             (assoc-delete-all "M-D" evil-cp-additional-bindings)
             (assoc-delete-all "M-d" evil-cp-additional-bindings))))
      (funcall f)))
  :custom
  (evil-cleverparens-use-s-and-S nil)
  :hook
  ((emacs-lisp-mode-hook
    lisp-mode-hook
    scheme-mode-hook
    clojure-mode-hook
    clojurec-mode-hook
    clojurescript-mode-hook
    lisp-interaction-mode-hook) . evil-cleverparens-mode )
  :init
  (advice-add 'evil-cp-set-additional-bindings :around #'do-not-map-M-s-and-M-d))

(use-package undo-fu
  :ensure t)

;; jj --> esc
(use-package evil-escape
  :ensure t
  :config
  (evil-define-command kei/maybe-exit ()
    :repeat change
    (interactive)
    (let ((modified (buffer-modified-p)))
      (insert "о")
      (let ((evt (read-event nil 0.9)))
        (cond
         ((null evt) (message ""))
         ((and (integerp evt) (char-equal evt ?о))
	      (delete-char -1)
	      (set-buffer-modified-p modified)
	      (push 'escape unread-command-events))
         (t (setq unread-command-events (append unread-command-events
					                            (list evt))))))))
  :bind
  ;; oo --> esc
  (:map evil-insert-state-map
        ("о" . kei/maybe-exit))
  :custom
  (evil-escape-key-sequence "jj")
  (evil-escape-delay 0.2)
  (evil-escape-excluded-states '(normal
                                 visual
                                 multiedit
                                 emacs
                                 motion)))

;; (define-key evil-insert-state-map "о" #'kei/maybe-exit)


;; Fancy lambdas
(global-prettify-symbols-mode t)


;;; Which-key
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;; Helpful
(use-package helpful
  :ensure t
  :defer t)


;;; Reverse-im
(use-package reverse-im
  :ensure t
  :init
  :custom (reverse-im-input-methods '("russian-computer"))
  :config (reverse-im-mode t))

;; Localization
(use-package mule
  :defer 0.1
  :config
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-terminal-coding-system 'utf-8))

(use-package ispell
  :defer t
  :custom
  (ispell-local-dictionary-alist
   '(("russian"
      "[АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
      "[^АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
      "[-']"  nil ("-d" "uk_UA,ru_RU,en_US") nil utf-8)))
  (ispell-program-name "aspell")
  (ispell-dictionary "english")
  (ispell-really-aspell t)
  (ispell-really-hunspell nil)
  (ispell-encoding8-command t)
  (ispell-silently-savep t))

(use-package flyspell
  :defer t
  :custom
  (flyspell-delay 1))

(use-package flyspell-correct-popup
  :ensure t
  :bind (:map flyspell-mode-map
              ("C-c $" . flyspell-correct-at-point)))

;;; Fancy
(use-package olivetti
  :ensure t
  :custom
  (olivetti-body-width 95))

(use-package font-lock+
  :defer t
  :quelpa
  (font-lock+ :repo "emacsmirror/font-lock-plus" :fetcher github))

(use-package all-the-icons
  :ensure t
  :defer t
  :config
  (setq all-the-icons-mode-icon-alist
        `(,@all-the-icons-mode-icon-alist
          (package-menu-mode all-the-icons-octicon "package" :v-adjust 0.0)
          (telega-chat-mode all-the-icons-fileicon "telegram" :v-adjust 0.0
                            :face all-the-icons-blue-alt)
          (telega-root-mode all-the-icons-material "contacts" :v-adjust 0.0))))

(use-package all-the-icons-dired
  :ensure t
  :hook
  (dired-mode-hook . all-the-icons-dired-mode))

;;; TODO mb add to telega
(use-package emojify
  :ensure t
  :hook (elfeed-search-mode-hook . emojify-mode))

;;; Modeline
(use-package doom-modeline
  :ensure t
  :custom

  (doom-modeline-height 15)
  ;; (doom-modeline-enable-word-count t)
  :init
  (doom-modeline-mode 1)
  (display-time-mode 1)) ; Clock in modeline

(use-package anzu
  :ensure t
  :hook
  (after-init-hook . global-anzu-mode))

(use-package evil-anzu
  :ensure t)

;;; Imenu
(use-package imenu
  :bind
  (:map goto-map
        ("i" . imenu))
  :custom
  (imenu-auto-rescan t)
  (imenu-auto-rescan-maxout 60000)
  (imenu-use-popup-menu nil)
  (imenu-eager-completion-buffer t)
  :hook
  (imenu-after-jump-hook . recenter-top-bottom))

(use-package flimenu
  :ensure t
  :hook
  (after-init-hook . flimenu-global-mode))

;;; Kill-buffer
(use-package menu-bar
  :bind
  (:map ctl-x-map
        ("K" . kill-this-buffer)))

;;; Minibuffer
(use-package minibuffer
  :custom
  (completion-cycle-threshold 1)
  (completion-styles '(partial-completion orderless))
  (completion-show-help nil)
  :bind
  ("s-SPC" . completion-at-point))

(use-package minibuffer-eldef
  :hook
  (after-init-hook . minibuffer-electric-default-mode))

(use-package mb-depth
  :ensure t
  :hook
  (after-init-hook . minibuffer-depth-indicate-mode))

;;; Saveplace
(use-package saveplace
  :ensure t
  :hook
  (after-init-hook . save-place-mode))

;;; Savehist
(use-package savehist
  :custom
  (history-delete-duplicates t)
  :hook
  (after-init-hook . savehist-mode))


;;;; Emacs Lisp
(use-package elisp-mode
  :custom
  (eval-expression-print-level t)
  (eval-expression-print-length t)
  :bind
  (:map emacs-lisp-mode-map
        ("C-c e e" . eval-last-sexp)
        ("C-c e b" . eval-buffer)
        ("C-c e d" . eval-defun)
        ("C-c e p" . eval-print-last-sexp)
        ("C-c e r" . eval-region)
        ("C-c d d" . describe-function)))

(use-package eros
  :ensure t
  :hook
  (emacs-lisp-mode-hook . eros-mode))

(use-package suggest
  :ensure t
  :defer t)

(use-package ipretty
  :defer t
  :ensure t
  :config
  (ipretty-mode 1))

;;;; Scheme
(use-package scheme
  :bind
  (:map scheme-mode-map
        ("C-c c c" . geiser-connect)
        ("C-c c r" . run-geiser)))

(use-package geiser-mode
  :custom
  (geiser-active-implementations '(guile))
  :bind
  (:map geiser-mode-map
        ("C-C e e" . geiser-eval-last-sexp)
        ("C-C e d" . geiser-eval-definition)
        ("C-C e b" . geiser-eval-buffer)
        ("C-C m e" . geiser-expand-last-sexp)
        ("C-C m d" . geiser-expand-definition)
        ("C-C m r" . geiser-expand-region)
        ("C-C y"   . geiser-insert-lambda)
        ("C-C r b" . switch-to-geiser)
        ("C-C r q" . geiser-repl-exit)
        ("C-C r c" . geiser-repl-clear-buffer)))

;; REVIEW Do I really need this?
(use-package geiser-guile
  :ensure t)

;;; TODO https://git.sr.ht/~sokolov/geiser-eros
;; (use-package geiser-eros
;;   :hook
;;   (geiser-mode-hook . geiser-eros-mode))


;;; Icomplete
(use-package icomplete
  :after minibuffer
  :custom
  (icomplete-in-buffer t)
  (icomplete-delay-completions-threshold 0)
  (icomplete-max-delay-chars 0)
  (icomplete-compute-delay 0)
  (icomplete-show-matches-on-no-input t)
  (icomplete-show-common-prefix nil)
  (icomplete-prospects-height 10)
  :bind
  (:map icomplete-minibuffer-map
        ("C-j" . icomplete-forward-completions)
        ("C-n" . icomplete-forward-completions)
        ("C-k" . icomplete-backward-completions)
        ("C-p" . icomplete-backward-completions)
        ("C-l" . icomplete-force-complete)
        ("<return>" . icomplete-force-complete-and-exit)
        ("<tab>" . icomplete-force-complete)
        ("C-u" . kill-whole-line)
        ("<backspace>" . kei/minibuffer-backward-updir))
  :config
  (defun kei/minibuffer-backward-updir ()
    "Delete char before point or go up a directory.
Must be bound to `minibuffer-local-filename-completion-map'."
    (interactive)
    (if (and (eq (char-before) ?/)
             (eq (kei/minibuffer--completion-category) 'file))
        (save-excursion
          (goto-char (1- (point)))
          (when (search-backward "/" (point-min) t)
            (delete-region (1+ (point)) (point-max))))
      (call-interactively 'backward-delete-char)))

  (defun kei/minibuffer--completion-category ()
    "Return completion category."
    (let* ((beg (kei/minibuffer--field-beg))
           (md (completion--field-metadata beg)))
      (alist-get 'category (cdr md))))

  (defun kei/minibuffer--field-beg ()
    "Determine beginning of completion."
    (if (window-minibuffer-p)
        (minibuffer-prompt-end)
      (nth 0 completion-in-region--data)))

  :hook
  (after-init-hook . icomplete-mode))

(use-package icomplete-vertical
  :ensure t
  :bind
  (:map icomplete-minibuffer-map
        ("C-t" . icomplete-vertical-toggle))
  :hook
  (icomplete-mode-hook . icomplete-vertical-mode))

;;; Marginalia
(use-package marginalia
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy
                           marginalia-annotators-light))
  :hook
  (after-init-hook . marginalia-mode))

;;; Orderless
(use-package orderless
  :ensure t
  :after icomplete
  :preface
  (defun orderless-literal-dispatcher (p _ _)
    (when (string-prefix-p "=" p)
      `(orderless-literal . ,(substring p 1))))
  (defun orderless-sli-dispatcher (p _ _)
    (when (string-prefix-p "-" p)
      `(orderless-strict-leading-initialism . ,(substring p 1))))
  :custom
  (orderless-matching-styles '(orderless-flex orderless-regexp))
  (orderless-style-dispatchers '(orderless-literal-dispatcher
                                 orderless-sli-dispatcher)))

;;; Consult
(use-package consult
  :ensure t
  :custom
  (completion-in-region-function 'consult-completion-in-region)
  :bind
  (:map goto-map
        ("o" . consult-outline)
        ("i" . consult-imenu)
        ("E" . consult-compile-error)
        ("f" . consult-flymake))
  :config
  (setf (alist-get #'consult-completion-in-region consult-config)
        '(:completion-styles (basic))))

;;; Pdf
(use-package pdf-tools
  :ensure t
  :custom
  (pdf-view-display-size 'fit-height)
  :config
  (pdf-tools-install))

(use-package pdf-view-restore
  :ensure t
  :after pdf-tools
  :hook
  (pdf-view-mode-hook . pdf-view-restore-mode))

;;;; Highlighting
(use-package hl-line
  :hook
  (prog-mode-hook . hl-line-mode))

(use-package page-break-lines
  :ensure t
  :hook
  ((help-mode-hook
    prog-mode-hook
    special-mode
    compilation-mode) . page-break-lines-mode))


(use-package rainbow-mode
  :ensure t
  :hook
  ((prog-mode-hook
    help-mode-hook) . rainbow-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode))

(use-package evil-goggles
  :ensure t
  :custom
  (evil-goggles-duration 0.150)
  (evil-goggles-enable-delete nil)
  :config
  (evil-goggles-mode)
  (evil-goggles-use-diff-faces))

(use-package hl-todo
  :ensure t
  :custom-face
  (hl-todo ((t (:inherit hl-todo :italic t))))
  :hook
  ((prog-mode-hook
    yaml-mode-hook) . hl-todo-mode))

(use-package so-long
  :ensure t
  :hook
  (after-init-hook . global-so-long-mode))

;;;; Projectile
(use-package projectile
  :defer 0.2
  :ensure t
  :init (projectile-mode +1)
  :bind
  (:map mode-specific-map ("p" . projectile-command-map))
  :custom
  (projectile-project-search-path (cddr (directory-files "~/code/" t)))
  (projectile-require-project-root nil)
  (projectile-project-root-files-functions
   '(projectile-root-local
     projectile-root-top-down
     projectile-root-bottom-up
     projectile-root-top-down-recurring))
  (projectile-completion-system 'default))


;;;; Autocompletion
;;; Company
(use-package company
  :ensure t
  :custom
  (company-backends '((company-capf company-dabbrev-code company-files)))
  :bind
  (:map company-active-map
        ("C-j" . company-select-next)
        ("C-n" . company-select-next)
        ("C-k" . company-select-previous)
        ("C-p" . company-select-previous)
        ("C-l" . company-complete-selection)
        ;; ("RET" . company-complete-selection)
        ([tab] . company-complete-common-or-cycle))
  :hook
  (after-init-hook . global-company-mode))

;;; Vterm
(use-package vterm
  :ensure t
  :config
  (setq vterm-buffer-name "vterm")
  (setq vterm-toggle-fullscreen-p nil)
  (add-to-list 'display-buffer-alist
               '((lambda(bufname _) (with-current-buffer bufname (equal major-mode 'vterm-mode)))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3)))

  (defun +vterm/toggle (arg)
    "Toggles a terminal popup window at project root.

If prefix ARG is non-nil, recreate vterm buffer in the current project's root.

Returns the vterm buffer."
    (interactive "P")
    (+vterm--configure-project-root-and-display
     arg
     (lambda()
       (let ((buffer-name
              (format "*vterm-popup:%s*"
                      (if (bound-and-true-p persp-mode)
                          (safe-persp-name (get-current-persp))
                        "main")))
             confirm-kill-processes
             current-prefix-arg)
         (when arg
           (let ((buffer (get-buffer buffer-name))
                 (window (get-buffer-window buffer-name)))
             (when (buffer-live-p buffer)
               (kill-buffer buffer))
             (when (window-live-p window)
               (delete-window window))))
         (if-let (win (get-buffer-window buffer-name))
             (if (eq (selected-window) win)
                 (delete-window win)
               (select-window win)
               (when (bound-and-true-p evil-local-mode)
                 (evil-change-to-initial-state))
               (goto-char (point-max)))
           (let ((buffer (get-buffer-create buffer-name)))
             (with-current-buffer buffer
               (unless (eq major-mode 'vterm-mode)
                 (vterm-mode))
               (+vterm--change-directory-if-remote))
             (pop-to-buffer buffer)))
         (get-buffer buffer-name)))))

  (defun +vterm/here (arg)
    "Open a terminal buffer in the current window at project root.

If prefix ARG is non-nil, cd into `default-directory' instead of project root.

Returns the vterm buffer."
    (interactive "P")
    (+vterm--configure-project-root-and-display
     arg
     (lambda()
       (require 'vterm)
       ;; HACK forces vterm to redraw, fixing strange artefacting in the tty.
       (save-window-excursion
         (pop-to-buffer "*scratch*"))
       (let (display-buffer-alist)
         (vterm vterm-buffer-name)))))

  (defun +vterm--configure-project-root-and-display (arg display-fn)
    "Sets the environment variable PROOT and displays a terminal using `display-fn`.

If prefix ARG is non-nil, cd into `default-directory' instead of project root.

Returns the vterm buffer."
    (unless (fboundp 'module-load)
      (user-error "Your build of Emacs lacks dynamic modules support and cannot load vterm"))
    (let* ((project-root default-directory)
           (default-directory
             (if arg
                 default-directory
               project-root)))
      (setenv "PROOT" project-root)
      (prog1 (funcall display-fn)
        (+vterm--change-directory-if-remote))))

  (defun +vterm--change-directory-if-remote ()
    "When `default-directory` is remote, use the corresponding
method to prepare vterm at the corresponding remote directory."
    (when (and (featurep 'tramp)
               (tramp-tramp-file-p default-directory))
      (message "default-directory is %s" default-directory)
      (with-parsed-tramp-file-name default-directory path
        (let ((method (cadr (assoc `tramp-login-program
                                   (assoc path-method tramp-methods)))))
          (vterm-send-string
           (concat method " "
                   (when path-user (concat path-user "@")) path-host))
          (vterm-send-return)
          (vterm-send-string
           (concat "cd " path-localname))
          (vterm-send-return)))))
  :bind
  (:map evil-motion-state-map
        ("C-c k V" . +vterm/here)
        ("C-c k v" . +vterm/toggle)))


;;;; Quick jumps
;;; Avy
(use-package avy
  :ensure t
  :bind
  (:map evil-motion-state-map
        ("g s" .   avy-goto-char-timer)
        :map goto-map
        ("M-g" . avy-goto-line)
        :map search-map
        ("M-s" . avy-goto-word-1)))

(use-package link-hint
  :ensure t
  :bind
  (("C-c k l o" . link-hint-open-link)
   ("C-c k l c" . link-hint-copy-link)))

(use-package frog-jump-buffer
  :ensure t
  :bind
  (:map goto-map
        ("b" . frog-jump-buffer)))

;;;; Lookup

;;; Google-this
(use-package google-this
  :defer 0.1
  :ensure t
  :bind
  (:map mode-specific-map
        ("g" . google-this-mode-submap)))

;;; Google-translate
(use-package google-translate
  :ensure t
  :commands (google-translate-smooth-translate)
  :after google-this
  :config
  (defun kei/google-translate-at-point (arg)
    "Translate word at point. If prefix is provided, do reverse translation"
    (interactive "P")
    (if arg
	    (google-translate-at-point-reverse)
      (google-translate-at-point)))

  (require 'google-translate-default-ui)
  (require 'google-translate-smooth-ui)
  (setq google-translate-show-phonetic t)

  ;; (setq google-translate-default-source-language "en"
  ;;       google-translate-default-target-language "ru")

  (setq google-translate-translation-directions-alist '(("en" . "ru") ("ru" . "en") ("en" . "uk") ("uk" . "en")))

  ;; auto-toggle input method
  (setq google-translate-input-method-auto-toggling t
	    google-translate-preferable-input-methods-alist '((nil . ("en"))
							                              (russian-computer . ("ru"))))
  :bind
  (:map google-this-mode-submap
        ("n" . google-translate-smooth-translate)
        ("T" . kei/google-translate-at-point)))

;;;; FIXME find a better way to define this?
(require 'google-translate)
(defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
(setq google-translate-backend-method 'curl)

;; Google-translate dependency
(use-package popup
  :ensure t)

;;; Tabs
(use-package tab-bar
  :custom
  (tab-bar-close-button-show . nil)
  (tab-bar-position . nil)
  (tab-bar-show . nil)
  (tab-bar-tab-hints . nil)
  :config
  (setq tab-bar-new-tab-choice t)
  (setq tab-bar-close-last-tab-choice 'tab-bar-mode-disable)
  (setq tab-bar-close-tab-select 'recent)
  (setq tab-bar-new-tab-to 'right)
  (setq tab-bar-tab-name-function 'tab-bar-tab-name-all)
  (tab-bar-mode -1)
  (tab-bar-history-mode -1)

  (defun kei/tab-bar-select-tab-dwim ()
    "Do-What-I-Mean function for getting to a `tab-bar-mode' tab.
If no other tab exists, create one and switch to it.  If there is
one other tab (so two in total) switch to it without further
questions.  Else use completion to select the tab to switch to."
    (interactive)
    (let ((tabs (mapcar (lambda (tab)
                          (alist-get 'name tab))
                        (tab-bar--tabs-recent))))
      (cond ((eq tabs nil)
             (tab-new))
            ((eq (length tabs) 1)
             (tab-next))
            (t
             (icomplete-vertical-do ()
               (tab-bar-switch-to-tab
                (completing-read "Select tab: " tabs nil t)))))))

  :bind (("C-x t t" . kei/tab-bar-select-tab-dwim)
         ("C-x t n" . tab-new)
         ("C-x t q" . tab-close)
         ("C-x t s" . tab-switcher)))

;;;; Snippets
(use-package autoinsert
  :hook
  (find-file . auto-insert))

(use-package yasnippet
  :defer 0.2
  :ensure t
  :custom
  (yas-prompt-functions '(yas-completing-prompt))
  :config
  (yas-reload-all)
  :hook
  (prog-mode-hook  . yas-minor-mode))

(use-package doom-snippets
  :quelpa
  (doom-snippets
   :repo "hlissner/doom-snippets"
   :fetcher github
   :files ("*" (:exclude ".*" "README.md")))
  :after yasnippet)

;;; LSP
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (((c-mode
           cc-mode
           c++-mode
           sh-mode
           js-mode
           js2-mode) . lsp)
         (lsp-mode . lsp-enable-whick-key-integration)))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package compile
  :defer t
  :custom
  (compilation-scroll-output t))

;;;; Clojure
(use-package flymake-kondor
  :ensure t
  :hook
  ((clojure-mode-hook
    clojurec-mode-hook
    clojurescript-mode-hook) . flymake-kondor-setup))

(use-package eldoc
  :ensure t
  :defer t
  :custom
  (eldoc-echo-area-use-multiline-p nil))

(use-package cider-mode
  :custom
  (cider-font-lock-dynamically nil)
  (cider-font-lock-reader-conditionals nil)
  :bind
  (:map cider-mode-map
        ("C-c x" . cider-interrupt)
        ("C-c e u" . cider-undef)
        ("C-c r c" . cider-find-and-clear-repl-output)
        ("C-c e e" . cider-eval-last-sexp)
        ("C-c e b" . cider-eval-buffer)
        ("C-c e d" . cider-eval-defun-at-point)
        ("C-c e r" . cider-eval-region)
        ("C-c n p" . cider-pprint-eval-last-sexp)
        ("C-c n P" . cider-pprint-eval-last-sexp-to-comment)
        ("C-c n d" . cider-pprint-eval-defun-at-point)
        ("C-c n D" . cider-pprint-eval-defun-to-comment)
        ("C-c t n" . cider-test-run-ns-tests)
        ("C-c t t" . cider-test-run-test)
        ("C-c t p" . cider-test-run-project-tests)
        ("C-c m m" . cider-macroexpand-1)
        ("C-c m M" . cider-macroexpand-all)
        ("C-c r q" . cider-quit)))

(use-package cider-eldoc
  :after cider-mode eldoc
  :custom
  (cider-eldoc-display-context-dependent-info t))

(use-package cider-common
  :after cider-mode
  :custom
  (cider-prompt-for-symbol nil)
  (cider-special-mode-truncate-lines nil))

(use-package cider-repl
  :after cider-mode
  :bind
  (:map cider-repl-mode-map
        ("C-c q" . cider-quit)
        ("C-c c" . cider-repl-clear-buffer))
  :custom
  (cider-repl-pop-to-buffer-on-connect nil)
  (cider-repl-display-in-current-window t)
  (cider-repl-buffer-size-limit 600)
  :init
  (advice-add 'cider-repl--insert-banner :override #'ignore))

(use-package cider-completion
  :after cider-mode
  :custom
  (cider-completion-use-context nil)
  (cider-completion-annotations-include-ns 'always))

(use-package clojure-mode
  :ensure t
  :bind
  (:map clojure-mode-map
        ("C-c c" . cider-connect-clj)))

(use-package nrepl-client
  :defer t
  :custom
  (nrepl-hide-special-buffers t))

;;; Debugger
;; (use-package dap-mode
;;   :defer t
;;   :ensure t
;;   ;; :init
;;   ;; (dap-gdb-lldb-setup)
;;   :custom
;;   (dap-auto-configure-mode t                           "Automatically configure dap.")
;;   (dap-auto-configure-features
;;    '(sessions locals breakpoints expressions tooltip)  "Remove the button panel in the top.")
;;   :config
;;   (require 'dap-gdb-lldb)
;;   :bind
;;   (:map dap-mode-map
;;         ("C-c d s" . dap-debug)
;;         ("C-c d p" . dap-debug-last)
;;         ("C-c d n" . dap-debug-last)
;;         ("C-c d t" . dap-breakpoint-toggle)
;;         ("C-c d c" . dap-breakpoint-condition)
;;         ("C-c d h" . dap-breakpoint-hit-condition)
;;         ("C-c d H" . dap-hydra)
;;         ("C-c d l" . dap-breakpoint-log-message)
;;         ("C-c d D" . dap-breakpoint-delete)
;;         ("C-c d P" . dap-ui-breakpoints)))


;;;; CC
(use-package ccls
  :ensure t)

(use-package gdb
  :hook
  (gdb-mode-hook . gdb-many-windows)
  :hook
  (c-mode-hook . (lambda ()
                   (define-key c-mode-base-map (kbd "C-c d g") 'gdb)
                   (define-key c-mode-base-map (kbd "C-c d W") 'gdb-many-windows)
                   (define-key c-mode-base-map (kbd "C-c d b") 'gud-break)
                   (define-key c-mode-base-map (kbd "C-c d d") 'gud-remove)
                   (define-key c-mode-base-map (kbd "C-c d r") 'gud-remove)
                   (define-key c-mode-base-map (kbd "C-c d R") 'gud-refresh)
                   (define-key c-mode-base-map (kbd "C-c d p") 'gud-print)
                   (define-key c-mode-base-map (kbd "C-c d n") 'gud-next)
                   (define-key c-mode-base-map (kbd "C-c d w") 'gud-watch)
                   (define-key c-mode-base-map (kbd "C-c d c") 'gud-cont)
                   (define-key c-mode-base-map (kbd "C-c d s") 'gud-step)
                   (define-key c-mode-base-map (kbd "C-c d x") 'gud-finish))))


;;;; Rust
(use-package rustic
  :ensure t
  :bind
  (:map rustic-mode-map
        ("C-c c c" . rustic-compile)
        ("C-c c r" . rustic-recompile)
        ("C-c c s" . rustic-compile-send-input)
        ("C-c i b" . rustic-format-buffer)
        ("C-c i f" . rustic-format-file)
        ("C-c i w" . rustic-cargo-fmt)
        ;; TODO install cargo-edit
        ("C-c e a" . rustic-cargo-add)
        ("C-c e r" . rustic-cargo-rm)
        ("C-c e u" . rustic-cargo-upgrade)
        ("C-c e o" . rustic-cargo-outdated)
        ("C-c t t" . rustic-cargo-test)
        ("C-c t r" . rustic-cargo-test-rerun)
        ("C-c t c" . rustic-cargo-current-test)
        ;;; FIXME gdb
        ("C-c d g" . gdb)
        ("C-c d W" . gdb-many-windows)
        ("C-c d b" . gud-break)
        ("C-c d d" . gud-remove)
        ("C-c d r" . gud-remove)
        ("C-c d R" . gud-refresh)
        ("C-c d p" . gud-print)
        ("C-c d n" . gud-next)
        ("C-c d w" . gud-watch)
        ("C-c d c" . gud-cont)
        ("C-c d s" . gud-step)
        ("C-c d x" . gud-finish)))

;;; Lua (just for awesomewm)
(use-package lua-mode
  :ensure t)

;;; Common Lisp
(use-package sly
  :ensure t
  :config
  (setq inferior-lisp-program "/etc/profiles/per-user/kei/bin/sbcl")
  :hook
  (sly-mode-hook . (lambda ()
                     (unless (sly-connected-p)
                       (save-excursion (sly)))))
  :bind
  (:map sly-mode-map
        ("C-c x" . sly-interrup)
        ("C-c d i" . sly-documentation-lookup)
        ("C-c d s" . sly-describe-symbol)
        ("C-c d f" . sly-describe-function)
        ("C-c d a" . sly-apropos)
        ("C-c d h" . sly-hyperspec-lookup)
        ("C-c e u" . sly-undefine-function)
        ("C-c e i" . sly-interactive-eval)
        ("C-c e e" . sly-eval-last-expression)
        ("C-c e d" . sly-eval-defun)
        ("C-c e r" . sly-eval-region)
        ("C-c e l" . sly-load-file)
        ("C-c e p" . sly-pprint-eval-last-expresion)
        ("C-c c d" . sly-compile-defun)
        ("C-c c i" . sly-interactive-eval)
        ("C-c c f" . sly-compile-file)
        ("C-c c l" . sly-compile-and-load-file)
        ("C-c c r" . sly-compile-region)
        ("C-c n d" . sly-stickers-dwim)
        ("C-c n r" . sly-stickers-replay)
        ("C-c n t" . sly-stickers-toggle-break-on-stickers)
        ("C-c n f" . sly-stickers-fetch)
        ("C-c n n" . sly-stickers-next-sticker)
        ("C-c n p" . sly-stickers-prev-sticker)
        ("C-c m m" . sly-macroexpand-1)
        ("C-c m M" . sly-macroexpand-all)
        ("C-c m s" . sly-format-string-expand)
        ("C-c r s" . sly-mrepl)))

(use-package sly-quicklisp
  :ensure t)

(use-package sly-named-readtables
  :ensure t)

(use-package sly-macrostep
  :ensure t
  :bind
  (:map sly-prefix-map
        ("C-c m e" . macrostep-expand)))

(use-package sly-asdf
  :ensure t)

;;;; Nix
(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :bind
  (:map nix-mode-map
        ("C-c b" . nix-build)
        ("C-c r r" . nix-repl-show)
        ("C-c r s" . nix-repl-shell)
        ("C-c U" . nix-unpack)))

(use-package nix-update
  :ensure t
  :bind
  (:map nix-mode-map
        ("C-c u" . nix-update-fetch)))

;;; TODO Get rid of ivy/helm dependency
;; (use-package ivy-nixos-options
(use-package helm-nixos-options
  :ensure t
  :bind
  (:map nix-mode-map
        ("C-c d" . helm-nixos-options)))
;; ("C-c d" . ivy-nixos-options)))


;;;; Shell
(use-package sh-mode
  :hook
  (after-save-hook . executable-make-buffer-file-executable-if-script-p))

(use-package company-shell
  :ensure t
  :config
  (add-to-list 'company-backends '(company-shell company-shell-env)))

;;;; JSON
(use-package json-mode
  :ensure t)

(use-package json-snatcher
  :ensure t
  :bind
  (:map js-mode-map
        ("C-c p" . jsons-print-path))
  :hook '(js-mode js2-mode))

;;;; JS & TS
;; TODO mb config fully
;; + [[https://github.com/defunkt/coffee-mode][coffee-mode]]
;; + [[https://github.com/mooz/js2-mode][js2-mode]]
;; + [[https://github.com/felipeochoa/rjsx-mode][rjsx-mode]]
;; + [[https://github.com/emacs-typescript/typescript.el][typescript-mode]]
;; + [[https://github.com/magnars/js2-refactor.el][js2-refactor]]
;; + [[https://github.com/mojochao/npm-mode][npm-mode]]
;; + [[https://github.com/abicky/nodejs-repl.el][nodejs-repl]]
;; + [[https://github.com/skeeto/skewer-mode][skewer-mode]]
;; + [[https://github.com/ananthakumaran/tide][tide]]
;; + [[https://github.com/NicolasPetton/xref-js2][xref-js2]]*

(use-package coffee-mode
  :ensure t)

(use-package js2-mode
  :ensure t)

(use-package rjsx-mode
  :ensure t)

(use-package typescript-mode
  :ensure t)

(use-package skewer-mode
  :ensure t)

(use-package tide
  :ensure t)

;;;; Markdown
(use-package markdown-mode
  :ensure t)

;;;; Latex
(use-package auctex
  :defer t
  :ensure t)

(use-package adaptive-wrap
  :ensure t
  :hook
  (LaTeX-mode-hook . adaptive-wrap-prefix-mode))

(use-package evil-tex
  :ensure t)

(use-package latex-preview-pane
  :ensure t
  :hook
  (LaTeX-mode-hook . latex-preview-pane-mode)
  :bind
  (:map LaTeX-mode-map
        ("C-c v u" . latex-preview-pane-update)
        ("C-c v s" . latex-preview-pane-mode)))

(use-package company-auctex
  :ensure t
  :init
  (company-auctex-init))

(use-package company-math
  :ensure t
  :config
  (add-to-list 'company-backends 'company-math-symbols-unicode))

;;; Magit

;; (use-package keychain-environment
;;   :ensure t
;;   :init
;;   (keychain-refresh-environment))

(use-package ssh-agency
  :ensure t)

(use-package magit
  :ensure t
  :custom
  (magit-log-margin '(t age-abbreviated magit-log-margin-width t 7))
  :bind
  ;; (:map magit-mode-map
  ;;       ("<tab>" . magit-section-toggle))
  ("C-c p m" . magit-project-status)
  ("C-c m a" . magit-stage-file)       ; the closest analog to git add
  ("C-c m b" . magit-blame)
  ("C-c m B" . magit-branch)
  ("C-c m c" . magit-checkout)
  ("C-c m C" . magit-commit)
  ("C-c m d" . magit-diff)
  ("C-c m D" . magit-discard)
  ("C-c m f" . magit-fetch)
  ("C-c m g" . vc-git-grep)
  ("C-c m G" . magit-gitignore)
  ("C-c m i" . magit-init)
  ("C-c m l" . magit-log)
  ("C-c m m" . magit)
  ("C-c m M" . magit-merge)
  ("C-c m n" . magit-notes-edit)
  ("C-c m p" . magit-pull-branch)
  ("C-c m P" . magit-push-current)
  ("C-c m r" . magit-reset)
  ("C-c m R" . magit-rebase)
  ("C-c m s" . magit-status)
  ("C-c m S" . magit-stash)
  ("C-c m t" . magit-tag)
  ("C-c m T" . magit-tag-delete)
  ("C-c m u" . magit-unstage)
  ("C-c m U" . magit-update-index))

(use-package evil-collection-magit
  :disabled t
  :after magit
  :custom
  (evil-collection-magit-want-horizontal-movement t)
  (evil-collection-magit-use-y-for-yank t))

(use-package forge
  :defer t
  :after magit
  :ensure t)

;;; Org
(use-package calendar
  :defer t
  :custom (calendar-week-start-day 1))

(use-package org-fancy-priorities
  :ensure t
  :hook
  (org-mode-hook . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))


(use-package org
  :hook (org-mode-hook . variable-pitch-mode)
  :hook (org-mode-hook . org-num-mode)
  :bind (:map org-mode-map
              ("C-c '"   . org-edit-src-code)
              ("C-c o q" . org-set-tags-command)
              ("C-c o t" . org-todo)
              ("C-c o p" . org-priority)
              ("C-c o r" . org-refile)
              ("C-c o s" . org-schedule)
              ("C-c o d" . org-deadline)
              :map org-src-mode-map
              ("C-c '"   . org-edit-src-exit))
  :custom
  (org-default-notes-file "~/org/todo.org")
  (org-hidden-keywords '(title author date startup))
  (org-hide-emphasis-markers t)
  (org-tag-alist '(("study" . ?s) ("nixos"  . ?n)
                   ("video" . ?v) ("prog"   . ?p)
                   ("listen" . ?l) ("read"  . ?r)
                   ("emacs"  . ?e) ("gtd"   . ?t)
                   ("write"  . ?w) ("idea"  . ?i)
                   ("en")))
  (org-startup-folded 'overview)
  (org-ellipsis "↩")
  (org-direcotry "~/org")
  (org-adapt-indentation nil)
  (org-hide-leading-stars t)
  (org-image-actual-width nil)
  (org-refile-targets '((nil :maxlevel . 2)
                        (org-agenda-files :maxlevel . 2)))
  :config
  (defun org-get-level-face (n)
    "Get the right face for match N in font-lock matching of headlines."
    (let* ((org-l0 (- (match-end 2) (match-beginning 1) 1))
           (org-l (if org-odd-levels-only (1+ (/ org-l0 2)) org-l0))
           (org-f (if org-cycle-level-faces
                      (nth (% (1- org-l) org-n-level-faces) org-level-faces)
                    (nth (1- (min org-l org-n-level-faces)) org-level-faces))))
      (cond
       ((eq n 1) (if org-hide-leading-stars 'org-hide org-f))
       ((eq n 2) 'org-hide)
       (t (unless org-level-color-stars-only org-f))))))


(use-package org-src
  :custom (org-src-window-setup 'current-window))

(use-package org-agenda
  :bind (("C-c o a" . org-agenda-list)
         ("C-c o A" . org-agenda))
  :config
  (setq org-agenda-files '("~/org/todo.org"
                           "~/org/learning.org"
                           "~/org/university.org"
                           "~/org/birthdays.org"
                           "~/org/habits.org"
                           "~/org/books.org"
                           "~/org/bookmarks.org"
                           "~/org/life.org"))

  (setq org-agenda-custom-commands
	    '(("p" tags-todo "+prog"
	       ((org-agenda-overriding-header "Things to learn on practice")
	        (org-agenda-files org-agenda-files)))

	      ("s" tags-todo "+study"
	       ((org-agenda-overriding-header "Things to study")
	        (org-agenda-files org-agenda-files)))

	      ("w" tags-todo "+write"
	       ((org-agenda-overriding-header "Things that include writing")
	        (org-agenda-files org-agenda-files)))

	      ("l" tags-todo "+listen"
	       ((org-agenda-overriding-header "Things to listen")
	        (org-agenda-files org-agenda-files)))

	      ("v" tags-todo "+video-prog"
	       ((org-agenda-overriding-header "Things to watch without practice")
	        (org-agenda-files org-agenda-files)))

	      ("V" tags-todo "+video+prog"
	       ((org-agenda-overriding-header "Things to watch and practice")
	        (org-agenda-files org-agenda-files)))

	      ("r" tags-todo "+read"
	       ((org-agenda-overriding-header "Things to read")
	        (org-agenda-files org-agenda-files)))

	      ("e" tags-todo "+emacs"
	       ((org-agenda-overriding-header "Things to hack on emacs")
	        (org-agenda-files org-agenda-files)))

	      ("n" tags-todo "+nixos"
	       ((org-agenda-overriding-header "Things to hack on nixos")
	        (org-agenda-files org-agenda-files)))

	      ("u" tags-todo "+university"
	       ((org-agenda-overriding-header "Things for university")
	        (org-agenda-files org-agenda-files)))))
  :custom
  (org-agenda-skip-scheduled-if-done . nil)
  (org-agenda-skip-deadline-if-done . nil))

;; (use-package org-roam
;;   :ensure t
;;   :bind (("C-c o c" . org-roam-capture)
;;          :map org-roam-mode-map
;;          (("C-c n l" . org-roam)
;;           ("C-c n f" . org-roam-find-file)
;;           ("C-c n u" . org-roam-buffer-update)
;;           ("C-c n g" . org-roam-graph))
;;          :map org-mode-map
;;          ("C-c n i" . org-roam-insert)
;;          ("C-c n I" . org-roam-insert-immediate))
;;   :custom
;;   (org-roam-capture-templates
;;    `(0("b" "Bookmark" entry
;; 	   (file+olp "~/org/bookmarks.org")
;; 	   "* [[%?][]] \n")
;; 	  ("l" "Learn" entry
;; 	   (file+olp "~/org/learning.org")
;; 	   "\n* TODO [[%?][]] \n")
;; 	  ("u" "University" entry
;; 	   (file+olp+datetree "~/org/university.org")
;; 	   "* TODO DEADLINE: %t %? :university:\n")
;; 	  ("i" "Ideas" entry
;; 	   (file+olp+datetree "~/org/ideas.org")
;; 	   "* %T %? :idea:\n")))

;;   (org-roam-directory
;;    (file-truename "~/org/roam/")))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; Dashboard
;; ALWAYS IN THE END!
(use-package dashboard
  :ensure t
  :preface
  (defun kei/dashboard-banner ()
    "Set a dashboard banner including information on package initialization
			   time and garbage collections."""
    (setq dashboard-banner-logo-title
	      (format "Emacs ready in %.2f seconds with %d garbage collections."
		          (float-time (time-subtract after-init-time before-init-time)) gcs-done)))
  :custom
  (dashboard-startup-banner "~/pix/doom/stallman.png")
  (dashboard-center-content t)
  (dashboard-items '((recents  . 5)
                     ;; (bookmarks . 5)
                     ;; (registers . 5)
                     ;; (projects . 5)
                     (agenda . 5)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-refresh-buffer))
