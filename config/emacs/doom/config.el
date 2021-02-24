;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Druk Alexander" user-mail-address "druksasha@ukr.net")

(setq doom-font (font-spec :family "IBM Plex Mono" :size 13)
      doom-big-font (font-spec :family "IBM Plex Mono")
      doom-variable-pitch-font (font-spec :family "IBM Plex Mono" :size 13)
      doom-serif-font (font-spec :family "IBM Plex Mono" :weight 'light))

;; (setq doom-font (font-spec :family "Hack" :size 12)
;;       doom-big-font (font-spec :family "Hack")
;;       doom-variable-pitch-font (font-spec :family "Hack" :size 12)
;;       doom-serif-font (font-spec :family "Hack" :weight 'light))

;; (setq doom-font (font-spec :family "FiraCode" :size 12)
;;       doom-big-font (font-spec :family "FiraCode")
;;       doom-variable-pitch-font (font-spec :family "FiraCode" :size 12)
;;       doom-serif-font (font-spec :family "FiraCode" :weight 'light))

;; (setq doom-font (font-spec :family "Iosevka" :size 13)
;;       doom-big-font (font-spec :family "Iosevka")
;;       doom-variable-pitch-font (font-spec :family "Iosevka" :size 13)
;;       doom-serif-font (font-spec :family "Iosevka" :weight 'light))

(after! doom-themes
  (setq doom-themes-enable-bold t doom-themes-enable-italic t))
(custom-set-faces! '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(if (file-exists-p "~/.config/doom/current-theme.el")
    (load-file "~/.config/doom/current-theme.el")
  nil)

;; ;; Terminal mode
;; (unless (display-graphic-p)
;;   (setq doom-theme 'modus-operandi)
;;   (use-package! evil-terminal-cursor-changer
;;     :hook (tty-setup . evil-terminal-cursor-changer-activate)))


;; (setq doom-theme 'doom-acario-light)
;; ;; (setq doom-theme 'tango)
;; (setq calendar-location-name "Europe, Kiev")
;; (setq calendar-latitude 50.43)
;; (setq calendar-longitude 30.52)
;; (use-package theme-changer)
;; (if (daemonp)
;;     (add-hook 'after-make-frame-functions
;; 	      (lambda (frame)
;; 		(select-frame frame)
;; 		(if (display-graphic-p)
;; 		    ;; (change-theme 'doom-acario-light 'doom-acario-light)
;; 		    ;; (change-theme 'tango 'tango)
;; 		    (setq doom-theme 'doom-acario-light)
;; 		  ))))

;; (change-theme 'doom-acario-light 'doom-acario-light)
;; (change-theme 'doom-acario-light 'doom-acario-dark)
;; (change-theme 'modus-operandi 'modus-vivendi)
;; (change-theme 'modus-operandi 'modus-vivendi)
;; (change-theme 'doom-tomorrow-day 'doom-gruvbox)
;; (change-theme 'doom-solarized-light 'doom-solarized-light)

;; Dashboard
;; (use-package dashboard
;;   :preface
;;   (defun mediocre/dashboard-banner ()
;;     "Set a dashboard banner including information on package initialization
;; 			   time and garbage collections."""
;;     (setq dashboard-banner-logo-title
;; 	  (format "Emacs ready in %.2f seconds with %d garbage collections."
;; 		  (float-time (time-subtract after-init-time before-init-time)) gcs-done)))
;;   :config
;;   (setq dashboard-startup-banner "~/pix/doom/stallman.png")
;;   (setq dashboard-center-content t)
;;   (dashboard-setup-startup-hook)
;;   :hook ((after-init     . dashboard-refresh-buffer)
;; 	 (dashboard-mode . mediocre/dashboard-banner)))

;; Setup fringes
(set-fringe-mode 5)

;; Which-key global-mode
(which-key-mode)

;; Line number
(setq display-line-numbers-type nil)

;; disable o/O continue commented lines
(setq +evil-want-o/O-to-continue-comments nil)

;;; Keybindings
;; Leader-key setup
(map! "C-SPC" nil)
(setq doom-leader-alt-key "C-SPC")
(setq doom-localleader-alt-key "C-SPC m")

;;; TODO rewrite with mediocre/leader-key-def what possible
;; (define-key evil-motion-state-map " " nil)
;; SPC k to save buffer
(map! :leader :g :desc "save-buffer" "k" 'save-buffer)
;; (define-key evil-motion-state-map (kbd "SPC k") 'save-buffer)

;; TODO
(global-hl-todo-mode)

;; SPC ] to call ibuffer
(map! :leader :g :desc "ibuffer" "]" 'ibuffer)

;; Switch buffer with C-j
(map! :leader :desc "switch-buffer" "C-j" 'counsel-switch-buffer)

;; jj --> esc
(setq key-chord-two-keys-delay 0.9)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)
;; oo --> esc
(define-key evil-insert-state-map "о" #'mediocre/maybe-exit)

(evil-define-command mediocre/maybe-exit ()
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

;;; Rust
(use-package rust-mode
  :mode "\\.rs\\'"
  :init (setq rust-format-on-save t))

(use-package cargo
  :defer t)

;; Racer
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)
(setq company-tooltip-align-annotations t)

;; Rustic flycheck
;; (remove-hook 'rustic-mode-hook 'flycheck-mode)

;;; Miscellaneous
;; When saving a file that start with '#!', make it executable
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; Treat CamelCaseSubWords as separate words in every programming mode
;; (add-hook 'prog-mode-hook 'subword-mode)

(defun pdf-view-save-page ()
  "Save the current page number for the document."
  (interactive)
  (message (number-to-string (pdf-view-current-page))))

;; Highlight uncommitted changes (using diff-hl)

;; (use-package diff-hl
;;   :disabled)
;; :config (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
;; (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))

;; (use-package general
;;   :config (general-evil-setup t)
;;   (general-create-definer mediocre/leader-key-def
;;     :keymaps '(normal insert visual emacs)
;;     :prefix "SPC"))

;; Bindings for jumping
(map! :map evil-motion-state-map :m :desc "avy-goto-line" "gsl" 'avy-goto-line)
(map! :map evil-visual-state-map :m :desc "avy-goto-line" "gsl" 'avy-goto-line)
(map! :map evil-motion-state-map :m :desc "avy-goto-char-timer" "g SPC" 'avy-goto-char-timer)
(map! :map evil-visual-state-map :m :desc "avy-goto-char-timer" "g SPC" 'avy-goto-char-timer)
(map! :after evil :map evil-normal-state-map "gw" nil)
(map! :after evil :map evil-visual-state-map "gw" nil)
(map! :map evil-motion-state-map :m :desc "avy-goto-word-0" "gw" 'avy-goto-word-0)
(map! :map evil-visual-state-map :m :desc "avy-goto-word-0" "gw" 'avy-goto-word-0)

;;; Auto-saving changed file
(use-package super-save
  :defer 1
  :diminish super-save-mode
  :config
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

;;; Minor Mode to override keybindings
;; (defvar my-keys-minor-mode-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-j") 'counsel-switch-buffer)
;;     map)
;;   "my-keys-minor-mode keymap.")

;; (define-minor-mode my-keys-minor-mode
;;   "A minor mode so that my key settings override annoying major modes."
;;   :init-value t
;;   :lighter " my-keys")

;; (my-keys-minor-mode 1)

;; (defun my-minibuffer-setup-hook ()
;;   (my-keys-minor-mode 0))

;; (add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

;; Define yank-and-comment operator
(evil-define-operator evil-yank-and-comment (beg end type register yank-handler)
  (cond
   ((and (fboundp 'cua--global-mark-active)
	 (fboundp 'cua-copy-region-to-global-mark)
	 (cua--global-mark-active))
    (cua-copy-region-to-global-mark beg end))
   ((eq type 'block)
    (progn (evil-yank-rectangle beg end) (comment-or-uncomment-region beg end)))
   ((memq type '(line screen-line))
    (progn (evil-yank-lines beg end) (comment-or-uncomment-region beg end)))
   (t
    (progn (evil-yank-characters beg end) (comment-or-uncomment-region beg end)))))

;; Yank-and-comment on gC
(map! :after evil :map evil-normal-state-map "gC" nil)
(map! :after evil :map evil-visual-state-map "gC" nil)
(map! :map evil-motion-state-map :m :desc "yank-and-comment" "gC" 'evil-yank-and-comment)
(map! :map evil-visual-state-map :m :desc "yank-and-comment" "gC" 'evil-yank-and-comment)


;; Additional documentatation
(map! :leader :m
      "cm" 'man
      "cM" 'man-follow
      "c," 'rustdoc-search)


;; Bindings for changing windows
(map! :leader :g :desc "window-left" "<left>" 'evil-window-left)
(map! :leader :g :desc "window-down" "<down>" 'evil-window-down)
(map! :leader :g :desc "window-up" "<up>" 'evil-window-up)
(map! :leader :g :desc "window-right" "<right>" 'evil-window-right)

;; Resizing windows
(map! :g :desc "enlarge-left" "<C-left>" 'enlarge-window-horizontally)
(map! :g :desc "shrink-down" "<C-down>" 'shrink-window)
(map! :g :desc "enlarge-top" "<C-up>" 'enlarge-window)
(map! :g :desc "shring-right" "<C-right>" 'shrink-window-horizontally)


;; Projectile folders
(use-package projectile
  :init (projectile-mode +1)
  :config
  (setq projectile-project-search-path '("~/scripts/" "~/code/projects/" "~/code/")))


;; Reverse mode
(use-package! reverse-im
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
  ;; (ispell-local-dictionary "ru_RU")
  (ispell-local-dictionary-alist
   '(("russian"
      "[АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
      "[^АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯабвгдеёжзийклмнопрстуфхцчшщьыъэюяіїєґ’A-Za-z]"
      "[-']"  nil ("-d" "uk_UA,ru_RU,en_US") nil utf-8)))
  ;; (ispell-program-name "aspell")
  (ispell-program-name "hunspell")
  (ispell-dictionary "english")
  ;; (ispell-dictionary "russian")
  ;; (ispell-really-aspell t)
  ;; (ispell-really-hunspell nil)
  (ispell-really-aspell nil)
  (ispell-really-hunspell t)
  (ispell-encoding8-command t)
  (ispell-silently-savep t))

(use-package flyspell
  :defer t
  :config
  (map! :i "C-i" nil)
  (map! :i "C-i" #'flyspell-auto-correct-word)
  :custom
  (flyspell-delay 1)
  )

;; Emacs Lisp
;; (use-package lisp
;;   :hook (after-save . check-parens))

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode))

(use-package suggest
  :defer t)

(use-package ipretty
  :defer t
  :config (ipretty-mode 1))

(use-package google-translate
  :general
  ('normal
   "z t" #'google-translate-smooth-translate
   "z T" #'mediocre/google-translate-at-point)
  :commands (google-translate-smooth-translate)
  :custom
  (google-translate-backend-method 'curl)
  :config
  (defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
  (defun mediocre/google-translate-at-point (arg)
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
							  (russian-computer . ("ru")))))
(require 'google-translate)
(defun google-translate--search-tkk () "Search TKK." (list 430675 2721866130))
(setq google-translate-backend-method 'curl)

;; (require 'elisp-format)
;; (add-hook 'emacs-lisp-mode-hook (lambda ()
;;                                   (add-hook 'before-save-hook (lambda ()
;;                                                                 (call-interactively
;;                                                                  #'elisp-format-buffer)))))


;; Format on save
(add-hook 'before-save-hook (lambda ()
			      (call-interactively #'format-all-buffer)))

;; Emmet setup
(add-hook 'sgml-mode-hook #'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook #'emmet-mode)  ;; enable Emmet's css abbreviation.

;; Org setup
(use-package org
  :config
  (setq org-startup-folded t)
  (setq org-directory "~/org")
  (setq org-agenda-files
	'("~/org/learning.org"
	  "~/org/food.org"
	  "~/org/university.org"
	  "~/org/tasks.org"
	  "~/org/people.org"
	  "~/org/birthdays.org"
	  "~/org/habits.org"
	  "~/org/books.org"
	  "~/org/bookmarks.org"
	  "~/org/ideas.org"
	  "~/org/life.org"
	  ))

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-into-drawer t)
  (setq org-log-done 'time)
  (setq org-hide-emphasis-markers t)

  (setq org-file-apps '(("\\.pdf\\'" . emacs)))

  (setq org-todo-keywords
	'((sequence
	   "INPROGRESS(p)"
	   "TODO(t)"
	   "NEXT(n)"
	   "READY(r)"
	   "REVIEW(v)"
	   "WAIT(w@/!)"
	   "SOMEDAY(.)" "|" "DONE(x!)" "CANC(c)")
	  (sequence "LEARN(l)" "TRY" "STARTED(s)" "IMPL(i)" "|" "COMPLETE(x)")
	  (sequence "TOBUY(b)" "|" "DONE(x)"))
	org-todo-keyword-faces '(("STARTED" :foreground "#0098dd" :weight normal :underline t)
				 ("TODO" :foreground "#7c7c75" :weight normal :underline t)
				 ("NEXT" :foreground "#ff5733" :weight normal :underline t)
				 ("REVIEW" :foreground "#e733ff" :weight normal :underline t)
				 ("SOMEDAY" :foreground "#3733ff" :weight normal :underline t)
				 ("READY" :foreground "#33ffd2" :weight normal :underline t)
				 ("INPROGRESS" :foreground "#ff5733" :weight normal :underline t)
				 ("WAIT" :foreground "#9f7efe" :weight normal :underline t)
				 ("DONE" :foreground "#50a14f" :weight normal :underline t)
				 ("COMPLETE" :foreground "#50a14f" :weight normal :underline t)
				 ("CANC" :foreground "#ff6480" :weight normal :underline t)
				 ("IMPL" :foreground "#ff3733" :weight normal :underline t)
				 ("TOBUY" :foreground "#ff3395" :weight normal :underline t)
				 )
	)

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  ;; Priorities
  (use-package! org-fancy-priorities
    :hook (org-mode . org-fancy-priorities-mode)
    :config
    (setq org-fancy-priorities-list '("🗲" ,"🡩", "🡫", "☕")))

  (use-package org-bullets
    :hook (org-mode . org-bullets-mode))

  (setq org-refile-targets
	'(("archive.org" :maxlevel . 1)
	  ("bookmarks.org" :maxlevel . 2)
	  ("learning.org" :maxlevel . 2)
	  ("tasks.org" :maxlevel . 1)))

  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
	'((:startgroup)
	  ;; Put mutually exclusive tags here
	  (:endgroup)
	  ("@home" . ?H)
	  ("@work" . ?W)
	  ("agenda" . ?a)
	  ("task" . ?a)
	  ("buy" . ?f)
	  ("watch" . ?w)
	  ("university" . ?w)
	  ("listen" . ?L)
	  ("practice" . ?p)
	  ("read" . ?r)
	  ("book" . ?b)
	  ("note" . ?n)
	  ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
	'(
	  ("b" "Low-effort books"
	   ((tags-todo "book-practice/!+INPROGRESS|+NEXT"
		       ((org-agenda-overriding-header "Books without Practice")))))
	  ("B" "Books"
	   ((tags-todo "book+practice/!+INPROGRESS|+NEXT"
		       ((org-agenda-overriding-header "Books with Practice")))))

	  ("h" "Habits" tags-todo "STYLE=\"habit\""
	   ((org-agenda-overriding-header "Habits")
	    (org-agenda-sorting-strategy
	     '(todo-state-down effort-up category-keep))))

	  ;; ("e" tags-todo "task+Effort<6&+Effort>0"
	  ;;  ((org-agenda-overriding-header "Low Effort Tasks")
	  ;;   ;; (org-agenda-max-todos 20)
	  ;;   (org-agenda-files org-agenda-files)))

	  ;; ("E" tags-todo "task+Effort>5"
	  ;;  ((org-agenda-overriding-header "Tasks")
	  ;;   ;; (org-agenda-max-todos 20)
	  ;;   (org-agenda-files org-agenda-files)))

	  ("E" tags-todo "task"
	   ((org-agenda-overriding-header "Tasks")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("p" tags-todo "-practice/!+LEARN|+STARTED"
	   ((org-agenda-overriding-header "Things to learn without practice")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("P" tags-todo "+practice/!+LEARN|STARTED"
	   ((org-agenda-overriding-header "Things to learn on practice")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("l" tags-todo "+LEARN+listen"
	   ((org-agenda-overriding-header "Things to listen")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("w" tags-todo "+watch-practice/!+LEARN|+STARTED"
	   ((org-agenda-overriding-header "Things to watch without practice")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("W" tags-todo "+watch+practice+watch/!+LEARN|STARTED"
	   ((org-agenda-overriding-header "Things to watch and practice")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("r" tags-todo "+read-practice/!+LEARN|+STARTED"
	   ((org-agenda-overriding-header "Things to read without practice")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("R" tags-todo "+read+practice/!+LEARN|STARTED"
	   ((org-agenda-overriding-header "Things to read and practice")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("u" tags-todo "university"
	   ((org-agenda-overriding-header "Things for university")
	    ;; (org-agenda-max-todos 20)
	    (org-agenda-files org-agenda-files)))

	  ("f" "To buy"
	   ((tags-todo "+buy"
		       ((org-agenda-overriding-header "Things to buy")))))


	  ;; ("w" "Workflow Status"
	  ;;  ((todo "WAIT"
	  ;;         ((org-agenda-overriding-header "Waiting on External")
	  ;;          (org-agenda-files org-agenda-files)))
	  ;;   (todo "REVIEW"
	  ;;         ((org-agenda-overriding-header "In Review")
	  ;;          (org-agenda-files org-agenda-files)))
	  ;;   (todo "SOMEDAY"
	  ;;         ((org-agenda-overriding-header "In Planning")
	  ;;          (org-agenda-todo-list-sublevels nil)
	  ;;          (org-agenda-files org-agenda-files)))
	  ;;   (todo "READY"
	  ;;         ((org-agenda-overriding-header "Ready for Work")
	  ;;          (org-agenda-files org-agenda-files)))
	  ;;   (todo "STARTED"
	  ;;         ((org-agenda-overriding-header "Active Projects")
	  ;;          (org-agenda-files org-agenda-files)))
	  ;;   (todo "COMPLETE"
	  ;;         ((org-agenda-overriding-header "Completed Projects")
	  ;;          (org-agenda-files org-agenda-files)))
	  ;;   (todo "CANC"
	  ;;         ((org-agenda-overriding-header "Cancelled Projects")
	  ;;          (org-agenda-files org-agenda-files)))))))
	  ))

  (setq org-capture-templates
	`(("t" "Tasks")
	  ("tt" "Task" entry
	   (file+olp "~/org/tasks.org")
	   "* TODO %t %? :task:\n")
	  ("tb" "Bookmark" entry
	   (file+olp "~/org/bookmarks.org")
	   "* [[%?][]] \n")
	  ("tl" "Learn" entry
	   (file+olp "~/org/learning.org")
	   "\n* LEARN [[%?][]] \n")
	  ("tu" "University" entry
	   (file+olp+datetree "~/org/university.org")
	   "* TODO DEADLINE: %t %? :university:\n")
	  ("ti" "Ideas" entry
	   (file+olp+datetree "~/org/ideas.org")
	   "* %T %? :idea:\n")
	  ("tf" "Food" entry
	   (file+olp+datetree "~/org/food.org")
	   "* TODO %T %? :buy:\n"))

	;; ("m" "Metrics Capture")
	;; ("mw" "Weight" table-line (file+headline "~/Projects/Code/emacs-from-scratch/OrgFiles/Metrics.org" "Weight")
	;;  "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))
	)

  (defun mediocre/org-babel-tangle-dont-ask ()
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle)))

  (add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'mediocre/org-babel-tangle-dont-ask
						'run-at-end 'only-in-org-mode))))

(after! org
  (map! :map org-mode-map
	:n "M-j" 'org-metadown
	:n "M-k" 'org-metaup
	:n "C-j" 'org-next-visible-heading
	:n "C-k" 'org-previous-visible-heading)

  (map! :leader :m :map org-mode-map "mS" 'org-insert-structure-template)


  (defun doom/find-file-in-org ()
    "Search for a file in `org'."
    (interactive)
    (doom-project-find-file "~/org"))

  (map! :leader
	:desc "Browse org files" "fo" #'doom/find-file-in-org)
  ;; :desc "Bookmarks" "b"  (lambda () (interactive) (find-file "~/org/bookmarks.org"))
  ;; :desc "Anime" "a"  (lambda () (interactive) (find-file "~/org/anime.org"))
  ;; :desc "Books" "B"  (lambda () (interactive) (find-file "~/org/books.org"))
  ;; :desc "Ideas" "i"  (lambda () (interactive) (find-file "~/org/ideas.org"))
  ;; :desc "Learning" "l"  (lambda () (interactive) (find-file "~/org/learning.org"))
  ;; :desc "Tasks" "t"  (lambda () (interactive) (find-file "~/org/tasks.org"))
  ;; :desc "Habits" "h"  (lambda () (interactive) (find-file "~/org/habits.org"))
  ;; :desc "University" "u"  (lambda () (interactive) (find-file "~/org/university.org")))

  (map! :leader :desc "org-copy" "mrk" #'org-copy )

  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
  (add-to-list 'org-structure-template-alist '("rs" . "src rust"))
  (add-to-list 'org-structure-template-alist '("py" . "src python"))
  (add-to-list 'org-structure-template-alist '("json" . "src json")))

;; (add-hook 'org-mode-hook (lambda () (set-face-attribute 'fixed-pitch nil :font "Hack-9")))

(setq org-journal-date-prefix "#+TITLE: "
      org-journal-time-prefix "*"
      org-journal-date-format "%a, %Y-%m-%d"
      org-journal-file-format "%Y-%m-%d.org")

;; Confirm kill proccess
(use-package files
  :defer t
  :config (setq confirm-kill-processes nil))

;; Treat underscore and hyphen as part of the word
(add-hook 'after-change-major-mode-hook (lambda ()
					  (modify-syntax-entry ?_ "w")))
(add-hook 'after-change-major-mode-hook (lambda ()
					  (modify-syntax-entry ?- "w")))

;; Paste menu
(map! "M-v" #'counsel-yank-pop)

;; Dashboard image
(add-hook! '(+doom-dashboard-mode-hook)
  (setq fancy-splash-image "~/pix/doom/stallman.png"))

;; Doom modeline
(setq +modeline-height 15)

;; Clock in modeline
(display-time-mode 1)

;; Xclip mode everywhere
(define-globalized-minor-mode my-global-xclip-mode xclip-mode
  (lambda ()
    (xclip-mode 1)))
(my-global-xclip-mode 1)

;; Set specific browser to open links
;; (setq browse-url-browser-function 'browse-url-firefox)

;; Move by visual lines
;; (define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
;; (define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
;; (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
;; (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)

;; Use visual line motions even outside of visual-line-mode buffers
;; (evil-global-set-key 'motion "j" 'evil-next-visual-line)
;; (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

;; Multiedit
;; (require 'evil-multiedit)

;; ;; Highlights all matches of the selection in the buffer.
;; (define-key evil-visual-state-map "R" 'evil-multiedit-match-all)
;; ;; Match the word under cursor (i.e. make it an edit region). Consecutive presses will
;; ;; incrementally add the next unmatched match.
;; (define-key evil-normal-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
;; ;; Match selected region.
;; (define-key evil-visual-state-map (kbd "M-d") 'evil-multiedit-match-and-next)
;; ;; Insert marker at point
;; (define-key evil-insert-state-map (kbd "M-d") 'evil-multiedit-toggle-marker-here)

;; ;; Same as M-d but in reverse.
;; (define-key evil-normal-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
;; (define-key evil-visual-state-map (kbd "M-D") 'evil-multiedit-match-and-prev)
;; ;; OPTIONAL: To grab symbols rather than words, use ;; `evil-multiedit-match-symbol-and-next` (or prev).

;; ;; Restore the last group of multiedit regions.
;; (define-key evil-visual-state-map (kbd "C-M-D") 'evil-multiedit-restore)

;; ;; RET will toggle the region under the cursor
;; (define-key evil-multiedit-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)

;; ;; ...and in visual mode, RET will disable all fields outside the selected region
;; (define-key evil-motion-state-map (kbd "RET") 'evil-multiedit-toggle-or-restrict-region)

;; ;; For moving between edit regions
;; (define-key evil-multiedit-state-map (kbd "C-n") 'evil-multiedit-next)
;; (define-key evil-multiedit-state-map (kbd "C-p") 'evil-multiedit-prev)
;; (define-key evil-multiedit-insert-state-map (kbd "C-n") 'evil-multiedit-next)
;; (define-key evil-multiedit-insert-state-map (kbd "C-p") 'evil-multiedit-prev)

;; ;; Ex command that allows you to invoke evil-multiedit with a regular expression, e.g.
;; (evil-ex-define-cmd
;;  "ie[dit]"
;;  'evil-multiedit-ex-match)


;; LaTeX
(latex-preview-pane-enable)

;; Force splits to open on the right
(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)

;; TAB
;; Make Tab always indent
(setq tab-always-indent 'complete)

(use-package company
  ;; :hook
  ;; (prog-mode . (lambda () (
  ;; (setq company-backends nil)
  ;; (setq company-backends '(company-files company-capf company-dabbrev-code)))))
  ;; (org-mode . (lambda () (
  ;; (setq company-backends nil)
  ;; (setq company-backends '(company-files company-capf company-dabbrev-code)))))
  ;; :init
  ;; (setq company-backends '(company-files company-capf company-dabbrev-code))
  :config
  (global-company-mode 1)
  ;; (map! :niv "TAB" 'company-indent-or-complete-common)
  )
(set-company-backend! 'prog-mode-hook '(company-files company-capf company-dabbrev-code))
(set-company-backend! 'org-mode-hook '(company-files company-capf company-dabbrev-code))

;; Tab code and path autocompletion
;; (after! evil
;;   ;; (map! :i "TAB" nil)
;;   (map! :niv "TAB" 'company-indent-or-complete-common)
;;   )

;;; Auto-reverting changed files
(global-auto-revert-mode 1)

;;; Dired
(use-package dired
  :config
  (map! :leader
	:prefix ("d" . "dired")
	:desc "Open dired here" "h" 'dired-jump
	:desc "Open downloads" "t" (lambda () (interactive) (dired "~/dwnlds"))
	:desc "Open images" "i" (lambda () (interactive) (dired "~/pix"))
	:desc "Open images" "d" (lambda () (interactive) (dired "~/dox"))
	:desc "Open code" "c" (lambda () (interactive) (dired "~/code"))
	:desc "Open music" "m" (lambda () (interactive) (dired "~/musx"))
	:desc "Open progs" "p" (lambda () (interactive) (dired "~/progs"))
	:desc "Open dotfiles" "D" (lambda () (interactive) (dired "~/.config"))))

(map! :leader
      :prefix ("f." . "dotfiles")
      :desc "Newsboat" "n"  (lambda () (interactive) (find-file "~/.newsboat/urls"))
      :desc "AwesomeWM" "a"  (lambda () (interactive) (find-file "~/.config/awesome/rc.lua"))
      :desc "Vim" "v"  (lambda () (interactive) (find-file "~/.vimrc"))
      :desc "Bash" "b"  (lambda () (interactive) (find-file "~/.bashrc"))
      :desc "Zsh" "z"  (lambda () (interactive) (find-file "~/.zshrc")))

;;; Opeining Files Externally
;; (use-package openwith
;;   :config
;;   (setq openwith-associations
;;         (list
;;          (list (openwith-make-extension-regexp
;;                 '("mpg" "mpeg" "mp3" "mp4"
;;                   "avi" "wmv" "wav" "mov" "flv"
;;                   "ogm" "ogg" "mkv" "opus"))
;;                "mpv"
;;                '(file))
;;          (list (openwith-make-extension-regexp
;;                 '("xbm" "pbm" "pgm" "ppm" "pnm"
;;                   "png" "gif" "bmp" "tif" "jpeg")) ;; Removed jpg because Telega was
;;                ;; causing feh to be opened...
;;                "feh"
;;                '(file))
;;          (list (openwith-make-extension-regexp
;;                 '("pdf"))
;;                "zathura"
;;                '(file))))
;;   (openwith-mode -1))

(use-package ranger
  :config
  (setq
   ranger-cleanup-on-disable t
   ranger-excluded-extensions '("mkv" "iso" "mp4" "opus")
   ranger-dont-show-binary t
   ranger-show-hidden t))

(add-hook 'ranger-mode-hook (lambda () (diff-hl-dired-mode -1)))
(add-hook 'ranger-mode-load-hook (lambda () (diff-hl-dired-mode -1)))
(add-hook 'dired-mode-hook (lambda () (diff-hl-dired-mode -1)))
(add-hook 'deer (lambda () (diff-hl-dired-mode -1)))

(add-hook 'ranger-mode-hook (lambda () (diff-hl-margin-mode -1)))
(add-hook 'ranger-mode-load-hook (lambda () (diff-hl-margin-mode -1)))
(add-hook 'dired-mode-hook (lambda () (diff-hl-margin-mode -1)))
(add-hook 'deer (lambda () (diff-hl-margin-mode -1)))


;; Rainbow in programming mode
(use-package rainbow-mode
  :hook '(prog-mode help-mode)
  :config
  (rainbow-mode 1)
  )

;;; TRAMP
(use-package tramp
  :config
  ;; Set default connection mode to SSH
  (setq tramp-default-method "ssh")
  ;; Emacs as an external editor
  (defun mediocre/show-server-edit-buffer (buffer)
    ;; TODO: Set a transient keymap to close with 'C-c C-c'
    (split-window-vertically -15)
    (other-window 1)
    (set-buffer buffer))
  (setq server-window #'mediocre/show-server-edit-buffer))


;;; Debud Adapter
(use-package dap-mode
  :custom
  (lsp-enable-dap-auto-configure nil)
  :config
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-node)
  (dap-node-setup))

;;;; Aplications

;;; Telega
(use-package telega
  :commands telega
  :config
  (setq
   ;; telega-user-use-avatars nil
   telega-use-tracking-for '(any pin unread)
   telega-chat-use-markdown-formatting t
   telega-emoji-use-images t
   telega-completing-read-function #'ivy-completing-read
   telega-msg-rainbow-title nil
   telega-chat-fill-column 135
   telega-root-fill-column 145)
  (set-evil-initial-state! '(telega-root-mode telega-chat-mode) 'emacs)
  :hook (
	 (telega-load . (lambda ()
			  (define-key global-map (kbd "C-c t") telega-prefix-map)
			  (telega-notifications-mode)
			  (telega-mode-line-mode)))))

(map! :leader
      "ot" nil
      "oT" nil
      :desc "Telegram" "ot" 'telega)

(map! :map telega-root-mode-map
      "j" 'next-line
      "k" 'previous-line)
(map! :map (telega-root-mode-map telega-chat-mode-map)
      "C-j" 'next-line
      "C-k" 'previous-line)

;; (use-package vterm
;;   :config
;;   (map! :leader
;; 	:desc "Toggle vterm popup" "ov" '+vterm/toggle
;; 	:desc "Toggle vterm here" "oV" '+vterm/here)
;;   )

;;; ERC
(defun mediocre/on-erc-track-list-changed ()
  (dolist (buffer erc-modified-channels-alist)
    (tracking-add-buffer (car buffer))))

(use-package erc-hl-nicks
  :after erc)

(use-package erc
  :commands erc
  :hook (erc-track-list-changed . mediocre/on-erc-track-list-changed)
  :config
  (setq
   erc-nick "mediocrity"
   erc-user-full-name "Druk Oleksandr"
   erc-prompt-for-nickserv-password nil
   erc-auto-query 'bury
   erc-join-buffer 'bury
   erc-interpret-mirc-color t
   erc-rename-buffers t
   erc-lurker-hide-list '("JOIN" "PART" "QUIT")
   erc-track-exclude-types '("JOIN" "NICK" "QUIT" "MODE")
   erc-track-enable-keybindings nil
   erc-track-visibility nil ; Only use the selected frame for visibility
   erc-fill-column 80
   erc-fill-function 'erc-fill-static
   erc-fill-static-center 20
   erc-quit-reason (lambda (s) (or s "Fading out..."))
   erc-modules
   '(autoaway autojoin button completion fill irccontrols keep-place
	      list match menu move-to-prompt netsplit networks noncommands
	      readonly ring stamp track hl-nicks))

  (add-hook 'erc-join-hook 'bitlbee-identify)
  (defun bitlbee-identify ()
    "If we're on the bitlbee server, send the identify command to the &bitlbee channel."
    (when (and (string= "127.0.0.1" erc-session-server)
	       (string= "&bitlbee" (buffer-name)))
      (erc-message "PRIVMSG" (format "%s identify %s"
				     (erc-default-target)
				     (password-store-get "IRC/Bitlbee"))))))

(defun mediocre/connect-irc ()
  (interactive)
  ;; (erc-tls
  ;;  :server "chat.freenode.net" :port 7000
  ;;  :nick "daviwil" :password (password-store-get "IRC/Freenode")))
  (erc
   :server "127.0.0.1" :port 6667
   :nick "mediocrity"))

(map! :leader :desc "ERC" "oe" 'erc)

;;; Elfeed
;;; TODO add my rss
(use-package elfeed
  :commands elfeed
  :config
  (setq elfeed-feeds
	'(
	  ;; Tech
	  ("https://nitter.net/ebanoe_it/rss" ebanoe it)
	  ("https://habr.com/ru/rss/all/all/?fl=ru" habr it)
	  ("https://os.phil-opp.com/rss.xml" rust)
	  ("https://this-week-in-rust.org/rss.xml" rust)
	  ("https://dou.ua/feed/" dou it)
	  ("https://protesilaos.com/codelog.xml" shprot emacs)
	  ("https://sachachua.com/blog/category/emacs/feed" emacs)
	  ("https://weekly.nixos.org/feeds/all.rss.xml" nix)
	  ("https://devpew.com/index.xml" johenews)
	  ;; Reddit
	  ("https://www.reddit.com/r/osdev/new.rss" osdev)
	  ("https://www.reddit.com/r/bash/new.rss" bash)
	  ("https://www.reddit.com/r/DoomEmacs/new.rss" emacs doom)
	  ("https://www.reddit.com/r/emacs/new.rss" emacs )
	  ("https://www.reddit.com/r/commandline/new.rss" cmd)
	  ("https://www.reddit.com/r/programming/new.rss" programming)
	  ("https://www.reddit.com/r/awesomewm/new.rss" awesomewm)
	  ;; Podcasts
	  ("https://rustacean-station.org/podcast.rss" rust podcast)
	  ("http://feeds.rucast.net/radio-t" radiot podcast)
	  ;; Youtubetech
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA" ytt luke)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCVls1GmFKf6WlTraIb_IaJg" ytt dt)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC9MK8SybZcrHR3CUV4NMy2g" ytt didgitalize)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC7YOGHUfC1Tb6E4pudI9STA" ytt mental-outlaw)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCsnGwSIHyoYN0kiINAGUKxg" ytt wolfgang)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCld68syR8Wi-GY_n4CaoJGA" ytt brodie)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCBNlINWfd08qgDkUTaUY4_w" ytt extremecode)
	  ;; Youtubefun
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCLKB9g1374gcxezJINOLtag" ytf raiz)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC8M5YVWQan_3Elm-URehz9w" ytf utopia)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC_gKMJFeCf1bKzZr_fICkig" ytf thedrzj)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC7nQ_p09KDD0fI6p34nsr4A" ytf voldemar)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2Ru64PHqW4FxoP0xhQRvJg" ytf toples)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCfdgIq01iG92AXBt-NxgPkg" ytf later)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCD-S-2TMDY4fL-R5iDQn-6Q" ytf 2shell)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCr1Pf6rqk3h8b1APvAt42Bw" ytf slidan)
	  ("https://www.youtube.com/feeds/videos.xml?channel_id=UCfn7uyPvr5IY5pux8oyIa4Q" ytf kel)))
  :hook ((elfeed-search . (lambda () (elfeed-update)))))
(add-hook 'elfeed-search-mode-hook #'elfeed-update)
(map! :leader :desc "Elfeed" "on" 'elfeed)

;;; EMMS
;; TODO setup my own
(use-package emms
  :commands emms
  :config
  (require 'emms-setup)
  (emms-standard)
  (emms-default-players)
  (emms-mode-line-disable)
  (setq emms-source-file-default-directory "~/musx/"))

;; TODO change
(map! :leader
      :prefix ("a" . "audio")
      :desc "Play music" "m" 'emms
      :desc "Play/pause music" "p" 'emms-pause
      :desc "Describe song" "d" 'emms-show
      :desc "Play file" "f" 'emms-play-file
      :desc "Play next" "," 'emms-previous
      :desc "Play next" "." 'emms-next)

;;; Network
(use-package net-utils
  ;; :ensure-system-package traceroute
  :bind
  (:map mode-specific-map
   :prefix-map net-utils-prefix-map
   :prefix "n"
   ("p" . ping)
   ("i" . ifconfig)
   ("w" . iwconfig)
   ("n" . netstat)
   ("p" . ping)
   ("a" . arp)
   ("r" . route)
   ("h" . nslookup-host)
   ("d" . dig)
   ("s" . smbclient)
   ("t" . traceroute)))

;;; PDf Support

;;; Prog Mode ligatures
;; TODO review
(use-package prog-mode
  :ensure nil
  :hook ( (prog-mode . prettify-symbols-mode)
	  (lisp-mode . prettify-symbols-lisp)
	  (c-mode . prettify-symbols-c)
	  (c++-mode . prettify-symbols-c++)
	  ((js-mode js2-mode) . prettify-symbols-js)
	  (prog-mode . (lambda ()
			 (setq-local scroll-margin 3))))
  :preface
  (defun prettify-symbols-prog ()
    (push '("<=" . ?≤) prettify-symbols-alist)
    (push '(">=" . ?≥) prettify-symbols-alist))
  (defun prettify-symbols-lisp ()
    (push '("/=" . ?≠) prettify-symbols-alist)
    (push '("sqrt" . ?√) prettify-symbols-alist))
  (defun prettify-symbols-c ()
    (push '("<=" . ?≤) prettify-symbols-alist)
    (push '("->" . ?🠆) prettify-symbols-alist)
    (push '(">=" . ?≥) prettify-symbols-alist)
    (push '("!=" . ?≠) prettify-symbols-alist)
    (push '(">>" . ?») prettify-symbols-alist)
    (push '("<<" . ?«) prettify-symbols-alist))
  (defun prettify-symbols-c++ ()
    (push '("<=" . ?≤) prettify-symbols-alist)
    (push '(">=" . ?≥) prettify-symbols-alist)
    (push '("!=" . ?≠) prettify-symbols-alist)
    (push '(">>" . ?») prettify-symbols-alist)
    (push '("<<" . ?«) prettify-symbols-alist)
    (push '("->" . ?🠆) prettify-symbols-alist))
  (defun prettify-symbols-js ()
    (push '("function" . ?λ) prettify-symbols-alist)
    (push '("=>" . ?⇒) prettify-symbols-alist)))

(defun x11-yank-image-at-point-as-image ()
  "Yank the image at point to the X11 clipboard as image/png."
  (interactive)
  (let ((image (get-text-property (point) 'display)))
    (if (eq (car image) 'image)
	(let ((data (plist-get (cdr image) ':data))
	      (file (plist-get (cdr image) ':file)))
	  (cond (data
		 (with-temp-buffer
		   (insert data)
		   (call-shell-region
		    (point-min) (point-max)
		    "xclip -i -selection clipboard -t image/png")))
		(file
		 (if (file-exists-p file)
		     (start-process
		      "xclip-proc" nil "xclip"
		      "-i" "-selection" "clipboard" "-t" "image/png"
		      "-quiet" (file-truename file))))
		(t
		 (message "The image seems to be malformed."))))
      (message "Point is not at an image."))))

(map! :mode image-mode :map (image-mode-map) "zy" nil)
(map! :mode image-mode :map (image-mode-map) "zy" 'x11-yank-image-at-point-as-image)
