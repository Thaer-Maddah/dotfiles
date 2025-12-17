;;; -*- lexical-binding: t -*-
;;; init.el --- Thaer Maddah's Emacs configuration -*- lexical-binding: t; -*-

;; Author: Thaer Maddah
;; Keywords: convenience
;; Homepage: https://github.com/Thaer-Maddah/dotfiles/emacs.d
;; Version: 1.0

;; This file is not part of GNU Emacs.

;;; Commentary:
;; Personal Emacs configuration file

;;; ====================================
;;; File Location: ~/.emacs.d/init.el
;;; ====================================

;;;Code:
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Initialize package system
(unless (bound-and-true-p package--initialized)
  (package-initialize))

;; Refresh package contents if needed
(unless (and (boundp 'package-archive-contents) 
             package-archive-contents)
  (package-refresh-contents))

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; (require 'use-package)
;; (setq use-package-always-ensure t)

;;;;;;;;;;;; Personal preferences ;;;;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode -1)
(global-hl-line-mode +1)

;;(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;;(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)
;; use larger font
(setq default-frame-alist '((font . "Monospace-11")))

;; Enable Ido-mode
(ido-mode t)

;; enable history
(savehist-mode 1)
;; Dialogbox(
(setq use-dialog-box t)
;; Scroll line by line
(setq scroll-step 1
      scroll-conservatively 10000)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(winner-mode 1)  ;; For undo and redo
(setq tab-always-indent 'complete)
(display-battery-mode 1)
(display-time-mode 1)
(global-visual-line-mode t)
(global-display-line-numbers-mode t)
(setq column-number-mode t)
(setq pixel-scroll-mode t)

;; toggle between vertical and horizontal layout
(defun toggle-window-split ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window t)
        (switch-to-buffer (other-buffer))))))

(global-set-key (kbd "C-x |") 'toggle-window-split)

;; swap window position
(global-set-key (kbd "C-<left>") 'windmove-swap-states-left)
(global-set-key (kbd "C-<right>") 'windmove-swap-states-right)
(global-set-key (kbd "C-<up>") 'windmove-swap-states-up)
(global-set-key (kbd "C-<down>") 'windmove-swap-states-down)

;; Resize windows
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; Beacon Mode
;; This mode highlighting cursor
(beacon-mode t)

;; Prevent emacs from transfers the clipboard data to the clipboard manager
;; to prevent dealy when exit emacs or reload config file
(setq x-select-enable-clipboard-manager nil)

(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 0)
(setq-default display-fill-column-indicator-character ?\N{U+2506})

;; Transparency
(set-frame-parameter (selected-frame) 'alpha '(80 . 50))
(add-to-list 'default-frame-alist '(alpha . (80 . 50)))

(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(80 . 50) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)



;; draw colum at line 80
;; (require 'fill-column-indicator)
;; (setq fci-rule-width 3)
;; (add-hook 'python-mode-hook 'fci-mode)
;; (setq fci-rule-color "darkblue")

;; (menu-bar--display-line-numbers-mode-relative)
    ;; (lambda ()
    ;;   (interactive)
    ;;   (menu-bar-display-line-numbers-mode 'relative)
    ;;   (message "Relative line numbers enabled"))

;; Cancel C-next shortcut
(global-unset-key (kbd "C-<next>"))

;; Show the matching parenthesis
(show-paren-mode t)

;; Set C-c, C-x, C-v and other shortcuts
;; (cua-mode t)

;; Define C-; to comment and uncomment regions and lines
(defun comment-or-uncomment-line-or-region ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
	))	;; (next-line))) ;; if I want to go to next line 
	
(global-set-key (kbd "C-;") 'comment-or-uncomment-line-or-region)

;; https://stackoverflow.com/questions/17958397/emacs-delete-whitespaces-or-a-word
(defun kill-whitespace-or-word ()
  (interactive)
  (if (looking-at "[ \t\n]")
      (let ((p (point)))
        (re-search-forward "[^ \t\n]" nil :no-error)
        (backward-char)
        (kill-region p (point)))
    (kill-word 1)))
(global-set-key (kbd "C-<delete>") 'kill-whitespace-or-word)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(command-log-mode t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(global-command-log-mode nil)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(package-archives
   '(("melpa" . "http://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(beacon better-defaults blacken color-theme-modern command-log-mode
	    dracula-theme elpy emms engine-mode evil flycheck go-complete
	    go-projectile gruvbox-theme helm-sly jedi lsp-jedi magit minimap
	    multiple-cursors org org-bullets org-download org-modern popup
	    projectile py-autopep8 region-bindings-mode transpose-frame
	    virtualenv vterm yasnippet zenburn-theme))
 '(warning-suppress-log-types '((auto-save))))
;; Minimap Mode
;(minimap-mode nil)
;(setq minimap-window-location 'right)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; load theme
(load-theme 'gruvbox :no-confirm)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Python Preferences ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args "-i")
;; ====================================
;; Development Setup
;; ====================================
;; Enable elpy
(elpy-enable)


;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)


;; use popup menu for yas-choose-value
(require 'popup)

;; add some shotcuts in popup menu mode
(define-key popup-menu-keymap (kbd "M-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "M-p") 'popup-previous)

(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))

(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-maybe-ido-prompt yas-completing-prompt yas-no-prompt))
(yas-global-mode t)
(add-hook 'yas-minor-mode-hook(lambda()
				(yas-activate-extra-mode 'fundamental-mode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Lisp preferences ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inferior-lisp-program "/usr/bin/sbcl")

;;Load sly when .lisp file is opened
(add-hook 'sly-mode-hook
          (lambda ()
            (unless (sly-connected-p)
              (save-excursion (sly))
	      (helm-sly-mode t)
	      )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go Preferences ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'go-mode-hook (lambda ()
    (setq tab-width 4)))

;; Advanced per-language checks.
(require 'flycheck)
(global-flycheck-mode 1)
(setq flycheck-checker-error-threshold 1000) ; for large go files and the escape checker

(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp)

;; Navigation inside code project
(require 'projectile)
(projectile-mode "1.0")

;; Helm: incremental completion and selection narrowing inside menus/lists
(require 'helm)
;;(require 'helm-config)
(require 'helm-projectile)
(helm-mode 1)
(helm-projectile-on)

(setq helm-split-window-inside-p            t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(require 'company) ; code completion framework
(global-company-mode t)
(require 'compile) ; per-language builds
;; (require 'go-complete)

(require 'lsp-mode) ; language server
;;(add-hook 'lsp-mode-hook 'lsp-ui-mode) ; display contextual overlay
;;(with-eval-after-load 'flycheck
;;  (add-to-list 'flycheck-checkers 'lsp-ui))
;; (require 'company-lsp)
;; (push 'company-lsp company-backends)

;; Note: do not use 'lsp-ui-flycheck; this replaces the "advanced"
;; Go checkers including our custom escape checker below.


;; Org mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Spell Checking 
(add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "#\\+END_SRC"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))

;; Engine Mode
;; the default keymap prefix is C-x / and the search engine shortcut
;; like C-x / d to search by DuckDuckGO engine
(engine-mode t)
(setq engine/browser-function 'browse-url-chromium)

(defengine duckduckgo
  "https://duckduckgo.com/?q=%s"
  :keybinding "d")

(defengine google
  "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s"
  :keybinding "g")

(defengine github
  "https://github.com/search?ref=simplesearch&q=%s"
  :keybinding "h")

(defengine stack-overflow
  "https://stackoverflow.com/search?q=%s"
  :keybinding "s")

(defengine youtube
  "http://www.youtube.com/results?aq=f&oq=&search_query=%s"
  :keybinding "y")

;; Download Evil
(unless (package-installed-p 'evil)
  (package-install 'evil))

;; Enable Evil
;(require 'evil)
;(evil-mode t)

;; EMMS player
(require 'emms-setup)
(emms-all)
(emms-default-players)
;; Optional: Set your default music directory
(setq emms-source-file-default-directory "~/Music/")
;;(setq emms-player-list '(emms-player-mpv))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Install region-binding-mode package to use with multiple cursors
(require 'region-bindings-mode)
(region-bindings-mode-enable)

;; Multiple cursors 
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this-word)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this-word)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this-word)
(define-key region-bindings-mode-map "a" 'mc/mark-all-like-this)
(define-key region-bindings-mode-map "p" 'mc/mark-previous-like-this)
(define-key region-bindings-mode-map "n" 'mc/mark-next-like-this)
(define-key region-bindings-mode-map "m" 'mc/mark-more-like-this-extended)


;;; init.el ends here
