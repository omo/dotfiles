
(set-language-environment "Japanese")
(tool-bar-mode nil)
(menu-bar-mode nil)

(setq make-backup-files nil)
(setq inhibit-startup-screen t)
(iswitchb-mode t)

(add-to-list 'load-path (expand-file-name "~/elisp/"))

;; .mm
(setq auto-mode-alist
      (append '(("\\.mm$" . objc-mode)) auto-mode-alist))

;; SKK
(require 'skk-setup)
(defvar skk-large-jisyo "~/SKK-JISYO.L")

;; Moccur
(require 'color-moccur)
(require 'moccur-edit)
(define-key ctl-x-map "f" 'moccur-grep)
(define-key ctl-x-map "F" 'moccur-grep-find)

;; Muse
(setq muse-project-alist
      '(("Note" ("~/note" :default "index"))))
(setq muse-file-extension nil
      muse-mode-auto-p t)
(require 'muse-mode)
(require 'muse-wiki)
(defun my-open-muse()
  (interactive)
  (let ((welcome-page 
	 (find-file-noselect 
	  (expand-file-name "~/note/WelcomePage"))))
    (switch-to-buffer welcome-page)))
(define-key ctl-x-map "w" 'my-open-muse)

;; howm
(setq howm-menu-lang 'ja)
(setq howm-directory "~/memo/home/howm")
(setq howm-file-name-format "%Y_%m.howm")
(setq howm-list-recent-title t)
(setq howm-template-file-format "")
(setq howm-view-summary-persistent nil)
(setq auto-mode-alist
         (append '(("\\.howm$" . howm-mode)) auto-mode-alist))
(require 'howm)
(require 'howm-mode)

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
