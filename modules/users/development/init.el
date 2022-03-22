;; The default is 800 kilobytes. Measures in bytes.
;; (setq gc-cons-threshold (* 50 1000 1000))

;; Profile emacs startup performance
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "*** Emacs loaded in %s with %d garbage collection."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))

;; Define XDG directories
(setq-default user-emacs-config-directory
              (concat (getenv "HOME") "/.config/emacs"))
(setq-default user-emacs-data-directory
              (concat (getenv "HOME") "/.local/share/emacs"))
(setq-default user-emacs-cache-directory
              (concat (getenv "HOME") "/.cache/emacs"))

;; UTF-8
(set-default-coding-systems 'utf-8)

;; Disable auto-save
(setq auto-save-default nil)

;; Package Management
;; Initialise package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t) ;; Disable startup message

;; UI/UX
;; Set mode defaults
(fringe-mode 0)
(menu-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(window-divider-mode t)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(column-number-mode t)

;; Scrolling
(setq scroll-margin 8)
(setq scroll-step 1)

(setq display-line-numbers-type 'relative) ;; Relative position line numbers
(setq column-number-indicator-zero-based nil) ;; Column numbering
(setq-default fill-column 80) ;; Column boundary position

;; Enable line numbers and column boudary for some modes
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode t)))
  (add-hook mode (lambda () (display-fill-column-indicator-mode t))))

;; Disable line numbers and column boudary for some modes
(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0)))
  (add-hook mode (lambda () (display-fill-column-indicator-mode 0))))

