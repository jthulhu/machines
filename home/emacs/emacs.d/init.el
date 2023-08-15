(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq default-frame-alist '((undecorated . t))
      menu-bar-mode nil
      scroll-bar-mode nil
      tool-bar-mode nil)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t)

(load-theme 'zenburn t)

(defvar wc-modes '(fundamental-mode org-mode)
  "Which major-mode enable wc in the powerline.")

(use-package spaceline
  :config
  (use-package spaceline-config
    :ensure nil
    :config
    (spaceline-toggle-buffer-encoding-off)
    (spaceline-toggle-buffer-encoding-abbrev-off)
    (setq powerline-default-separator 'rounded)
    (spaceline-define-segment line-column
      "The current line and column numbers."
      "%l|%2c")
    (spaceline-define-segment word-count
      "The number of words in the buffer or region if active."
      (if (use-region-p)
          (format "wc[R]:%s" (count-words-region (region-beginning) (region-end)))
        (format "wc:%s" (count-words-region (point-min) (point-max))))
      :when (and active (member major-mode wc-modes))
      :priority 90)
    (spaceline-spacemacs-theme 'word-count)))

(use-package fill-column-indicator
  :hook (prog-mode . fci-mode)
  :custom (fci-rule-column 80))

(use-package dashboard
  :init
  (setq dashboard-items '((recents . 5)
			  (projects . 5))
	dashboard-show-shortcuts nil
	dashboard-center-content nil
	dashboard-banner-logo-title "Welcome to Beansmacs!"
	dashboard-set-init-info t
	; dashboard-startup-banner "~/.emacs.d/banner"
	)
  :config
  (dashboard-setup-startup-hook))

(use-package page-break-lines)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package xkcd
  :custom
  (xkcd-cache-dir "~/.cache/xkcd/" "The directory where the comics are stored.")
  (xkcd-cache-latest "~/.cache/xkcd/latest" "The file where the latest cached comics' number is stored."))

(defun my-find-file (&optional arg)
  (interactive "P")
  (if (not arg)
      (find-file (read-file-name "Find File: "))
    (crux-sudo-edit)))

(defadvice find-file (before make-directory-maybe (filename &optional wildcards) activate)
  "Create parent directory if not exists while visiting file."
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir t)))))

(defun dashboard-focus ()
  (interactive)
  (switch-to-buffer "*dashboard*"))

