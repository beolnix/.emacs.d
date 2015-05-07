;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Benchmark packages
(add-to-list 'load-path (expand-file-name "benchmark" user-emacs-directory))
(require 'benchmark-init-loaddefs)
(benchmark-init/activate)

;; Set path to dependencies
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))
(setq etc-dir
      (expand-file-name "etc" user-emacs-directory))
(setq var-dir
      (expand-file-name "var" user-emacs-directory))


;; Set up load path
(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path etc-dir)

;; Keep emacs Custom-settings in separate file
;; (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; (load custom-file)

;; Settings for currently logged in user
;; (setq user-settings-dir
;;       (concat user-emacs-directory "users/" user-login-name))
;; (add-to-list 'load-path user-settings-dir)

;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; Load libraries first
(require 'use-package)

;; Setup packages
(require 'setup-package)

;; Set up appearance early
(require 'appearance)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(ace-jump-mode
     ag
     change-inner
     dash
     expand-region
     elfeed
     ; elpy
     flx
     flx-ido
     ;; ido-vertical-mode
     ido-at-point
     ido-ubiquitous
     guide-key
     highlight-escape-sequences
     highlight-parentheses
     ;; elisp-slime-nav
     git-commit-mode
     gitconfig-mode
     gitignore-mode
     git-timemachine
     jump-char
     magit
     move-text
     multiple-cursors
     org
     org-plus-contrib
     paredit
     perspective
     persp-projectile
     projectile
     s
     smartparens
     smart-forward
     smooth-scrolling
     undo-tree
     visual-regexp
     wgrep
     ws-butler
     yasnippet
     )))

(use-package s
  :ensure t)

(use-package dash
  :ensure t)

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))


