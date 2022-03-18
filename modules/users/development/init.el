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
;; (unless package-archive-contents
;;   (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; UI/UX
;; Disable startup message
(setq inhibit-startup-message t)

;; Clean up UI
(menu-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(scroll-bar-mode -1)

;; Font JetBrains Mono Nerd Font
(set-face-attribute 'default nil :font "JetbrainsMono Nerd Font" :height 110)

;; Numbered columns
(column-number-mode)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

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
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Evil has taken my C-u
(global-set-key (kbd "C-M-u") 'universal-argument)

;; Get help remembering keybinds
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; EVIL
(use-package undo-tree
  :init
  (global-undo-tree-mode 1))

(defun rsh/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  ;; git-rebase-mode erc-mode sauron-mode might have to check whether autoenabled
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

;; Git
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))
