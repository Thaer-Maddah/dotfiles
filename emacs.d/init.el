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

;;;;;;;;;;;; Personal preferences ;;;;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode -1)
;; use larger font
(setq default-frame-alist '((font . "Monospace-11")))

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
(setq pixel-scroll-mode t)


;; Beacon Mode
;; This mode highlighting cursor
(beacon-mode t)

;; Prevent emacs from transfers the clipboard data to the clipboard manager
;; to prevent dealy when exit emacs or reload config file
(setq x-select-enable-clipboard-manager nil)

(setq-default fill-column 80)
(global-display-fill-column-indicator-mode t)
(setq-default display-fill-column-indicator-character ?\N{U+2506})

;; Transparency 
(set-frame-parameter (selected-frame) 'alpha '(75 . 50))
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
 '(custom-enabled-themes '(taylor))
 '(custom-safe-themes
   '("317a45f190eaa3ccf8af6168aa89112d9cb794f87f409bc7a0638edee20d07fd" "6b5c518d1c250a8ce17463b7e435e9e20faa84f3f7defba8b579d4f5925f60c1" default))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(global-command-log-mode nil)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(package-archives
   '(("melpa" . "http://melpa.org/packages/")
     ("gnu" . "https://elpa.gnu.org/packages/")))
 '(package-selected-packages
   '(evil vterm gruvbox-theme color-theme-modern go-complete go-projectile go-mode beacon minimap engine-mode i3wm-config-mode i3wm org-modern org-download org org-bullets dracula-theme transpose-frame virtualenv lsp-jedi jedi command-log-mode popup yasnippet blacken flycheck py-autopep8 better-defaults elpy projectile magit zenburn-theme))
 '(warning-suppress-log-types '((auto-save))))

;; Minimap Mode
(minimap-mode t)
(setq minimap-window-location 'right)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

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
(require 'helm-config)
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
(company-mode 1)
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
(require 'evil)
(evil-mode 1)
