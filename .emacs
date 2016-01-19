;;
;; load local configurations
(load (expand-file-name "~/work/dotfiles/.emacs.prologue"))

; ELPA - Following configurations need this.
(require 'package)
(package-initialize)

;;
;; customize built-ins
;;
(setq make-backup-files nil)
(setq truncate-partial-width-window nil)
(setq inhibit-startup-screen t)
(require 'ido)
(ido-mode)
(global-set-key "\M-g" `goto-line)

(global-set-key "\M-i" `indent-region)
(add-to-list 'load-path (expand-file-name "~/work/trivials/elisp/"))
;; Copied from window.el: The original setting doesn't work on Cocoa Emacs on ML.
(define-key ctl-x-map "o" 'other-window)

;;
;; Appearances
;;
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(if (and (bound-and-true-p tool-bar-mode)
	 (fboundp 'tool-bar-mode))
    (tool-bar-mode -1))
(menu-bar-mode nil)
(setq visible-bell nil)

(prefer-coding-system       'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(setq default-buffer-file-coding-system 'utf-8-unix)

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
;; This doesn't work well in my Ubuntu VM for some reson :-/
;;     (color-theme-arjen)
     ))

;; MS Windows clipboard is UTF-16LE
;(set-clipboard-coding-system 'utf-16le-dos)
;; For linux
(setq x-select-enable-clipboard t)

;;
;; Fonts:
;;
;; FIXME: should be limited to mac
(if (display-graphic-p)
    (progn
      (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 (font-spec :family "ヒラギノ角ゴ ProN") nil 'append)
      (set-fontset-font (frame-parameter nil 'font) 'chinese-gb2312 (font-spec :family "STSong") nil 'append)))

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

;;
;; Cool things
;;
;; emacsclient
(if (bound-and-true-p enable-server)
    (server-start))

(require 'ag)
(require 'wgrep-ag)
(setq ag-highlight-search t)
(define-key ctl-x-map "F" 'ag)
(define-key ctl-x-map "f" 'ag-project) ;; experimental.

(require 'helm-config)
(global-set-key (kbd "C-c h") 'helm-mini)
;; Doesn't work :-(
;; (setq helm-exit-idle-delay 0)
;; (helm-mode t)


;;
;; Programming modes
;;

;; ruby-mode
(autoload 'ruby-mode "ruby-mode"
  "Mode for editing ruby source files" t)
(setq auto-mode-alist
      (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))

;; Erlang - At Nov. 2011, there is no el-get recipe for this.
(if (require 'erlang nil t)
    (setq auto-mode-alist
	  (append '(("\\.erl$" . erlang-mode)
		    ("\\.hrl$" . erlang-mode)) auto-mode-alist)))

;; Scala
(require 'scala-mode)
(defun my-scala-mode-hook()
  (interactive)
  (setq indent-tabs-mode nil))
(add-hook 'scala-mode-hook 'my-scala-mode-hook)

(defun sbt()
  (interactive)
  (compile "SBT_OPTS=-Dsbt.log.noformat=true sbt test"))

;; python-mode
(setq auto-mode-alist
      (append '(("SConstruct" . python-mode)
		("wscript" . python-mode)) auto-mode-alist))

;; go-mode
(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq tab-width 2))
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; javascript-mode
(defun my-js-mode-hook()
  (interactive)
  (setq indent-tabs-mode nil))

(add-hook 'js-mode-hook 'my-js-mode-hook)
(setq auto-mode-alist
      (append '(("\.js$" . js2-mode)) auto-mode-alist))

;;
;; c++-mode
;;

;; google-c-style
;; I remove hooks which is registered by el-get to avoid conflict.
;; TODO(morrita): Is the trick still needed?
(require 'google-c-style)
(remove-hook 'c-mode-common-hook 'google-set-c-style)
(remove-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c-mode-common-hook 'my-c-mode-hook)
(setq auto-mode-alist
      (append '(("\.h$" . c++-mode)) auto-mode-alist))
(defun force-google-c-mode ()
  (interactive)
  (google-set-c-style))

;; llvm/utils/emacs/emacs.el
(c-add-style "llvm.org"
	     '((fill-column . 80)
	       (c++-indent-level . 2)
	       (c-basic-offset . 2)
	       (indent-tabs-mode . nil)))
(defun llvm-c-mode-hook ()
  (interactive)
  (c-set-style "llvm.org"))

;; webkit-style
;; http://lists.macosforge.org/pipermail/webkit-dev/2009-September/010014.html
(defun webkit-c-mode-hook ()
  (interactive)
  (setq c-basic-offset 4)
  (setq tab-width 8)
  (setq indent-tabs-mode nil)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'substatement-open 0))

(defun my-c-mode-hook ()
  (cond
   ((string-match "llvm" buffer-file-name)
    (llvm-c-mode-hook))
   ((string-match "WebKit" buffer-file-name)
    (webkit-c-mode-hook))
   (t (google-set-c-style))))

(require 'autorevert)
(add-hook 'c++-mode-hook 'turn-on-auto-revert-mode)

;; JS2 mode
;; http://code.google.com/p/js2-mode/
;(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(defun my-js2-mode-hook()
  (interactive)
  (setq js2-basic-offset 2))
(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;; mode association
(setq auto-mode-alist
      (append '(("\\.m$" . octave-mode)) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.mm$" . objc-mode)) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.svg$" . xml-mode)) auto-mode-alist))

;;
;;
;; Tricks
;;
;;

;; For mac. This should be here instead of .emacs
;; to void an ecoding trouble.
;; TODO(morrita): I'm removing .emacs.memo.
;; See if this works.
(when (eq window-system 'ns)
  (define-key global-map [?¥] "\\")
  (setq ns-command-modifier 'super))

;;
;; Highlighting ugly things
;;
(defface my-face-b-1 '((t (:background "yellow"))) nil)
(defface my-face-b-2 '((t (:background "honeydew1"))) nil)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("[ \t]+$" 0 my-face-b-1 append)
;     ("[\r]*\n" 0 my-face-b-1 append)
     ("｡｡" 0 my-face-b-1 append) ;; TODO(morrita): I don't know what this is for :-(
     )))

(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

;;
;; from http://d.hatena.ne.jp/rubikitch/20100210/emacs
;;
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally-triple))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)

(global-set-key (kbd "M-p") 'previous-buffer)
(global-set-key (kbd "M-n") 'next-buffer)
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)

(when (fboundp 'windmove-default-keybindings)
  (setq windmove-wrap-around t)
  (windmove-default-keybindings))

;;
;; Org related settings
;;
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-todo-keywords
      '((sequence "TODO" "ACTIVE" "BLOCKED" "|" "DONE" "GONE" "ICED")))
(setq org-return-follows-link t)
(setq org-startup-folded nil)
(setq org-agenda-files '("~/w/memo/o" "~/w/memo/o/j"))


(global-set-key (kbd "C-c o")
		(lambda () (interactive) (find-file "~/w/memo/o/index.org")))

(require 'org-journal)
(custom-set-variables
 '(org-journal-dir "~/w/memo/o/j/")
 '(org-journal-hide-entries-p nil)
 '(org-journal-file-format "%Y%m%d.org"))

;;
;; modified http://www.emacswiki.org/emacs/TinyUrl
;;
(require 'thingatpt)
(defun my-get-shorter-bug-url(longer-uri)
  (cond ((string-match "bugs.webkit.org" longer-uri)
	 (let ((num-start (string-match "[[:digit:]]" longer-uri)))
	   (concat "http://wkb.ug/" (substring longer-uri num-start))))
	((string-match "http://code.google.com/p/chromium/issues" longer-uri)
	 (let ((num-start (string-match "[[:digit:]]" longer-uri)))
	   (concat "http://crbug.com/" (substring longer-uri num-start))))
	((string-match "https://code.google.com/p/chromium/issues" longer-uri)
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

