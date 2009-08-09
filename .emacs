
;;
;; appearance
;;
(set-language-environment "Japanese")
(tool-bar-mode nil)
(menu-bar-mode nil)

;;
;; customize built-ins
;; 
(setq make-backup-files nil)
(setq inhibit-startup-screen t)
(iswitchb-mode t)
(global-set-key "\M-g" `goto-line)
(global-set-key "\M-i" `indent-region)
(add-to-list 'load-path (expand-file-name "~/elisp/"))

;; .mm
(setq auto-mode-alist
      (append '(("\\.mm$" . objc-mode)) auto-mode-alist))

;; SKK
(require 'skk-setup)
(defvar skk-large-jisyo "~/SKK-JISYO.L")

; Moccur
; http://www.bookshelf.jp/elc/moccur-edit.el
; http://www.emacswiki.org/emacs/download/color-moccur.el
(require 'color-moccur)
(require 'moccur-edit)
(define-key ctl-x-map "F" 'moccur-grep-find)
(define-key ctl-x-map "f" 'moccur-grep)
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))

;; memo (hown and muse)
(setq will-take-memo nil)
(if will-take-memo
    (load (expand-file-name "~/work/dotfiles/.emacs.memo")))

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))

(setq auto-mode-alist
      (append '(("\\.as$" . java-mode)) auto-mode-alist))

(require 'erlang)
(setq auto-mode-alist
      (append '(("\\.erl$" . erlang-mode)
		("\\.hrl$" . erlang-mode)) auto-mode-alist))

(when (eq system-type 'darwin)
  (setq mf-off-x      1280)
  (setq mf-max-width  1600)
  (setq mf-max-height 1200)
  (setq mf-display-padding-width  10)
  )
(defun my-monoscreen()
  (interactive)
  (setq mf-off-x      nil)
  (setq mf-max-width  nil)
  (setq mf-max-height nil)
  (setq mf-display-padding-width  0)
  )
(defun my-maximize-monoscreen()
  (interactive)
  (my-monoscreen)
  (maximize-frame))

;; python-mode
(setq auto-mode-alist
      (append '(("SConstruct" . python-mode)) auto-mode-alist))

;; c++-mode
(setq auto-mode-alist
      (append '(("\.h$" . c++-mode)) auto-mode-alist))

;; psvn
(require 'psvn)
(global-set-key "\C-xv" 'svn-status)

(when (eq system-type 'gnu/linux)
  (setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
  (setq inhibit-startup-screen t)
  (setq x-super-keysym 'meta)
  (setq x-super-keysym 'meta)
  (setq x-select-enable-clipboard t)
  (setq default-frame-alist
	(append (list '(width .  80)
		      '(height . 60)
		      '(border-color . "black")
		      '(mouse-color  . "white")
		      '(cursor-color . "black")
		      '(font . "Monospace-8"))
		default-frame-alist)))

;; http://github.com/rmm5t/maxframe-el/tree/master
(require 'maxframe)
;; emacsclient
(server-start)
