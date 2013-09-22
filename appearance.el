(setq visible-bell nil
      ring-bell-function 'ignore
      font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)

; (set-face-background 'region "#464740")

;; Highlight current line
; (global-hl-line-mode 1)

;; Customize background color of lighlighted line
; (set-face-background 'hl-line "#222222")

; Set font height
(set-face-attribute 'default nil :family "Droid Sans Mono" :height 100)

;; use solarized theme
(require 'color-theme-solarized)
(color-theme-solarized-dark)

;; Highlight in yasnippet
;; (set-face-background 'yas/field-highlight-face "#333399")

;; (set-face-foreground 'font-lock-warning-face "#ff6666")

;; ;; Set custom theme path
;; (setq custom-theme-directory (concat user-emacs-directory "themes"))

;; (dolist
;;     (path (directory-files custom-theme-directory t "\\w+"))
;;   (when (file-directory-p path)
;;     (add-to-list 'custom-theme-load-path path)))

;; ;; Default theme
;; (defun use-presentation-theme ()
;;   (interactive)
;;   (disable-theme 'default-black)
;;   (load-theme 'prez)
;;   (when (boundp 'magnars/presentation-font)
;;     (set-face-attribute 'default nil :font magnars/presentation-font)))

;; (defun use-default-theme ()
;;   (interactive)
;;   (disable-theme 'prez)
;;   (load-theme 'default-black)
;;   (when (boundp 'magnars/default-font)
;;     (set-face-attribute 'default nil :font magnars/default-font)))

;; (defun toggle-presentation-mode ()
;;   (interactive)
;;   (if (string= (frame-parameter nil 'font) magnars/default-font)
;;       (use-presentation-theme)
;;     (use-default-theme)))

;; (global-set-key (kbd "C-<f9>") 'toggle-presentation-mode)

;; (use-default-theme)

;; Don't defer screen updates when performing operations
; (setq redisplay-dont-pause t)

;; ;; org-mode colors
;; (setq org-todo-keyword-faces
;;       '(
;;         ("INPR" . (:foreground "yellow" :weight bold))
;;         ("DONE" . (:foreground "green" :weight bold))
;;         ("IMPEDED" . (:foreground "red" :weight bold))
;;         ))

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (blink-cursor-mode -1))

;; ;; Make zooming affect frame instead of buffers
;; (require 'zoom-frm)

;; Unclutter the modeline
(require 'diminish)
(eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
;(eval-after-load "eldoc" '(diminish 'eldoc-mode))
(eval-after-load "paredit" '(diminish 'paredit-mode))
(eval-after-load "tagedit" '(diminish 'tagedit-mode))
;(eval-after-load "elisp-slime-nav" '(diminish 'elisp-slime-nav-mode))
(eval-after-load "smartparens" '(diminish 'smartparens-mode))
(eval-after-load "guide-key" '(diminish 'guide-key-mode))

(defmacro rename-modeline (package-name mode new-name)
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

(provide 'appearance)
