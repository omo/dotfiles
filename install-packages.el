;; To run this:
;; $emacs --script install-packages.el
;;
(defun my-install-if-needed (sym)
  (if (not (require sym nil t))
      (package-install sym)))

(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)
(if (and
     (not (getenv "PROVISION_MAY_SKIP_ELPA_REFRESH")) ;; This is for Vagrant provisioning
     (require 'scala-mode nil t)) ;; This checks if this is the initial run.
    (package-refresh-contents))

(my-install-if-needed 'auto-complete)
(my-install-if-needed 'color-theme)
(my-install-if-needed 'wgrep)
(my-install-if-needed 'wgrep-ag)
(my-install-if-needed 'anything)
(my-install-if-needed 'google-c-style)
(my-install-if-needed 'ag)
(my-install-if-needed 'helm)
(my-install-if-needed 'helm-ag)
(my-install-if-needed 'helm-projectile)
(my-install-if-needed 'js2-mode)
(my-install-if-needed 'erlang)
(my-install-if-needed 'ruby-mode)
(my-install-if-needed 'rust-mode)
(my-install-if-needed 'go-mode)
(my-install-if-needed 'groovy-mode)
(my-install-if-needed 'go-autocomplete)
(my-install-if-needed 'scala-mode)
(my-install-if-needed 'python-mode)
(my-install-if-needed 'org)
(my-install-if-needed 'org-journal)