;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; recentf
(use-package recentf
  :init (progn
          (setq recentf-save-file
                (recentf-expand-file-name (expand-file-name "recentf" var-dir)))
          (recentf-mode 1)
          (setq recentf-max-saved-items 50)
          (add-to-list 'recentf-exclude "COMMIT_EDITMSG")
          (add-to-list 'recentf-exclude "TAGS"))
  )

;; Smooth scrolling
(use-package smooth-scrolling
  :init (setq smooth-scroll-margin 5)
  :ensure t)

;; Unique file names
(use-package uniquify
  :init (setq uniquify-buffer-name-style 'forward))

;; Guide-key
(use-package guide-key
  :diminish guide-key-mode
  :init (progn
          (guide-key-mode t)
          (setq guide-key/guide-key-sequence
                '("C-c" "C-x r" "C-c p" "C-x 4" "C-x v" "C-x 8" "C-x +"))
          (setq guide-key/recursive-key-sequence-flag t)
          (setq guide-key/popup-window-position 'bottom)))

;; Yasnippet
;; (custom snippets from snippets/ directory are automatically loaded)
(use-package yasnippet
  :if (not noninteractive)
  :diminish yas-minor-mode
  :idle (yas-minor-mode)
  :init (hook-into-modes #'(lambda () (yas-minor-mode 1))
                         '(;prog-mode-hook
                           c-mode-common-hook
                           python-mode-hook
                           gud-mode-hook))
  :config (progn
            (yas-reload-all)))

;; Highlight escape sequences
(use-package highlight-escape-sequences
  :config
  (progn (hes-mode)
         (put 'font-lock-regexp-grouping-backslash
              'face-alias 'font-lock-builtin-face)))

;; Visual regexp
(use-package visual-regexp)

;; Setup extensions
(eval-after-load 'ido '(require 'setup-ido))
(eval-after-load 'org '(require 'setup-org))

;; Magit
(use-package magit
  :diminish magit-auto-revert-mode
  :bind ("C-x g" . magit-status)
  :init
  (setf magit-last-seen-setup-instructions "1.4.0")
  :config
  (progn
    (use-package magit-config))
  )

(eval-after-load 'grep '(require 'setup-rgrep))
(eval-after-load 'shell '(require 'setup-shell))

;; Language specific setup files
(eval-after-load 'cc-mode '(require 'setup-c))
(use-package markdown-mode
  :mode ("\\.\\(md\\|markdown\\)\\'" . markdown-mode))
(use-package python
  :mode ("\\<\\(SConscript\\|SConstruct\\)\\>" . python-mode))
(use-package highlight-parentheses
  :diminish highlight-parentheses-mode
  :init (hook-into-modes #'(lambda () (highlight-parentheses-mode 1))
                         '(prog-mode-hook
                           c-mode-common-hook
                           lisp-mode-hook)))
;; manage whitespace for edited lines only
(use-package ws-butler
  :diminish ws-butler-mode
  :init (hook-into-modes #'(lambda () (ws-butler-mode 1))
                         '(prog-mode-hook
                           c-mode-common-hook
                           python-mode-hook
                           gud-mode-hook)))
; (add-hook 'c-mode-common-hook 'ws-butler-mode)

;; auto wrap comments in programming modesa
(add-hook 'prog-mode-hook
          (lambda ()
            (setq fill-column 80)
            (set (make-local-variable 'comment-auto-fill-only-comments) t)
            (auto-fill-mode 1)))


(use-package delsel)
(use-package wgrep)
(use-package revbufs)
(use-package key-bindings)
(use-package ag
  :init (setq ag-reuse-window 't))

;; Projectile
(use-package projectile
  :init
  (progn
    (use-package perspective)
    (use-package persp-projectile
      :init (persp-mode))
    (projectile-global-mode))
    ;; (hook-into-modes #'(lambda () (projectile-mode 1))
    ;;                  '(prog-mode-hook
    ;;                    c-mode-common-hook
    ;;                    python-mode-hook
    ;;                    gud-mode-hook)))
  :config (progn
            (setq projectile-enable-caching t)
            (setq projectile-enable-idle-timer t)
            (setq projectile-mode-line
                  '(:eval (format " Prj[%s]" (projectile-project-name))))
            (setq projectile-remember-window-configs t)
            (setq projectile-file-exists-remote-cache-expire nil)
            (defun rejeep-projectile-completion-fn (prompt choises)
              "Projectile completion function that only shows file name.
              If two files have same name, new completion appears to select between
              them. These include the path relative to the project root."
              (interactive)
              (let* ((stripped-choises
                      (-uniq (--map (file-name-nondirectory (directory-file-name it)) choises)))
                     (choise
                      (ido-completing-read prompt stripped-choises))
                     (matching-files
                      (-filter
                       (lambda (file)
                         (equal (file-name-nondirectory (directory-file-name file)) choise))
                       choises)))
                (if (> (length matching-files) 1)
                    (ido-completing-read prompt matching-files)
                  (car matching-files))))
            (setq projectile-completion-system 'rejeep-projectile-completion-fn)
            ))


;; Go back in history with a touch of a button
(use-package git-timemachine)

;; Fold the active region
(use-package fold-this
  :bind (("C-c C-f" . fold-this-all)
         ("C-c C-F" . fold-this)
         ("C-c M-f" . fold-this-unfold-all)))

;; Undo tree
(use-package undo-tree
  :bind ("C-x u" . undo-tree-visualize)
  :init
  (progn
    (global-undo-tree-mode 1)
    (setq undo-tree-mode-lighter "")
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t))
  :config
  ;; Keep region when undoing in region
  (defadvice undo-tree-undo (around keep-region activate)
    (if (use-region-p)
        (let ((m (set-marker (make-marker) (mark)))
              (p (set-marker (make-marker) (point))))
          ad-do-it
          (goto-char p)
          (set-mark m)
          (set-marker p nil)
          (set-marker m nil))
      ad-do-it))
  :ensure t)

;; Smart M-x
(use-package smex
  :bind (("M-x"     . smex)
         ("M-X"     . smex-major-mode-commands)
         ("C-c M-x" . execute-extended-command))
  :init (smex-initialize)
  :ensure t)

;; Expand region (increases selected region by semantic units)
(use-package expand-region
  :bind ("C-=" . er/expand-region)
  :ensure t)

;; Multiple-cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C-S-c C-e"   . mc/edit-ends-of-lines)
         ("C-S-c C-a"   . mc/edit-beginnings-of-lines)
         ("C-'"         . mc/mark-all-symbols-like-this-in-defun)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)
         ("S-SPC"       . set-rectangular-region-anchor))
  :init
  (setq mc/list-file (expand-file-name ".mc-lists.el"))
  :ensure t)

;; Quickly jump in document with ace-jump-mode
(use-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

;; iy-go-to-char - like f in Vim
(use-package jump-char
  :bind (("M-m" . jump-char-forward)
         ("M-M" . jump-char-backward))
  :ensure t)

;; Browse kill ring
(use-package browse-kill-ring
  :bind ("C-x C-y" . browse-kill-ring)
  :init
  (setq browse-kill-ring-quit-action 'save-and-restore))

(use-package smart-forward
  :bind (("M-<up>"    . smart-up)
         ("M-<down>"  . smart-down)
         ("M-<left>"  . smart-backward)
         ("M-<right>" . smart-forward)))


;; Emacs server
(use-package server)
(unless (server-running-p)
  (server-start))

;; Conclude init by setting up specifics for the current user
;; (when (file-exists-p user-settings-dir)
;;   (mapc 'load (directory-files user-settings-dir nil "^[^#].*el$")))