(defvar always-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c d") #'dashboard-focus)
    (define-key map (kbd "C-M-h") #'windmove-left)
    (define-key map (kbd "C-M-l") #'windmove-right)
    (define-key map (kbd "C-M-j") #'windmove-down)
    (define-key map (kbd "C-M-k") #'windmove-up)
    map)
  "Mode map for the Always Key minor mode.")

(define-minor-mode always-keys-minor-mode
  "A minor mode to ensure basic moving-around key bindings are enforced."
  :init-value t
  :lighter " AK")

(use-package emacs
  :init
  (setq enable-recursive-minibuffers t
        gc-cons-threshold 104857600	  ; 100mb
        read-process-output-max 1048576	  ; 1mb
        backup-by-copying t
        backup-directory-alist '(("." . "~/backups/emacs/"))
        delete-old-versions t
        kept-new-versions 3
        kept-old-versions 2
        version-control t)
  :custom
  (safe-local-variable-values '((eval set-fill-column 117)))
  :bind (("C-x C-f" . my-find-file)
         ("C-c r s h" . shrink-window-horizontally)
         ("C-c r s v" . shrink-window)
         ("C-c r e h" . enlarge-window-horizontally)
         ("C-c r e v" . enlarge-window)
         ("C-c k" . kill-current-buffer)
         ("S-<return>" . electric-newline-and-maybe-indent)
         ("C-z" . nil)
         ("C-x C-z" . nil)))

(define-key key-translation-map (kbd "C-j") (kbd "DEL"))
(define-key key-translation-map (kbd "M-j") (kbd "M-DEL"))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq linum-format 'dynamic)

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive (list (read-file-name "New name: " default-directory (buffer-name) nil (buffer-name))))
  (let ((name (buffer-name))
	(filename (buffer-file-name)))
    (if (not filename)
	(message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
	  (message "A buffer named '%s' already exists!" new-name)
	(progn
	  (rename-file filename new-name 1)
	  (rename-buffer new-name)
	  (set-visited-file-name new-name)
	  (set-buffer-modified-p nil))))))

(defun my/comment-or-uncomment ()
  "Comment or uncomment, based on the region."
  (interactive)
  (if (use-region-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))))
(global-set-key (kbd "C-x C-o") #'my/comment-or-uncomment)

(use-package flycheck
  :hook (rustic-mode tuareg-mode elisp-mode))

(use-package rustic
  :after rust-mode)

(use-package flycheck-rust
  :commands flycheck-rust-setup
  :hook (flycheck-mode . flycheck-rust-setup))

(use-package python
  :when (executable-find "ipython")
  :custom
  (python-shell-interpreter "ipython")
  (python-shell-interpreter-args "--simple-prompt -i")
  (python-shell-prompt-regexp "In \\[[0-9]+\\]: ")
  (python-shell-prompt-output-regexp "Out\\[[0-9]+\\]")
  (python-shell-completion-setup-code "from IPython.core.completerlib import module_completion")
  (python-shell-completion-module-string-code "';'.join(module_completion('''%s'''))\n")
  (python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"))

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))

(use-package ocp-indent
  :init
  (setq byte-compile-warnings '(not cl-functions)))

(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")

(use-package tuareg)

(use-package utop
  :hook (tuareg-mode . utop-minor-mode)
  :config
  (setq utop-edit-command nil))

(use-package merlin
  :hook
  (tuareg-mode . merlin-mode)
  (merlin-mode . company-mode)
  :custom (merlin-command "ocamlmerlin"))

(use-package lsp-haskell)

(use-package racket-mode
  :hook racket-xp-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.rkt\\'" . racket-mode)))

(use-package scheme-complete)

(use-package paredit
  :hook
  ((emacs-lisp-mode
    list-interaction-mode
    ielm-mode
    lisp-mode
    eval-expression-minibuffer-setup
    scheme-mode
    racket-mode
    racket-repl-mode) . paredit-mode))

(use-package web-mode)

(autoload 'bash-completion-dynamic-complete
  "bash completion"
  "BASH completion hook")

(use-package bash-completion
  :init
  (add-hook 'shell-dynamic-complete-functions 'bash-completion-dynamic-complete))

(use-package load-bash-alias
  :config
  (setq load-bash-alias-bashrc-file "~/.bashrc"))

(add-to-list 'load-path "~/.emacs.d/llvm-mode")
(require 'llvm-mode)
(require 'tablegen-mode)

(use-package tex
  :ensure auctex)
(use-package company-auctex)

(setq LaTeX-command "latex -shell-escape")
(add-hook 'latex-mode-hook 'display-line-numbers-mode)

(use-package pandoc-mode
  :commands pandoc-load-default-settings
  :hook markdown-mode
  (pandoc-mode . pandoc-load-default-settings))

(use-package nix-mode
  :after (lsp-mode flycheck)
  :init
  (add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
		    :major-modes '(nix-mode)
		    :server-id 'nix))
  :config
  (define-key nix-mode-map (kbd "C-c n") #'helm-nixos-options))

(use-package direnv
  :commands direnv-update-environment
  :hook (prog-mode . direnv-update-environment)
  :config
  (direnv-mode)
  :custom
  (direnv-always-show-summary nil))

(use-package j-mode
  :hook (j-mode . (lambda () (run-hooks 'prog-mode-hook)))
  :config
  (setq j-console-cmd "jconsole")
  (put 'j-other-face 'face-alias 'font-lock-keyword-face)
  (put 'j-verb-face 'face-alias 'font-lock-keyword-face)
  (put 'j-adverb-face 'face-alias 'font-lock-preprocessor-face)
  (put 'j-conjunction-face 'face-alias 'j-adverb-face))

(use-package prolog)
(use-package ediprolog)

(use-package proof-general)
(use-package company-coq)

(use-package yaml-mode)

(use-package toml-mode)

(use-package json-mode)

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (bind-key [remap completion-at-point] #'company-complete company-mode-map)
  (setq company-show-numbers nil
        company-tooltip-align-annotations t
        company-idle-delay 0
        company-minimum-prefix-length 3))

(use-package projectile
  :hook (rust-mode . projectile-mode))

(setq font-lock-global-modes '(not speedbar-mode))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(use-package ace-window
  :config
  (setq aw-keys '(?q ?s ?d ?f ?g ?h ?j ?k ?l))
  :bind ("M-o" . ace-window))

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(use-package jump-char
  :bind (("M-h" . jump-char-forward)
	 ("M-m" . jump-char-backward))
  :config
  (setq jump-char-forward-key nil
	jump-char-backward-key nil))

(use-package embrace
  :bind (("C-," . embrace-commander))
  :hook
  (org-mode . embrace-org-mode-hook)
  (LaTeX-mode . embrace-LaTeX-mode-hook))

(use-package expand-region
  :bind (("M-'" . er/expand-region)))

(use-package which-key
  :config
  (which-key-mode))

(defun my/text-scale-adjust-latex-previews ()
  "Adjust the size of the latex preview fragments when changing the
buffer's text scale."
  (pcase major-mode
    ('latex-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'category)
               'preview-overlay)
           (my/text-scale--resize-fragment ov))))
    ('org-mode
     (dolist (ov (overlays-in (point-min) (point-max)))
       (if (eq (overlay-get ov 'org-overlay-type)
               'org-latex-overlay)
           (my/text-scale--resize-fragment ov))))))

(defun my/text-scale--resize-fragment (ov)
  (overlay-put
   ov 'display
   (cons 'image
         (plist-put
          (cdr (overlay-get ov 'display))
          :scale (+ 1.0 (* 0.25 (- text-scale-mode-amount 2)))))))

(use-package org
  :hook (text-scale-mode . my/text-scale-adjust-latex-previews)
  :config
  (setq org-agenda-start-on-weekday 1
        org-modules '(ol-bbdb ol-bibtex ol-docview ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m)
        org-agenda-files (list "~/org/head.org" "~/org/school.org")
        org-preview-latex-default-process 'dvisvgm)
  (add-hook 'org-mode-hook (lambda () (setq-local backup-by-copying t)))
  :custom-face
  (org-level-1 ((t (:inherit outline-1 :height 1.25))))
  (org-level-2 ((t (:inherit outline-1 :height 1.2))))
  (org-level-3 ((t (:inherit outline-1 :height 1.15))))
  (org-level-4 ((t (:inherit outline-1 :height 1.1))))
  (org-level-5 ((t (:inherit outline-1 :height 1.05)))))

(use-package org-auto-tangle
  :hook (org-mode . org-auto-tangle-mode)
  :init (setq org-auto-tangle-default t))

(use-package org-fragtog)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/em/roam/")
  (org-roam-completion-everywhere t)
  (org-roam-dailies-directory "log/")
  (org-roam-dailies-capture-templates
   '(("T" "(E)Timestamp" entry "* %<%R>>\n   %?"
      :if-new (file+head "%<%Y-%m-%d>.org.gpg" "#+title: %<%Y-%m-%d>\n"))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point)
	 :map org-roam-dailies-map
	 ("Y" . org-roam-dailies-capture-yesterday)
	 ("T" . org-roam-dailies-capture-tomorrow))
  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config
  (require 'org-roam-dailies)
  (org-roam-setup)
  (org-roam-db-autosync-mode))

(use-package lsp-mode
  :after (direnv)
  :init
  (setq lsp-keymap-prefix "C-c l"
        lsp-log-io nil)
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  (setq lsp-file-watch-ignored
        '("[/\\\\]\\.direnv$"
          "[/\\\\]target$"
          "[/\\\\]\\.git"))
  :hook ((python-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (tuareg-opam-mode . lsp-deferred)
         (nix-mode . lsp-deferred)
         (haskell-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package yasnippet
  :bind (("M-n" . yas-next-field)
	 ("M-p" . yas-prev-field)
	 ("<C-return>" . yas-exit-snippet))
  :config
  (setq yas-verbosity 1
	yas-wrap-around-region t)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "M-<tab>") #'yas-expand)
  (with-eval-after-load 'yasnippet
    (setq yas-snippet-dirs '(yasnippet-snippets-dir)))
  (yas-reload-all)
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package vertico
  :init
  (vertico-mode))

(setq password-cache-expiry nil)

(use-package auth-source
  :ensure nil
  :custom
  (auth-source-save-behavior nil))

(setq save-place-mode t)

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package crux
  :bind (("C-c e" . crux-eval-and-replace)
	 ("C-<backspace>" . crux-kill-line-backwards)
	 ("C-c f" . crux-recentf-find-file)))

(use-package magit
  :bind (("C-x g" . magit-status)
	 ("C-x M-g" . magit-dispatch)
	 ("C-C M-g" . magit-file-dispatch)))

(use-package eshell
  :ensure nil
  :bind (("<f1>" . eshell)))

(use-package unison-mode)

(use-package pass)
(use-package pinentry)

(use-package deadgrep
  :bind ("<f5>" . deadgrep))