;; Font
(set-face-attribute 'default nil :font "JetBrainsMono Nerd Font" :height 110)

;; Modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

;; NOTE: On first time install all-the-icons should be installed as a via nixpkgs
;; but if that does not populate icons correctly, enter the command
;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (setq doom-gruvbox-dark-variant "hard")
  (load-theme 'doom-gruvbox t))
  ;; (doom-themes-neotree-config)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Keybindings
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ;; Make ESC quit prompts
(global-set-key (kbd "C-M-u") 'universal-argument) ;; Evil has taken my C-u

;; Get help remembering keybinds
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; EVIL
(use-package undo-tree
  :init
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(defun rsh/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  (setq evil-insert-state-cursor '(box "#ebdbb2")
      evil-normal-state-cursor '(box "#ebdbb2")
      evil-visual-state-cursor '(box "#ebdbb2")
      evil-motion-state-cursor '(box "#ebdbb2")
      evil-replace-state-cursor '(box "#ebdbb2")
      evil-operator-state-cursor '(box "#ebdbb2")
      evil-default-state 'normal)
  :config
  (add-hook 'evil-mode-hook  'rsh/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  ;; :init
  ;; (setq evil-collection-company-use-tng nil)
  ;; :custom
  ;; (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
	(remove 'lispy evil-collection-mode-list))
  (evil-collection-init))

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer rsh/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer rsh/ctrl-c-keys
    :prefix "C-c"))

;; Toggles
(rsh/leader-key-def
  "t" '(:ignore t :which-key "toggles")
  "tw" 'whitespace-mode)

;; Ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))
  ;; :after counsel

;; Counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

;; Helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; Notifications
(use-package alert
  :commands alert
  :config
  (setq alert-default-style 'libnotify)) ;; 'notifications - via D-Bus

;; Git
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(rsh/leader-key-def
  "g" '(:ignore t :which-key "git")
  "gs" 'magit-status
  "gd" 'magit-diff-unstaged
  "gc" 'magit-branch-or-checkout
  "gl" '(:ignore t :which-key "log")
  "glb" 'magit-log-current
  "glf" 'magit-log-buffer-file
  "gb" 'magit-branch
  "gp" '(:ignore t :which-key "push")
  "gps" 'magit-push-current
  "gpt" 'magit-push-tag
  "gP" 'magit-pull-branch
  "gf" 'magit-fetch
  "gF" 'magit-fetch-all
  "gm" 'magit-merge
  "gr" 'magit-rebase)

;; Lsp
(use-package lsp-mode
  :commands lsp
  ;;:hook (() . lsp)
  :init
  :config
  (lsp-headerline-breadcrumb-enable nil))

(rsh/leader-key-def
  "l"  '(:ignore t :which-key "lsp")
  "ld" 'xref-find-definitions
  "lr" 'xref-find-references
  "lj" 'lsp-ui-find-next-reference
  "lk" 'lsp-ui-find-prev-reference
  "ls" 'counsel-imenu
  "le" 'lsp-ui-flycheck-list
  "li" 'lsp-ui-sideline-mode
  "la" 'lsp-execute-code-action)

;; Lsp UI
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show))

;; Treemacs
(use-package lsp-treemacs
  :after lsp)

;; Nix
(use-package nix-mode
  :mode "\\.nix\\'"
  :hook (nix-mode . lsp-deferred))

;; Org
(defun rsh/org-font-setup ()
  ;; (set-face-attribute 'org-document-title nil :font "Open Sans" :weight 'bold :height 1.3)
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Open Sans" :weight 'regular :height (cdr face)))

  ;; Maintain the monospace
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  ;; (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))
  ;; Get rid of the background on column views
  ;; (set-face-attribute 'org-column nil :background nil)
  ;; (set-face-attribute 'org-column-title nil :background nil)

(defun rsh/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  ;; (auto-fill-mode 0)
  (visual-line-mode 1))
  ;; (setq evil-auto-indent nil)
  ;; (diminish org-indent-mode))

(use-package org
  :pin org
  :hook (org-mode . rsh/org-mode-setup)
  :config
  (setq org-ellipsis " ")
	;; org-hide-emphasis-markers t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-directory "~/Documents/OrgFiles")
  (setq org-agenda-files '("Tasks.org"
			   "Birthdays.org"
			   "Habits.org"))

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  ;; Agenda task styles
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
	  (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  ;; Archive done tasks from clogging up the view
  (setq org-refile-targets '(("Archive.org" :maxlevel . 1)))
  (advice-add 'org-refile :after 'org-save-all-org-buffers) ;; Save Org buffers after refile

  ;; Custom tags to quickly add to tasks
  (setq org-tag-alist
    '((:startgroup)
       ; Put mutually exclusive tags here
       (:endgroup)
       ("@errand" . ?E)
       ("@home" . ?H)
       ("@work" . ?W)
       ("agenda" . ?a)
       ("planning" . ?p)
       ("publish" . ?P)
       ("batch" . ?b)
       ("note" . ?n)
       ("idea" . ?i)))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))

    ;; Vertical kanban style project workflow
    ("w" "Workflow Status"
     ((todo "WAIT"
            ((org-agenda-overriding-header "Waiting on External")
             (org-agenda-files org-agenda-files)))
      (todo "REVIEW"
            ((org-agenda-overriding-header "In Review")
             (org-agenda-files org-agenda-files)))
      (todo "PLAN"
            ((org-agenda-overriding-header "In Planning")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "BACKLOG"
            ((org-agenda-overriding-header "Project Backlog")
             (org-agenda-todo-list-sublevels nil)
             (org-agenda-files org-agenda-files)))
      (todo "READY"
            ((org-agenda-overriding-header "Ready for Work")
             (org-agenda-files org-agenda-files)))
      (todo "ACTIVE"
            ((org-agenda-overriding-header "Active Projects")
             (org-agenda-files org-agenda-files)))
      (todo "COMPLETED"
            ((org-agenda-overriding-header "Completed Projects")
             (org-agenda-files org-agenda-files)))
      (todo "CANC"
            ((org-agenda-overriding-header "Cancelled Projects")
             (org-agenda-files org-agenda-files)))))))

  ;; Agenda templates to quickly capture thoughts/progress etc.
  (setq org-capture-templates
    '(("t" "Tasks / Projects")
      ("tt" "Task" entry (file+olp "~/Documents/OrgFiles/Tasks.org" "Inbox")
           "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

      ("j" "Journal Entries")
      ("jj" "Journal" entry
           (file+olp+datetree "~/Documents/OrgFiles/Journal.org")
           "\n* %<%I:%M %p> - Journal :journal:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)
      ("jm" "Meeting" entry
           (file+olp+datetree "~/Documents/OrgFiles/Journal.org")
           "* %<%I:%M %p> - %a :meetings:\n\n%?\n\n"
           :clock-in :clock-resume
           :empty-lines 1)

      ("w" "Workflows")
      ("we" "Checking Email" entry (file+olp+datetree "~/Documents/OrgFiles/Journal.org")
           "* Checking Email :email:\n\n%?" :clock-in :clock-resume :empty-lines 1)

      ("m" "Metrics Capture")
      ("mw" "Weight" table-line (file+headline "~/Documents/OrgFiles/Metrics.org" "Weight")
       "| %U | %^{Weight} | %^{Notes} |" :kill-buffer t)))

  (define-key global-map (kbd "C-c j")
    (lambda () (interactive) (org-capture nil "jj")))

  (rsh/org-font-setup))

;; Bullet-points
(use-package org-superstar
  :hook(org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun rsh/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :defer t
  :hook (org-mode . rsh/org-mode-visual-fill))

;; Dashboard
(use-package dashboard
  :init
  :config
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-banner-logo-title "Welcome to Emacs")
  (setq dashboard-startup-banner 'official)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-items '((projects . 5)
			  (bookmarks . 5)
			  (recents . 5)
			  (agenda . 5)))
  (setq dashboard-item-names '(("Agenda for the coming week:" . "Agenda:")))
  (setq dashboard-agenda-sort-strategy '(time-up))
  (setq dashboard-projects-backend 'project-el)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-center-content t)
  (dashboard-setup-startup-hook))
