
;; load local configurations
(load (expand-file-name "~/work/dotfiles/.emacs.prologue"))
;;
;; appearance
;;
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(tool-bar-mode nil)
(menu-bar-mode nil)
(setq visible-bell t)

;;
;; customize built-ins
;; 
(setq make-backup-files nil)
(setq truncate-partial-width-window nil)
(setq inhibit-startup-screen t)
(iswitchb-mode t)
(global-set-key "\M-g" `goto-line)
(global-set-key "\M-i" `indent-region)
(add-to-list 'load-path (expand-file-name "~/elisp/"))

;; mode association
(setq auto-mode-alist
      (append '(("\\.mm$" . objc-mode)) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.svg$" . xml-mode)) auto-mode-alist))

;; SKK
(require 'skk-setup)
(defvar skk-large-jisyo "~/SKK-JISYO.L")

;; Moccur
;; http://www.bookshelf.jp/elc/moccur-edit.el
;; http://www.bookshelf.jp/elc/color-moccur.el
(require 'color-moccur)
(require 'moccur-edit)
(define-key ctl-x-map "F" 'moccur-grep-find)
(define-key ctl-x-map "f" 'moccur-grep)
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))

;; memo (hown and muse)
(if will-take-memo
    (load (expand-file-name "~/work/dotfiles/.emacs.memo")))

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))

(setq auto-mode-alist
      (append '(("\\.as$" . java-mode)) auto-mode-alist))

; temporaly disabled
(when enabled-minor-languages
  (require 'erlang)
  (setq auto-mode-alist
	(append '(("\\.erl$" . erlang-mode)
		  ("\\.hrl$" . erlang-mode)) auto-mode-alist)))
(defun setup-ensime ()
  ;; Load the ensime lisp code...
  (add-to-list 'load-path "~/local/ensime/elisp/")
  (require 'ensime)
  ;; This step causes the ensime-mode to be started whenever
  ;; scala-mode is started for a buffer. You may have to customize this step
  ;; if you're not using the standard scala mode.
  (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
  ;; MINI HOWTO: 
  ;; Open .scala file. M-x ensime (once per project)
  )
(when enabled-minor-languages
  (add-to-list 'load-path (expand-file-name "~/elisp/scala"))
  (require 'scala-mode-auto)
  (defun my-scala-mode-hook()
    (interactive)
    (setq indent-tabs-mode nil))
  (add-hook 'scala-mode-hook 'my-scala-mode-hook)
  (setup-ensime)
)

(when enabled-minor-languages
  (require 'coffee-mode)
  (defun my-coffee-mode-hook()
    (interactive)
    (setq tab-width 2)
    (setq coffee-tab-width 2))
  (add-hook 'coffee-mode-hook 'my-coffee-mode-hook))

(when (eq system-type 'darwin)
  (setq mf-off-x      1280)
;  (setq mf-max-width  1600)
;  (setq mf-max-height 1200)
  (setq mf-max-width  2560)
  (setq mf-max-height 1440)
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

;; http://github.com/rmm5t/maxframe-el/tree/master
(require 'maxframe)
;; emacsclient
(server-start)

;; python-mode
(setq auto-mode-alist
      (append '(("SConstruct" . python-mode)) auto-mode-alist))

;; c++-mode
(setq auto-mode-alist
      (append '(("\.h$" . c++-mode)) auto-mode-alist))

;; llvm/utils/emacs/emacs.el
(c-add-style "llvm.org"
	     '((fill-column . 80)
	       (c++-indent-level . 2)
	       (c-basic-offset . 2)
	       (indent-tabs-mode . nil)))
(defun llvm-c-mode-hook ()
  (c-set-style "llvm.org"))

;; webkit-style
;; http://lists.macosforge.org/pipermail/webkit-dev/2009-September/010014.html
(defun webkit-c-mode-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 8)
  (setq indent-tabs-mode nil)
  (c-set-offset 'innamespace 0) 
  (c-set-offset 'substatement-open 0))

(defun my-c-mode-hook ()
  (cond 
   ((string-match "llvm" buffer-file-name)
    (llvm-c-mode-hook))
   ((or (string-match "WebCore" buffer-file-name)
	(string-match "JavaScriptCore" buffer-file-name)
	(string-match "WebKit" buffer-file-name))
    (webkit-c-mode-hook))))
(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(defun webkit-change-log-mode-hook ()
  (setq tab-width 8)
  (setq indent-tabs-mode nil))
(add-hook 'change-log-mode-hook 'webkit-change-log-mode-hook)

(require 'autorevert)
(add-hook 'c++-mode-hook 'turn-on-auto-revert-mode)

;; psvn
(require 'psvn)
(global-set-key "\C-xv" 'svn-status)

(when (and enabled-truetype (eq system-type 'gnu/linux))
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


;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
(defface my-face-b-1 '((t (:background "red"))) nil)
(defface my-face-b-2 '((t (:background "honeydew1"))) nil)
;;(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;;(defvar my-face-r-1 'my-face-r-1)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
;;(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("��" 0 my-face-b-1 append)
     ;;("[ \t]+$" 0 my-face-u-1 append)
     ;;("[\r]*\n" 0 my-face-r-1 append)
     )))

(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;; http://code.google.com/p/js2-mode/
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(defun my-js2-mode-hook()
  (interactive)
  (setq js2-basic-offset 2))
(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; color-theme
;; http://www.nongnu.org/color-theme/
(add-to-list 'load-path (expand-file-name "~/elisp/color-theme"))
(require 'color-theme)
(color-theme-initialize)
(color-theme-simple-1)

;;
;; gdb
;; from http://d.hatena.ne.jp/higepon/20090505/p1
;;
(setq gdb-many-windows t)
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))
;(setq gdb-use-separate-io-buffer t)
(setq gud-tooltip-echo-area nil)

(defun sbt()
  (interactive)
  (compile "SBT_OPTS=-Dsbt.log.noformat=true sbt test"))