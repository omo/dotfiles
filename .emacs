
;; load local configurations
(load (expand-file-name "~/work/dotfiles/.emacs.prologue"))
;;
;; appearance
;;
(set-language-environment "Japanese")
(tool-bar-mode nil)
(menu-bar-mode nil)
(setq visible-bell t)

(prefer-coding-system       'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)
;; MS Windows clipboard is UTF-16LE 
;(set-clipboard-coding-system 'utf-16le-dos)

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

;; for hobby programming
(when enabled-minor-languages
  (require 'erlang)
  (setq auto-mode-alist
	(append '(("\\.erl$" . erlang-mode)
		  ("\\.hrl$" . erlang-mode)) auto-mode-alist))
  (add-to-list 'load-path (expand-file-name "~/elisp/scala"))
  (setq auto-mode-alist
	(append '(("\\.as$" . java-mode)) auto-mode-alist))
  (require 'scala-mode-auto))

(when enable-mf-customization
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

;; webkit-style
;; http://lists.macosforge.org/pipermail/webkit-dev/2009-September/010014.html
(defun webkit-c-mode-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 8)
  (setq indent-tabs-mode nil)
  (c-set-offset 'innamespace 0) 
  (c-set-offset 'substatement-open 0))
(add-hook 'c-mode-common-hook 'webkit-c-mode-hook)

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
     ("¡¡" 0 my-face-b-1 append)
     ;;("[ \t]+$" 0 my-face-u-1 append)
     ;;("[\r]*\n" 0 my-face-r-1 append)
     )))

(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)


(defun split-window-horizontally-triple ()
  (interactive)
  (let ((size (/ (* (window-width) 2) 3)))
    (split-window-horizontally size)
    (split-window-horizontally)))

;; from http://d.hatena.ne.jp/rubikitch/20100210/emacs
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally-triple))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)

(defun my-last-window ()
  (interactive)
  (other-window -1))

(defun my-next-window ()
  (interactive)
  (other-window  1))

(global-set-key (kbd "M-p") 'previous-buffer)
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "M-P") 'my-last-window)
(global-set-key (kbd "M-N") 'my-next-window)

;;
;; gdb
;; from http://d.hatena.ne.jp/higepon/20090505/p1
;;
(setq gdb-many-windows t)
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))
;(setq gdb-use-separate-io-buffer t)
(setq gud-tooltip-echo-area nil)

(defun my-recompile()
  (interactive)
  (recompile)
  (set-window-buffer (selected-window) "*compilation*")
  (end-of-buffer))
(global-set-key "\C-xr" 'my-recompile)

;; modified http://www.emacswiki.org/emacs/TinyUrl
(require 'thingatpt)
(defun my-get-shorter-bug-url(longer-uri)
  (cond ((string-match "bugs.webkit.org" longer-uri)
	 (let ((num-start (string-match "[[:digit:]]" longer-uri)))
	   (concat "http://webkit.org/b/" (substring longer-uri num-start))))
	((string-match "http://code.google.com/p/chromium/issues" longer-uri)
	 (let ((num-start (string-match "[[:digit:]]" longer-uri)))
	   (concat "http://crbug.com/" (substring longer-uri num-start))))
	((error (concat longer-uri " is not bug url")))))

(defun my-shorten-bug-url()
  (interactive)
  (let ((bounds (bounds-of-thing-at-point 'url)))
    (when bounds
      (let* ((long-url (buffer-substring
                        (car bounds) (cdr bounds)))
             (short-url (my-get-shorter-bug-url long-url)))
	(save-excursion
          (goto-char (car bounds))
          (replace-string long-url short-url nil (car bounds) (cdr bounds)))))))

(global-set-key (kbd "C-c S") 'my-shorten-bug-url)
