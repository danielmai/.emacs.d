;; Turn off mouse interface early in startup to avoid momentary display
(when window-system
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1))


(setq inhibit-startup-message t)
(setq initial-scratch-message "")

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") )t
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(org-babel-load-file (concat user-emacs-directory "config.org"))
