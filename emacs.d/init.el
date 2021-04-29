;; ====================================
;; File Location: ~/.emacs.d/init.el  
;; ====================================

;; Emacs file config
;; Written by Thaer Maddah

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)
;; use larger font
(setq default-frame-alist '((font . "Monospace-12")))
;; Enable Ido-mode
(ido-mode t)

;; Scroll line by line
(setq scroll-step 1
      scroll-conservatively 10000)
(linum-mode 1)
(winner-mode 1)  ;; For undo and redo
(setq tab-always-indent 'complete)
(display-battery-mode 1)
(display-time-mode 1)
(global-visual-line-mode t)
(global-display-line-numbers-mode t)
(setq column-number-mode t)

(setq-default fill-column 80)
(global-display-fill-column-indicator-mode t)
(setq-default display-fill-column-indicator-character ?\N{U+2506})

;; Transparency 
(set-frame-parameter (selected-frame) 'alpha '(90 . 50))
;; (add-to-list 'default-frame-alist '(alpha . (85 . 50)))

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
         '(90 . 50) '(100 . 100)))))
(global-set-key (kbd "C-c t") 'toggle-transparency)


;; Resize windows
(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

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

;; Define C-/ to comment and uncomment regions and lines
(defun comment-or-uncomment-line-or-region ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)
        (next-line)))
(global-set-key (kbd "C-/") 'comment-or-uncomment-line-or-region)

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
 '(command-log-mode t t)
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("81c3de64d684e23455236abde277cda4b66509ef2c28f66e059aa925b8b12534" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" default))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(global-command-log-mode nil)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(package-archives
   '(("melpa" . "http://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(dracula-theme transpose-frame virtualenv lsp-jedi jedi command-log-mode popup yasnippet blacken flycheck py-autopep8 better-defaults elpy projectile magit zenburn-theme))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; python
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

				

;; (use-package yasnippet
;; 	     :ensure t
;; 	     :init
;; 	     (yas-global-mode 1))
