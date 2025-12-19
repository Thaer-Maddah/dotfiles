;;; -*- lexical-binding: t -*-
;;; init.el --- Thaer Maddah's Emacs configuration -*- lexical-binding: t; -*-

;; Author: Thaer Maddah
;; Keywords: convenience
;; Homepage: https://github.com/Thaer-Maddah/dotfiles/emacs.d
;; Version: 1.0

;; This file is not part of GNU Emacs.

;;; Commentary:
;; Personal Emacs configuration file

;; Initialize package system
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; Install use-package if not present
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;; Personal preferences ;;;;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode -1)

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
;; Dialogbox
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
(setq column-number-mode t)
(setq pixel-scroll-mode t)

;; Enable relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

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

;; Prevent emacs from transfers the clipboard data to the clipboard manager
;; to prevent delay when exit emacs or reload config file
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

;; Cancel C-next shortcut
(global-unset-key (kbd "C-<next>"))

;; Show the matching parenthesis
(show-paren-mode t)

;; Define C-; to comment and uncomment regions and lines
(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-;") 'comment-or-uncomment-line-or-region)

;; Duplicate line
(defun duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (pos-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))
(global-set-key (kbd "C-,") 'duplicate-line)

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Package Configurations ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package beacon
  :config
  (beacon-mode t))

(use-package command-log-mode
  :config
  (global-command-log-mode nil))

(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox :no-confirm))

(use-package elpy
  :config
  (elpy-enable))

(use-package flycheck
  :after elpy
  :config
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)
    (global-flycheck-mode 1)
    (setq flycheck-checker-error-threshold 1000)))

(use-package py-autopep8
  :after elpy
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

(use-package popup
  :config
  (define-key popup-menu-keymap (kbd "M-n") 'popup-next)
  (define-key popup-menu-keymap (kbd "TAB") 'popup-next)
  (define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
  (define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
  (define-key popup-menu-keymap (kbd "M-p") 'popup-previous))

(use-package yasnippet
  :config
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
       :isearch t)))
  
  (setq yas-prompt-functions '(yas-popup-isearch-prompt yas-maybe-ido-prompt yas-completing-prompt yas-no-prompt))
  (yas-global-mode t)
  (add-hook 'yas-minor-mode-hook
            (lambda ()
              (yas-activate-extra-mode 'fundamental-mode))))

(use-package sly
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (add-hook 'sly-mode-hook
            (lambda ()
              (unless (sly-connected-p)
                (save-excursion (sly))))))

(use-package helm-sly
  :after sly
  :config
  (add-hook 'sly-mode-hook 'helm-sly-mode))

(use-package go-mode
  :config
  (add-hook 'go-mode-hook
            (lambda ()
              (setq tab-width 4))))

(use-package lsp-mode
  :config
  (add-hook 'go-mode-hook #'lsp))

(use-package projectile
  :config
  (projectile-mode "1.0"))

(use-package helm
  :config
  (helm-mode 1)
  (setq helm-split-window-inside-p t
        helm-move-to-line-cycle-in-source t
        helm-ff-search-library-in-sexp t
        helm-scroll-amount 8
        helm-ff-file-name-history-use-recentf t
        helm-echo-input-in-header-line t))

(use-package helm-projectile
  :after (helm projectile)
  :config
  (helm-projectile-on))

(use-package company
  :config
  (global-company-mode t))

(use-package engine-mode
  :config
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
    :keybinding "y"))

(use-package evil
  :config
  ;;(evil-mode t)  ; Uncomment to enable Evil mode
  )

(use-package emms
  :config
  (require 'emms-setup)
  (emms-all)
  (emms-default-players)
  (setq emms-source-file-default-directory "~/Music/"))

(use-package region-bindings-mode
  :config
  (region-bindings-mode-enable))

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this-word)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this-word)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this-word)
  
  (define-key region-bindings-mode-map "a" 'mc/mark-all-like-this)
  (define-key region-bindings-mode-map "p" 'mc/mark-previous-like-this)
  (define-key region-bindings-mode-map "n" 'mc/mark-next-like-this)
  (define-key region-bindings-mode-map "m" 'mc/mark-more-like-this-extended))

;; Magit - Git interface
(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Python Preferences ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go Preferences ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'go-mode-hook (lambda ()
                          (setq tab-width 4)))

;; Org mode
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;; Spell Checking
(add-to-list 'ispell-skip-region-alist '(":\\(PROPERTIES\\|LOGBOOK\\):" . ":END:"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_SRC" . "#\\+END_SRC"))
(add-to-list 'ispell-skip-region-alist '("#\\+BEGIN_EXAMPLE" . "#\\+END_EXAMPLE"))

;; When you have LaTeX math in Org Mode (like $E=mc^2$), Emacs needs to convert it to an image to display it. This configuration tells Org Mode how to do that conversion.
(setq org-preview-latex-process-alist  ; Sets a variable that controls LaTeX preview
      '((dvipng                        ; Using the "dvipng" method (one of several options)
         :programs ("latex" "dvipng")  ; Requires these two programs installed on your system
         
         :description "dvi > png"      ; Human-readable description: converts DVI to PNG
         
         :image-input-type "dvi"       ; Intermediate format: LaTeX → DVI file
         :image-output-type "png"      ; Final output: PNG image
         
         :image-size-adjust (1.0 . 1.0) ; Scaling factors (width . height)
         
         ; Command to compile LaTeX to DVI
         :latex-compiler ("latex -interaction nonstopmode -output-directory %o %f")
         ; %o = output directory, %f = input .tex file
         
         ; Command to convert DVI to PNG
         :image-converter ("dvipng -D %D -T tight -o %O %f")
         ; %D = DPI resolution, %O = output PNG file, %f = input DVI file
         )))

;; Custom variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(command-log-mode t t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(global-command-log-mode nil)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(org-babel-load-languages
   '((css . t) (latex . t) (sql . t) (C . t) (awk . t) (shell . t) (emacs-lisp . t)))
 '(package-selected-packages nil)
 '(warning-suppress-log-types '((auto-save))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
