;;
;; reset
;;

(global-set-key (kbd "M-t") nil)
(global-set-key (kbd "M-t c") 'transpose-chars)
(global-set-key (kbd "M-t w") 'transpose-words)


;;
;; package
;;

(eval-when-compile
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package)
    (package-install 'diminish)
    (package-install 'quelpa)
    (package-install 'bind-key))

  (setq use-package-always-ensure t)
  (setq use-package-expand-minimally t)

  (require 'use-package))

(require 'diminish)
(require 'bind-key)


;;
;; server
;;

(use-package server
  :ensure nil
  :hook (after-init . server-mode))


;;
;; Themes & UI
;;

(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
  :custom-face
  ;; (vertical-bar   (doom-darken base5 0.4))
  ;; (doom-darken bg 0.4)
  :config
  (load-theme 'doom-dracula t)
  (doom-themes-neotree-config)
  ;;(doom-themes-org-config)
  ;; Modeline
  (use-package doom-modeline
    :custom
    (doom-modeline-buffer-file-name-style 'truncate-with-project)
    (doom-modeline-icon t)
    (doom-modeline-major-mode-icon nil)
    (doom-modeline-minor-modes nil)
    :hook
    (after-init . doom-modeline-mode)
    :config
    (set-cursor-color "cyan")
    (line-number-mode 0)
    (column-number-mode 0)
    (doom-modeline-def-modeline 'main
                                        ;'(bar workspace-number window-number evil-state god-state ryo-modal xah-fly-keys matches buffer-info remote-host buffer-position parrot selection-info)
                                        ;'(misc-info persp-name lsp github debug minor-modes input-method major-mode process vcs checker)      ))
      )))



;; ターミナル以外はツールバー、スクロールバーを非表示
(when window-system
  (tool-bar-mode 0)
  (scroll-bar-mode 0))

;; メニューバーを非表示
(menu-bar-mode 0)

;; 余白・スクロールバー・タイトルバー
(when (memq window-system '(mac ns))
  (setq initial-frame-alist
        (append
         '((ns-transparent-titlebar . t) ;; タイトルバーを透過
           (vertical-scroll-bars . nil) ;; スクロールバーを消す
           (ns-appearance . dark) ;; 26.1 {light, dark}
           (internal-border-width . 0))))) ;; 余白を消す
(setq default-frame-alist initial-frame-alist)

;; 行番号を常に表示
(global-linum-mode t)

;; title bar format
(setq frame-title-format "%f")


;;
;; Editing
;;

(setq split-width-threshold nil)

;; Encoding
(prefer-coding-system 'utf-8-unix)
(set-locale-environment "en_US.UTF-8")
(set-default-coding-systems 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8) ; included by set-selection-coding-system
(set-keyboard-coding-system 'utf-8) ; configured by prefer-coding-system
(set-terminal-coding-system 'utf-8) ; configured by prefer-coding-system
(setq buffer-file-coding-system 'utf-8) ; utf-8-unix
(setq save-buffer-coding-system 'utf-8-unix) ; nil
(setq process-coding-system-alist
      (cons '("grep" utf-8 . utf-8) process-coding-system-alist))

;; Quiet Startup
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)
(defun display-startup-echo-area-message ()
  (message ""))

(setq frame-title-format nil)
(setq ring-bell-function 'ignore)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets) ; Show path if names are same

(setq adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*")
(setq adaptive-fill-first-line-regexp "^* *$")
(setq sentence-end "\\([。、！？]\\|……\\|[,.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")

(setq sentence-end-double-space nil)

(setq delete-by-moving-to-trash t)    ; Deleting files go to OS's trash folder

(setq make-backup-files nil)          ; Forbide to make backup files
(setq auto-save-default nil)          ; Disable auto save

(setq set-mark-command-repeat-pop t)  ; Repeating C-SPC after popping mark pops it again
(setq track-eol t)		              ; Keep cursor at end of lines.
(setq line-move-visual nil)		      ; To be required by track-eol
(setq-default kill-whole-line t)	  ; Kill line including '\n'
(setq-default indent-tabs-mode nil)   ; use space
(defalias 'yes-or-no-p #'y-or-n-p)

(when (functionp 'mac-auto-ascii-mode)
  (mac-auto-ascii-mode 1))

;; Delete selection if insert someting
(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))

;; Automatically reload files was modified by external program
(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

;; Hungry deletion
(use-package hungry-delete
  :diminish
  :hook (after-init . global-hungry-delete-mode)
  :config (setq-default hungry-delete-chars-to-skip " \t\f\v"))


;;
;; paren & smartparens
;;

(use-package paren
  :ensure nil
  :hook
  (after-init . show-paren-mode)
  :custom-face
  (show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c")))) ;; :box t
  :custom
  (show-paren-style 'mixed)
  (show-paren-delay 0)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t))

(use-package smartparens
  :hook
  (after-init . smartparens-global-mode)
  :config
  (require 'smartparens-config)
  (sp-pair "=" "=" :actions '(wrap))
  (sp-pair "+" "+" :actions '(wrap))
  (sp-pair "<" ">" :actions '(wrap))
  (sp-pair "$" "$" :actions '(wrap)))


;;
;; history
;;

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 2000)
  (recentf-exclude '((expand-file-name package-user-dir)
		     ".cache"
                     "cache"
                     "recentf"
                     "COMMIT_EDITMSG\\'")))

;; do not show recentf messages to the echo area (minibuffer)
(defun recentf-save-list-inhibit-message:around (orig-func &rest args)
  (setq inhibit-message t)
  (apply orig-func args)
  (setq inhibit-message nil)
  'around)
(advice-add 'recentf-cleanup   :around 'recentf-save-list-inhibit-message:around)
(advice-add 'recentf-save-list :around 'recentf-save-list-inhibit-message:around)


;;
;; Font
;;
;; |abcdef ghijkl|
;; |ABCDEF GHIJKL|
;; |'";:-+ =/\~`?|
;; |∞≤≥∏∑∫ ×±⊆⊇|
;; |αβγδεζ ηθικλμ|
;; |ΑΒΓΔΕΖ ΗΘΙΚΛΜ|
;; |日本語 の美観|
;; |あいう えおか|
;; |アイウ エオカ|
;; |ｱｲｳｴｵｶ ｷｸｹｺｻｼ|
;; | hoge                 | hogeghoe | age               |
;; |----------------------+----------+-------------------|
;; | 今日もいい天気ですね | お、     | 等幅になった 👍 |

;; Japanese font settings
(defun set-japanese-font (family)
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208        (font-spec :family family))
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0212        (font-spec :family family))
  (set-fontset-font (frame-parameter nil 'font) 'katakana-jisx0201        (font-spec :family family)))

;; in macOS
(when (eq system-type 'darwin)
  (setq default-font-family "Menlo")
  (setq jp-font-family "Hiragino Kaku Gothic Pro")
  (set-face-attribute 'default nil :family default-font-family :height 120))


(set-japanese-font jp-font-family)
(add-to-list 'face-font-rescale-alist (cons default-font-family 1.0))
(add-to-list 'face-font-rescale-alist (cons jp-font-family 1.0))


;;
;; Shell
;;

(use-package exec-path-from-shell
  :custom
  (exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-variables '("PATH" "GOPATH"))
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))


;;
;; macOS
;;

(when (equal system-type 'darwin)
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super)
  (setq ns-auto-hide-menu-bar t)
  (setq ns-use-proxy-icon nil)
  (setq initial-frame-alist
        (append
         '((ns-transparent-titlebar . t)
           (ns-appearance . dark)
           (vertical-scroll-bars . nil)
           (internal-border-width . 0)))))
;; pbcopy
(use-package pbcopy
  :if (eq system-type 'darwin)
  :hook (dashboard-mode . (turn-on-pbcopy)))


;;
;; icons
;;

(use-package all-the-icons)


;;
;; posframe
;;
(use-package posframe)


;;
;; pointer
;;

(use-package popwin)
(use-package point-history
  :load-path "~/.emacs.d/public_repos/point-history"
  :init
  (add-hook 'after-init-hook 'point-history-mode)
  :config
  (setq point-history-ignore-buffer "\\*[a-zA-Z0-9]")
  (setq point-history-ignore-major-mode '(dired-mode direx:direx-mode)))


;;
;; mouse
;;
(xterm-mouse-mode t)


;;
;; which-key
;;

(use-package which-key
  :diminish which-key-mode
  :hook (after-init . which-key-mode))


;;
;; hydra
;;

(use-package hydra
  :config
  (use-package hydra-posframe
    :load-path "~/.emacs.d/public_repos/hydra-posframe"
    :custom
    (hydra-posframe-parameters
     '((left-fringe . 5)
       (right-fringe . 5)))
    :custom-face
    (hydra-posframe-border-face ((t (:background "#6272a4"))))
    :hook (after-init . hydra-posframe-enable)))


;;
;; undo / redo
;;

(use-package undo-tree
  :bind
  ("M-/" . undo-tree-redo)
  :config
  (global-undo-tree-mode))

(use-package undohist
  :ensure t
  :config
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG" "/elpa"))
  (undohist-initialize))


;;
;; projectile
;;

(use-package projectile
  :ensure t
  :diminish
  :bind
  ("M-o p" . counsel-projectile-switch-project)
  :config
  (projectile-mode +1)
  (setq projectile-enable-caching t))


;;
;; Version control
;;

(use-package magit
  :ensure t
  :custom
  (magit-auto-revert-mode nil)
  :bind
  ("M-g s" . magit-status))

(use-package git-gutter
  :ensure t
  :custom
  (git-gutter:modified-sign "~")
  (git-gutter:added-sign    "+")
  (git-gutter:deleted-sign  "-")
  :custom-face
  (git-gutter:modified ((t (:foreground "#f1fa8c" :background "#f1fa8c"))))
  (git-gutter:added    ((t (:foreground "#50fa7b" :background "#50fa7b"))))
  (git-gutter:deleted  ((t (:foreground "#ff79c6" :background "#ff79c6"))))
  :config
  (global-git-gutter-mode +1))

(use-package git-timemachine
  :bind ("M-g t" . git-timemachine-toggle))

(use-package gitattributes-mode :defer t)
(use-package gitconfig-mode :defer t)
(use-package gitignore-mode :defer t)

(use-package browse-at-remote
  :bind ("M-g r" . browse-at-remote))

(use-package github-pullrequest)

(use-package diffview
  :commands (diffview-region diffview-current)
  :preface
  (defun ladicle/diffview-dwim ()
    (interactive)
    (if (region-active-p)
        (diffview-region)
      (diffview-current)))
  :bind ("M-g v" . ladicle/diffview-dwim))

(use-package smerge-mode
  :diminish
  :preface
  (with-eval-after-load 'hydra
    (defhydra smerge-hydra
      (:color pink :hint nil :post (smerge-auto-leave))
      "
^Move^       ^Keep^               ^Diff^                 ^Other^
^^-----------^^-------------------^^---------------------^^-------
_n_ext       _b_ase               _<_: upper/base        _C_ombine
_p_rev       _u_pper              _=_: upper/lower       _r_esolve
^^           _l_ower              _>_: base/lower        _k_ill current
^^           _a_ll                _R_efine
^^           _RET_: current       _E_diff
"
      ("n" smerge-next)
      ("p" smerge-prev)
      ("b" smerge-keep-base)
      ("u" smerge-keep-upper)
      ("l" smerge-keep-lower)
      ("a" smerge-keep-all)
      ("RET" smerge-keep-current)
      ("\C-m" smerge-keep-current)
      ("<" smerge-diff-base-upper)
      ("=" smerge-diff-upper-lower)
      (">" smerge-diff-base-lower)
      ("R" smerge-refine)
      ("E" smerge-ediff)
      ("C" smerge-combine-with-next)
      ("r" smerge-resolve)
      ("k" smerge-kill-current)
      ("ZZ" (lambda ()
              (interactive)
              (save-buffer)
              (bury-buffer))
       "Save and bury buffer" :color blue)
      ("q" nil "cancel" :color blue)))
  :hook ((find-file . (lambda ()
                        (save-excursion
                          (goto-char (point-min))
                          (when (re-search-forward "^<<<<<<< " nil t)
                            (smerge-mode 1)))))
         (magit-diff-visit-file . (lambda ()
                                    (when smerge-mode
                                      (smerge-hydra/body))))))


;;
;; tramp
;;

(add-to-list 'backup-directory-alist
	     (cons tramp-file-name-regexp nil))

;;
;; Ag
;;

(use-package ag
  :custom
  (ag-highligh-search t)
  (ag-reuse-buffers t)
  (ag-reuse-window t)
  :bind
  ("M-s a" . ag-project)
  :config
  (use-package wgrep-ag))


;;
;; ivy & counsel
;;

(use-package counsel
  :diminish ivy-mode counsel-mode
  :defines
  (projectile-completion-system magit-completing-read-function)
  :bind
  (("C-s" . swiper)
   ("M-s r" . ivy-resume)
   ("C-c v p" . ivy-push-view)
   ("C-c v o" . ivy-pop-view)
   ("C-c v ." . ivy-switch-view)
   ("M-s c" . counsel-ag)
   ("M-o f" . counsel-fzf)
   ("M-o r" . counsel-recentf)
   ("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("C-w" . ivy-backward-kill-word)
   ("C-k" . ivy-kill-line)
   ("C-j" . ivy-immediate-done)
   ("RET" . ivy-alt-done)
   ("C-h" . ivy-backward-delete-char))
  :preface
  (defun ivy-format-function-pretty (cands)
    "Transform CANDS into a string for minibuffer."
    (ivy--format-function-generic
     (lambda (str)
       (concat
        (all-the-icons-faicon "hand-o-right" :height .85 :v-adjust .05 :face 'font-lock-constant-face)
        (ivy--add-face str 'ivy-current-match)))
     (lambda (str)
       (concat "  " str))
     cands
     "\n"))
  :hook
  (after-init . ivy-mode)
  (ivy-mode . counsel-mode)
  :custom
  (counsel-yank-pop-height 15)
  (enable-recursive-minibuffers t)
  (ivy-use-selectable-prompt t)
  (ivy-use-virtual-buffers t)
  (ivy-on-del-error-function nil)
  (swiper-action-recenter t)
  (counsel-grep-base-command "ag -S --noheading --nocolor --nofilename --numbers '%s' %s")
  :config
  ;; using ivy-format-fuction-arrow with counsel-yank-pop
  (advice-add
   'counsel--yank-pop-format-function
   :override
   (lambda (cand-pairs)
     (ivy--format-function-generic
      (lambda (str)
        (mapconcat
         (lambda (s)
           (ivy--add-face (concat (propertize "┃ " 'face `(:foreground "#61bfff")) s) 'ivy-current-match))
         (split-string
          (counsel--yank-pop-truncate str) "\n" t)
         "\n"))
      (lambda (str)
        (counsel--yank-pop-truncate str))
      cand-pairs
      counsel-yank-pop-separator)))
  ;; NOTE: this variable do not work if defined in :custom
  (setq ivy-format-function 'ivy-format-function-pretty)
  (setq counsel-yank-pop-separator
        (propertize "\n────────────────────────────────────────────────────────\n"
		    'face `(:foreground "#6272a4")))
  ;; Integration with `projectile'
  (with-eval-after-load 'projectile
    (setq projectile-completion-system 'ivy))
  ;; Integration with `magit'
  (with-eval-after-load 'magit
    (setq magit-completing-read-function 'ivy-completing-read))
  ;; Enhance fuzzy matching
  (use-package flx)
  ;; Enhance M-x
  (use-package amx)
  ;; Ivy integration for Projectile
  (use-package counsel-projectile
    :config (counsel-projectile-mode 1))
  ;; Show ivy frame using posframe
  (use-package ivy-posframe
    :ensure t
    :after ivy
    :custom-face
    (ivy-posframe ((t (:background "#333333"))))
    (ivy-posframe-border ((t (:background "#ffffff"))))
    (ivy-posframe-cursor ((t (:background "#61bfff"))))
    :custom
    (ivy-display-function #'ivy-posframe-display-at-frame-center)
    (ivy-posframe-parameters
     '((left-fringe . 5)
       (right-fringe . 5)))
    :config
    (ivy-posframe-enable))
  ;; More friendly display transformer for Ivy
  (use-package ivy-rich
    :defines (all-the-icons-dir-icon-alist bookmark-alist)
    :functions (all-the-icons-icon-family
                all-the-icons-match-to-alist
                all-the-icons-auto-mode-match?
                all-the-icons-octicon
                all-the-icons-dir-is-submodule)
    :preface
    (defun ivy-rich-bookmark-name (candidate)
      (car (assoc candidate bookmark-alist)))
    (defun ivy-rich-repo-icon (candidate)
      "Display repo icons in `ivy-rich`."
      (all-the-icons-octicon "repo" :height .9))
    (defun ivy-rich-org-capture-icon (candidate)
      "Display repo icons in `ivy-rich`."
      (pcase (car (last (split-string (car (split-string candidate)) "-")))
        ("emacs" (all-the-icons-fileicon "emacs" :height .68 :v-adjust .001))
        ("schedule" (all-the-icons-faicon "calendar" :height .68 :v-adjust .005))
        ("tweet" (all-the-icons-faicon "commenting" :height .7 :v-adjust .01))
        ("link" (all-the-icons-faicon "link" :height .68 :v-adjust .01))
        ("memo" (all-the-icons-faicon "pencil" :height .7 :v-adjust .01))
        (_       (all-the-icons-octicon "inbox" :height .68 :v-adjust .01))
        ))
    (defun ivy-rich-org-capture-title (candidate)
      (let* ((octl (split-string candidate))
             (title (pop octl))
             (desc (mapconcat 'identity octl " ")))
        (format "%-25s %s"
                title
                (propertize desc 'face `(:inherit font-lock-doc-face)))))
    (defun ivy-rich-buffer-icon (candidate)
      "Display buffer icons in `ivy-rich'."
      (when (display-graphic-p)
	(when-let* ((buffer (get-buffer candidate))
                    (major-mode (buffer-local-value 'major-mode buffer))
                    (icon (if (and (buffer-file-name buffer)
                                   (all-the-icons-auto-mode-match? candidate))
                              (all-the-icons-icon-for-file candidate)
			    (all-the-icons-icon-for-mode major-mode))))
	  (if (symbolp icon)
	      (setq icon (all-the-icons-icon-for-mode 'fundamental-mode)))
	  (unless (symbolp icon)
	    (propertize icon
			'face `(
				:height 1.1
				:family ,(all-the-icons-icon-family icon)
				))))))
    (defun ivy-rich-file-icon (candidate)
      "Display file icons in `ivy-rich'."
      (when (display-graphic-p)
        (let ((icon (if (file-directory-p candidate)
                        (cond
                         ((and (fboundp 'tramp-tramp-file-p)
                               (tramp-tramp-file-p default-directory))
                          (all-the-icons-octicon "file-directory"))
                         ((file-symlink-p candidate)
                          (all-the-icons-octicon "file-symlink-directory"))
                         ((all-the-icons-dir-is-submodule candidate)
                          (all-the-icons-octicon "file-submodule"))
                         ((file-exists-p (format "%s/.git" candidate))
                          (all-the-icons-octicon "repo"))
                         (t (let ((matcher (all-the-icons-match-to-alist candidate all-the-icons-dir-icon-alist)))
			      (apply (car matcher) (list (cadr matcher))))))
		      (all-the-icons-icon-for-file candidate))))
	  (unless (symbolp icon)
	    (propertize icon
			'face `(
                                :height 1.1
                                :family ,(all-the-icons-icon-family icon)
                                ))))))
    :hook (ivy-rich-mode . (lambda ()
                             (setq ivy-virtual-abbreviate
                                   (or (and ivy-rich-mode 'abbreviate) 'name))))
    :init
    (setq ivy-rich-display-transformers-list
          '(ivy-switch-buffer
            (:columns
             ((ivy-rich-buffer-icon)
              (ivy-rich-candidate (:width 30))
              (ivy-rich-switch-buffer-size (:width 7))
              (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
              (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
              (ivy-rich-switch-buffer-project (:width 15 :face success))
              (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
             :predicate
             (lambda (cand) (get-buffer cand)))
            ivy-switch-buffer-other-window
            (:columns
             ((ivy-rich-buffer-icon)
              (ivy-rich-candidate (:width 30))
              (ivy-rich-switch-buffer-size (:width 7))
              (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
              (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
              (ivy-rich-switch-buffer-project (:width 15 :face success))
              (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
             :predicate
             (lambda (cand) (get-buffer cand)))
            counsel-M-x
            (:columns
             ((counsel-M-x-transformer (:width 40))
              (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
            counsel-describe-function
            (:columns
             ((counsel-describe-function-transformer (:width 45))
              (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
            counsel-describe-variable
            (:columns
             ((counsel-describe-variable-transformer (:width 45))
              (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))
            counsel-find-file
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-file-jump
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-dired-jump
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-git
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-recentf
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate (:width 110))))
            counsel-bookmark
            (:columns
             ((ivy-rich-bookmark-type)
              (ivy-rich-bookmark-name (:width 30))
              (ivy-rich-bookmark-info (:width 80))))
            counsel-projectile-switch-project
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-fzf
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            ivy-ghq-open
            (:columns
             ((ivy-rich-repo-icon)
              (ivy-rich-candidate)))
            ivy-ghq-open-and-fzf
            (:columns
             ((ivy-rich-repo-icon)
              (ivy-rich-candidate)))
            counsel-projectile-find-file
            (:columns
             ((ivy-rich-file-icon)
              (ivy-rich-candidate)))
            counsel-org-capture
            (:columns
             ((ivy-rich-org-capture-icon)
              (ivy-rich-org-capture-title)
              ))
            counsel-projectile-find-dir
            (:columns
             ((ivy-rich-file-icon)
              (counsel-projectile-find-dir-transformer)))))

    (setq ivy-rich-parse-remote-buffer nil)
    :config
    (ivy-rich-mode 1))
  )

;;
;; anzu
;;

(use-package anzu
  :diminish
  :bind
  ("C-r"   . anzu-query-replace-regexp)
  ("C-M-r" . anzu-query-replace-at-cursor-thing)
  :hook
  (after-init . global-anzu-mode))


;;
;; migemo: search japanese by roma input
;;

(use-package migemo
  :custom
  (migemo-command "/usr/local/bin/cmigemo")
  (migemo-options '("-q" "--emacs"))
  (migemo-user-dictionary nil)
  (migemo-regex-dictionary nil)
  (migemo-coding-system 'utf-8-unix)
  (migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  :config
  (when (eq system-type 'darwin)
    (setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict"))
  (migemo-init)
  (use-package avy-migemo
    :after swiper
    :config
    ;; (avy-migemo-mode 1)
    (require 'avy-migemo-e.g.swiper))
  )


;;
;; multiple cursors
;;

(use-package multiple-cursors
  :functions hydra-multiple-cursors
  :bind
  ("M-u" . hydra-multiple-cursors/body)
  :preface
  ;; insert specific serial number
  (defvar ladicle/mc/insert-numbers-hist nil)
  (defvar ladicle/mc/insert-numbers-inc 1)
  (defvar ladicle/mc/insert-numbers-pad "%01d")

  (defun ladicle/mc/insert-numbers (start inc pad)
    "Insert increasing numbers for each cursor specifically."
    (interactive
     (list (read-number "Start from: " 0)
           (read-number "Increment by: " 1)
           (read-string "Padding (%01d): " nil ladicle/mc/insert-numbers-hist "%01d")))
    (setq mc--insert-numbers-number start)
    (setq ladicle/mc/insert-numbers-inc inc)
    (setq ladicle/mc/insert-numbers-pad pad)
    (mc/for-each-cursor-ordered
     (mc/execute-command-for-fake-cursor
      'ladicle/mc--insert-number-and-increase
      cursor)))

  (defun ladicle/mc--insert-number-and-increase ()
    (interactive)
    (insert (format ladicle/mc/insert-numbers-pad mc--insert-numbers-number))
    (setq mc--insert-numbers-number (+ mc--insert-numbers-number ladicle/mc/insert-numbers-inc)))

  :config
  (with-eval-after-load 'hydra
    (defhydra hydra-multiple-cursors (:color pink :hint nil)
      "
                                                                        ╔════════╗
    Point^^^^^^             Misc^^            Insert                            ║ Cursor ║
  ──────────────────────────────────────────────────────────────────────╨────────╜
     _k_    _K_    _M-k_    [_l_] edit lines  [_i_] 0...
     ^↑^    ^↑^     ^↑^     [_m_] mark all    [_a_] letters
    mark^^ skip^^^ un-mk^   [_s_] sort        [_n_] numbers
     ^↓^    ^↓^     ^↓^
     _j_    _J_    _M-j_
  ╭──────────────────────────────────────────────────────────────────────────────╯
                           [_q_]: quit, [Click]: point
"
      ("l" mc/edit-lines :exit t)
      ("m" mc/mark-all-like-this :exit t)
      ("j" mc/mark-next-like-this)
      ("J" mc/skip-to-next-like-this)
      ("M-j" mc/unmark-next-like-this)
      ("k" mc/mark-previous-like-this)
      ("K" mc/skip-to-previous-like-this)
      ("M-k" mc/unmark-previous-like-this)
      ("s" mc/mark-all-in-region-regexp :exit t)
      ("i" mc/insert-numbers :exit t)
      ("a" mc/insert-letters :exit t)
      ("n" ladicle/mc/insert-numbers :exit t)
      ("<mouse-1>" mc/add-cursor-on-click)
      ;; Help with click recognition in this hydra
      ("<down-mouse-1>" ignore)
      ("<drag-mouse-1>" ignore)
      ("q" nil))))


;;
;; avy/ace : smart cursor movements
;;

(use-package avy
  :functions (hydra-avy hydra-viewer)
  :bind
  ("C-'"   . avy-resume)
  ("C-:"   . avy-goto-char-2-below)
  ("C-;"   . avy-goto-char)
  ("M-j"   . hydra-avy/body)
  ("C-M-v" . hydra-viewer/body)
  :preface
  ;; fixed cursor scroll-up
  (defun scroll-up-in-place (n)
    (interactive "p")
    (forward-line (- n))
    (scroll-down n))
  ;; fixed cursor scroll-down
  (defun scroll-down-in-place (n)
    (interactive "p")
    (forward-line n)
    (scroll-up n))
  ;; yank inner sexp
  (defun yank-inner-sexp ()
    (interactive)
    (backward-list)
    (mark-sexp)
    (copy-region-as-kill (region-beginning) (region-end)))
  :config
  (when (eq system-type 'darwin)
    (progn
      (global-set-key (kbd "C-:") 'avy-goto-char)
      (global-set-key (kbd "C-;") 'avy-goto-char-2-below)))

  (use-package avy-zap
    :bind
    ("M-z" . avy-zap-to-char-dwim)
    ("M-z" . avy-zap-up-to-char-dwim))

  (with-eval-after-load 'hydra
    (defhydra hydra-viewer (:color pink :hint nil)
      "
                                                                        ╔════════╗
   Char/Line^^^^^^  Word/Page^^^^^^^^  Line/Buff^^^^   Paren                              ║ Window ║
  ──────────────────────────────────────────────────────────────────────╨────────╜
       ^^_k_^^          ^^_u_^^          ^^_g_^^       _(_ ← _y_ → _)_
       ^^^↑^^^          ^^^↑^^^          ^^^↑^^^       _,_ ← _/_ → _._
   _h_ ← _d_ → _l_  _H_ ← _D_ → _L_  _a_ ← _K_ → _e_
       ^^^↓^^^          ^^^↓^^^          ^^^↓^
       ^^_j_^^          ^^_n_^^          ^^_G_
  ╭──────────────────────────────────────────────────────────────────────────────╯
                           [_q_]: quit, [_<SPC>_]: center
          "
      ("j" scroll-down-in-place)
      ("k" scroll-up-in-place)
      ("l" forward-char)
      ("d" delete-char)
      ("h" backward-char)
      ("L" forward-word)
      ("H" backward-word)
      ("u" scroll-up-command)
      ("n" scroll-down-command)
      ("D" delete-word-at-point)
      ("a" mwim-beginning-of-code-or-line)
      ("e" mwim-end-of-code-or-line)
      ("g" beginning-of-buffer)
      ("G" end-of-buffer)
      ("K" kill-whole-line)
      ("(" backward-list)
      (")" forward-list)
      ("y" yank-inner-sexp)
      ("." backward-forward-next-location)
      ("," backward-forward-previous-location)
      ("/" avy-goto-char :exit t)
      ("<SPC>" recenter-top-bottom)
      ("q" nil))

    (defhydra hydra-avy (:color pink :hint nil)
      "
                                                                        ╔════════╗
        ^^Goto^^        Kill^^        Yank^^        Move^^        Misc            ║  Jump  ║
  ──────────────────────────────────────────────────────────────────────╨────────╜
    _c_ ← char^^        [_k_] region  [_y_] region  [_m_] region  [_n_] line number
    _a_ ← char2 → _b_   [_K_] line    [_Y_] line    [_M_] line    [_v_] Goto viewer
    _w_ ← word  → _W_   [_z_] zap^^^^                             [_o_] Goto clock
    _l_ ← line  → _e_   ^^^^^                                     _,_ ← f!y → _._
  ╭──────────────────────────────────────────────────────────────────────────────╯
                      [_q_]: quit, [_i_]: imenu, [_<SPC>_]: resume
"
      ("c" avy-goto-char :exit t)
      ("a" avy-goto-char-2 :exit t)
      ("b" avy-goto-char-below :exit t)
      ("w" avy-goto-word-1 :exit t)
      ("W" avy-goto-word-1-below :exit t)
      ("l" avy-goto-line :exit t)
      ("e" avy-goto-end-of-line :exit t)
      ("M" avy-move-line)
      ("m" avy-move-region)
      ("K" avy-kill-whole-line)
      ("k" avy-kill-region)
      ("Y" avy-copy-line :exit t)
      ("y" avy-copy-region :exit t)
      ("n" goto-line :exit t)
      ("o" org-clock-jump-to-current-clock :exit t)
      ("z" avy-zap-to-char-dwim :exit t)
      ("v" hydra-viewer/body :exit t)
      ("<SPC>" avy-resume :exit t)
      ("o" org-clock-jump-to-current-clock :exit t)
      ("i" counsel-imenu :exit t)
      ("," flymake-goto-previous-error)
      ("." flymake-goto-next-error)
      ("q" nil))))

(use-package ace-window
  :functions hydra-frame-window/body
  :bind
  ("C-M-o" . hydra-frame-window/body)
  ("M-t m" . ladicle/toggle-window-maximize)
  :custom
  (aw-keys '(?j ?k ?l ?i ?o ?h ?y ?u ?p))
  :custom-face
  (aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c"))))
  :preface
  (defvar is-window-maximized nil)
  (defun ladicle/toggle-window-maximize ()
    (interactive)
    (progn
      (if is-window-maximized
          (balance-windows)
        (maximize-window))
      (setq is-window-maximized
            (not is-window-maximized))))
  (defun hydra-title(title) (propertize title 'face `(:inherit font-lock-warning-face :weight bold)))
  (defun command-name(title) (propertize title 'face `(:foreground "#f8f8f2")))
  (defun spacer() (propertize "." 'face `(:foreground "#282a36")))
  :config
  (use-package rotate
    :load-path "~/Developments/src/github.com/Ladicle/dotfiles/common/emacs.d/elisp/emacs-rotate"
    :bind
    ("M-o SPC" . rotate-layout))
  (with-eval-after-load 'hydra
    (defhydra hydra-frame-window (:color blue :hint nil)
      (format
       (format "%s" (propertize "                                                                       ╔════════╗
    ((%s))^^^^^^^^   ((%s))^^^^  ((%s))^^  ((%s))^^  ((%s))^^^^^^  ((%s))^   ║ Window ║
^^^^^^ ──────────────────────────────────────────────────────────────────────╨────────╜
        ^_k_^        %s_+_         _-_       %s     _,_ ← %s → _._^  %s
        ^^↑^^          ^↑^         ^↑^       %s
    _h_ ←   → _l_   ^^%s%s^^^^^    ^%s    ^^^%s^^^^     %s
        ^^↓^^          ^↓^         ^↓^       %s^^       %s
        ^_j_^        %s_=_         _/_       %s
^^^^^^ ┌──────────────────────────────────────────────────────────────────────────────┘
                           [_q_]: %s, [_<SPC>_]: %s" 'face `(:inherit font-lock-doc-face)))
       (hydra-title "Size")
       (hydra-title "Zoom")
       (hydra-title "Split")
       (hydra-title "Window")
       (hydra-title "Buffer")
       (hydra-title "Misc")
       (all-the-icons-material "zoom_in" :height .85 :face 'font-lock-doc-face)
       (command-name "_o_ther")
       (command-name "page")
       (command-name "_r_centf")
       (command-name "_s_wap")
       (all-the-icons-faicon "slideshare" :height .85 :face 'font-lock-doc-face)
       (command-name "_p_mode")
       (command-name "w_i_ndow")
       (command-name "_m_aximize")
       (command-name "_s_witch")
       (command-name "_d_elete")
       (command-name "_D_elete")
       (all-the-icons-material "zoom_out" :height .85 :face 'font-lock-doc-face)
       (command-name "del_O_thers")
       (command-name "quit")
       (command-name "rotate")
       )

      ("K" kill-current-buffer :exit t)
      ("D" kill-buffer-and-window :exit t)
      ("O" delete-other-windows  :exit t)
      ("F" toggle-frame-fullscreen)
      ("i" ace-window)
      ("s" ace-swap-window :exit t)
      ("d" ace-delete-window)
      ("m" ladicle/toggle-window-maximize :exit t)
      ("=" text-scale-decrease)
      ("+" text-scale-increase)
      ("-" split-window-vertically)
      ("/" split-window-horizontally)
      ("h" shrink-window-horizontally)
      ("k" shrink-window)
      ("j" enlarge-window)
      ("l" enlarge-window-horizontally)
      ("," previous-buffer)
      ("." next-buffer)
      ("o" other-window)
      ("p" presentation-mode)
      ("r" counsel-recentf :exit t)
      ("s" switch-to-buffer :exit t)
      ("D" kill-buffer-and-window)
      ("<SPC>" rotate-layout)
      ("q" nil))))

;;
;; smart move
;;

(use-package mwim
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))


;;
;; flymake
;;

(use-package flymake-posframe
  :load-path "~/.emacs.d/public_repos/flymake-posframe"
  :custom
  (flymake-posframe-error-prefix " ")
  :custom-face
  (flymake-posframe-foreground-face ((t (:foreground "white"))))
  :hook (flymake-mode . flymake-posframe-mode))

(use-package flymake-diagnostic-at-point
  :disabled
  :after flymake
  :custom
  (flymake-diagnostic-at-point-timer-delay 0.1)
  (flymake-diagnostic-at-point-error-prefix " ")
  (flymake-diagnostic-at-point-display-diagnostic-function 'flymake-diagnostic-at-point-display-popup) ;; or flymake-diagnostic-at-point-display-minibuffer
  :hook
  (flymake-mode . flymake-diagnostic-at-point-mode))


;;
;; flyspell
;;

(use-package flyspell
  :diminish
  :if (executable-find "aspell")
  :hook
  ((org-mode yaml-mode markdown-mode git-commit-mode) . flyspell-mode)
  (prog-mode . flyspell-prog-mode)
  (before-save-hook . flyspell-buffer)
  (flyspell-mode . (lambda ()
                     (dolist (key '("C-;" "C-," "C-."))
                       (unbind-key key flyspell-mode-map))))
  :custom
  (flyspell-issue-message-flag nil)
  (ispell-program-name "aspell")
  (ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together"))
  :custom-face
  (flyspell-incorrect ((t (:underline (:color "#f1fa8c" :style wave)))))
  (flyspell-duplicate ((t (:underline (:color "#50fa7b" :style wave)))))
  :preface
  (defun message-off-advice (oldfun &rest args)
    "Quiet down messages in adviced OLDFUN."
    (let ((message-off (make-symbol "message-off")))
      (unwind-protect
          (progn
            (advice-add #'message :around #'ignore (list 'name message-off))
            (apply oldfun args))
        (advice-remove #'message message-off))))
  :config
  (advice-add #'ispell-init-process :around #'message-off-advice)
  (use-package flyspell-correct-ivy
    :bind ("C-M-:" . flyspell-correct-at-point)
    :config
    (when (eq system-type 'darwin)
      (progn
        (global-set-key (kbd "C-M-;") 'flyspell-correct-at-point)))
    (setq flyspell-correct-interface #'flyspell-correct-ivy)))

;;
;; Yasnippet
;;

(use-package yasnippet
  :diminish yas-minor-mode
  :custom (yas-snippet-dirs '("~/.emacs.d/snippets"))
  :hook (after-init . yas-global-mode))

;;
;; Company
;;

(use-package company
  :diminish company-mode
  :defines
  (company-dabbrev-ignore-case company-dabbrev-downcase)
  :bind
  (:map company-active-map
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous)
        ("<tab>" . company-complete-common-or-cycle)
        :map company-search-map
        ("C-p" . company-select-previous)
        ("C-n" . company-select-next))
  :custom
  (company-idle-delay 0)
  (company-echo-delay 0)
  (company-minimum-prefix-length 1)
  :hook
  (after-init . global-company-mode)
  (plantuml-mode . (lambda () (set (make-local-variable 'company-backends)
                                   '((company-yasnippet
                                      ;; company-dabbrev
                                      )))))
  ((go-mode
    c++-mode
    c-mode
    objc-mode) . (lambda () (set (make-local-variable 'company-backends)
                                 '((company-yasnippet
                                    company-lsp
                                    company-files
                                    ;; company-dabbrev-code
                                    )))))
  :config
  ;; using child frame
  (use-package company-posframe
    :hook (company-mode . company-posframe-mode))
  ;; Show pretty icons
  (use-package company-box
    :diminish
    :hook (company-mode . company-box-mode)
    :init (setq company-box-icons-alist 'company-box-icons-all-the-icons)
    :config
    (setq company-box-backends-colors nil)
    (setq company-box-show-single-candidate t)
    (setq company-box-max-candidates 50)

    (defun company-box-icons--elisp (candidate)
      (when (derived-mode-p 'emacs-lisp-mode)
        (let ((sym (intern candidate)))
          (cond ((fboundp sym) 'Function)
                ((featurep sym) 'Module)
                ((facep sym) 'Color)
                ((boundp sym) 'Variable)
                ((symbolp sym) 'Text)
                (t . nil)))))

    (with-eval-after-load 'all-the-icons
      (declare-function all-the-icons-faicon 'all-the-icons)
      (declare-function all-the-icons-fileicon 'all-the-icons)
      (declare-function all-the-icons-material 'all-the-icons)
      (declare-function all-the-icons-octicon 'all-the-icons)
      (setq company-box-icons-all-the-icons
            `((Unknown . ,(all-the-icons-material "find_in_page" :height 0.7 :v-adjust -0.15))
              (Text . ,(all-the-icons-faicon "book" :height 0.68 :v-adjust -0.15))
              (Method . ,(all-the-icons-faicon "cube" :height 0.7 :v-adjust -0.05 :face 'font-lock-constant-face))
              (Function . ,(all-the-icons-faicon "cube" :height 0.7 :v-adjust -0.05 :face 'font-lock-constant-face))
              (Constructor . ,(all-the-icons-faicon "cube" :height 0.7 :v-adjust -0.05 :face 'font-lock-constant-face))
              (Field . ,(all-the-icons-faicon "tags" :height 0.65 :v-adjust -0.15 :face 'font-lock-warning-face))
              (Variable . ,(all-the-icons-faicon "tag" :height 0.7 :v-adjust -0.05 :face 'font-lock-warning-face))
              (Class . ,(all-the-icons-faicon "clone" :height 0.65 :v-adjust 0.01 :face 'font-lock-constant-face))
              (Interface . ,(all-the-icons-faicon "clone" :height 0.65 :v-adjust 0.01))
              (Module . ,(all-the-icons-octicon "package" :height 0.7 :v-adjust -0.15))
              (Property . ,(all-the-icons-octicon "package" :height 0.7 :v-adjust -0.05 :face 'font-lock-warning-face)) ;; Golang module
              (Unit . ,(all-the-icons-material "settings_system_daydream" :height 0.7 :v-adjust -0.15))
              (Value . ,(all-the-icons-material "format_align_right" :height 0.7 :v-adjust -0.15 :face 'font-lock-constant-face))
              (Enum . ,(all-the-icons-material "storage" :height 0.7 :v-adjust -0.15 :face 'all-the-icons-orange))
              (Keyword . ,(all-the-icons-material "filter_center_focus" :height 0.7 :v-adjust -0.15))
              (Snippet . ,(all-the-icons-faicon "code" :height 0.7 :v-adjust 0.02 :face 'font-lock-variable-name-face))
              (Color . ,(all-the-icons-material "palette" :height 0.7 :v-adjust -0.15))
              (File . ,(all-the-icons-faicon "file-o" :height 0.7 :v-adjust -0.05))
              (Reference . ,(all-the-icons-material "collections_bookmark" :height 0.7 :v-adjust -0.15))
              (Folder . ,(all-the-icons-octicon "file-directory" :height 0.7 :v-adjust -0.05))
              (EnumMember . ,(all-the-icons-material "format_align_right" :height 0.7 :v-adjust -0.15 :face 'all-the-icons-blueb))
              (Constant . ,(all-the-icons-faicon "tag" :height 0.7 :v-adjust -0.05))
              (Struct . ,(all-the-icons-faicon "clone" :height 0.65 :v-adjust 0.01 :face 'font-lock-constant-face))
              (Event . ,(all-the-icons-faicon "bolt" :height 0.7 :v-adjust -0.05 :face 'all-the-icons-orange))
              (Operator . ,(all-the-icons-fileicon "typedoc" :height 0.65 :v-adjust 0.05))
              (TypeParameter . ,(all-the-icons-faicon "hashtag" :height 0.65 :v-adjust 0.07 :face 'font-lock-const-face))
              (Template . ,(all-the-icons-faicon "code" :height 0.7 :v-adjust 0.02 :face 'font-lock-variable-name-face))))))
  ;; Show quick tooltip
  (use-package company-quickhelp
    :defines company-quickhelp-delay
    :bind (:map company-active-map
                ("M-h" . company-quickhelp-manual-begin))
    :hook (global-company-mode . company-quickhelp-mode)
    :custom (company-quickhelp-delay 0.8)))


;;
;; lsp
;;

(use-package lsp-mode
  :custom
  ;; debug
  (lsp-print-io nil)
  (lsp-trace nil)
  (lsp-print-performance nil)
  ;; general
  (lsp-auto-guess-root t)
  (lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
  (lsp-response-timeout 10)
  (lsp-prefer-flymake t) ;; t(flymake), nil(lsp-ui), or :none
  ;; go-client
  (lsp-clients-go-server-args '("--cache-style=always" "--diagnostics-style=onsave" "--format-style=goimports"))
  :hook
  ((go-mode c-mode c++-mode) . lsp)
  :bind
  (:map lsp-mode-map
        ("C-c r"   . lsp-rename))
  :config
  (require 'lsp-clients)
  ;; LSP UI tools
  (use-package lsp-ui
    :custom
    ;; lsp-ui-doc
    (lsp-ui-doc-enable nil)
    (lsp-ui-doc-header t)
    (lsp-ui-doc-include-signature nil)
    (lsp-ui-doc-position 'at-point) ;; top, bottom, or at-point
    (lsp-ui-doc-max-width 120)
    (lsp-ui-doc-max-height 30)
    (lsp-ui-doc-use-childframe t)
    (lsp-ui-doc-use-webkit t)
    ;; lsp-ui-flycheck
    (lsp-ui-flycheck-enable nil)
    ;; lsp-ui-sideline
    (lsp-ui-sideline-enable nil)
    (lsp-ui-sideline-ignore-duplicate t)
    (lsp-ui-sideline-show-symbol t)
    (lsp-ui-sideline-show-hover t)
    (lsp-ui-sideline-show-diagnostics nil)
    (lsp-ui-sideline-show-code-actions t)
    (lsp-ui-sideline-code-actions-prefix "")
    ;; lsp-ui-imenu
    (lsp-ui-imenu-enable t)
    (lsp-ui-imenu-kind-position 'top)
    ;; lsp-ui-peek
    (lsp-ui-peek-enable t)
    (lsp-ui-peek-peek-height 20)
    (lsp-ui-peek-list-width 50)
    (lsp-ui-peek-fontify 'on-demand) ;; never, on-demand, or always
    :preface
    (defun ladicle/toggle-lsp-ui-doc ()
      (interactive)
      (if lsp-ui-doc-mode
          (progn
            (lsp-ui-doc-mode -1)
            (lsp-ui-doc--hide-frame))
        (lsp-ui-doc-mode 1)))
    :bind
    (:map lsp-mode-map
          ("C-c C-r" . lsp-ui-peek-find-references)
          ("C-c C-j" . lsp-ui-peek-find-definitions)
          ("C-c i"   . lsp-ui-peek-find-implementation)
          ("C-c m"   . lsp-ui-imenu)
          ("C-c s"   . lsp-ui-sideline-mode)
          ("C-c d"   . ladicle/toggle-lsp-ui-doc))
    :hook
    (lsp-mode . lsp-ui-mode))
  ;; Lsp completion
  (use-package company-lsp
    :custom
    (company-lsp-cache-candidates t) ;; auto, t(always using a cache), or nil
    (company-lsp-async t)
    (company-lsp-enable-snippet t)
    (company-lsp-enable-recompletion t)))



;;
;; C, C++
;;

(use-package cc-mode
  :bind (:map c-mode-base-map
              ("C-c c" . compile))
  :hook (c-mode-common . (lambda ()
                           (c-set-style "bsd")
                           (setq tab-width 4)
                           (setq c-base-offset 4))))
(use-package ccls
  :custom
  (ccls-executable "/usr/local/bin/ccls")
  (ccls-sem-highlight-method 'font-lock)
  :config
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))


;;
;; Web
;;

(use-package js2-mode
  :mode ("\\.js\\'" . js2-mode))


;;
;; Markdown
;;

(use-package markdown-mode
  :custom
  (markdown-hide-markup nil)
  (markdown-bold-underscore t)
  (markdown-italic-underscore t)
  (markdown-header-scaling t)
  (markdown-indent-function t)
  (markdown-enable-math t)
  (markdown-hide-urls nil)
  :custom-face
  (markdown-header-delimiter-face ((t (:foreground "mediumpurple"))))
  (markdown-header-face-1 ((t (:foreground "violet" :weight bold :height 1.0))))
  (markdown-header-face-2 ((t (:foreground "lightslateblue" :weight bold :height 1.0))))
  (markdown-header-face-3 ((t (:foreground "mediumpurple1" :weight bold :height 1.0))))
  (markdown-link-face ((t (:background "#0e1014" :foreground "#bd93f9"))))
  (markdown-list-face ((t (:foreground "mediumpurple"))))
  (markdown-pre-face ((t (:foreground "#bd98fe"))))
  :mode "\\.md\\'")

(use-package markdown-toc)


;;
;; Log
;;

(use-package logview :defer t)


;;
;; yaml
;;

(use-package yaml-mode
  :mode ("\\.yaml\\'" "\\.yml\\'")
  :custom-face
  (font-lock-variable-name-face ((t (:foreground "violet")))))


;;
;; Dockerfile
;;

(use-package dockerfile-mode
  :mode "\\Dockerfile\\'")


;;
;; smart kill word or region
;;

(defun kill-word-at-point ()
  (interactive)
  (let ((char (char-to-string (char-after (point)))))
    (cond
     ((string= " " char) (delete-horizontal-space))
     ((string-match "[\t\n -@\[-`{-~],.、。" char) (kill-word 1))
     (t (forward-char) (backward-word) (kill-word 1)))))

(global-set-key (kbd "M-d")  'kill-word-at-point)

(defun backward-kill-word-or-region (&optional arg)
  (interactive "p")
  (if (region-active-p)
      (call-interactively #'kill-region)
    (backward-kill-word arg)))

(global-set-key (kbd "C-w")  'backward-kill-word-or-region)


;;
;; Copy file path
;;

(defun put-current-path-to-clipboard ()
  (interactive)
  (let ((file-path buffer-file-name)
        (dir-path default-directory))
    (cond (file-path
           (kill-new (expand-file-name file-path))
           (message "This file path is on the clipboard!"))
          (dir-path
           (kill-new (expand-file-name dir-path))
           (message "This directory path is on the clipboard!"))
          (t
           (error-message-string "Fail to get path name.")))))

(defun put-current-filename-to-clipboard ()
  (interactive)
  (let ((file-path buffer-file-name)
        (dir-path default-directory))
    (cond (file-path
           (kill-new (file-name-nondirectory file-path))
           (message "This file path is on the clipboard!"))
          (dir-path
           (kill-new (file-name-nondirectory dir-path))
           (message "This directory path is on the clipboard!"))
          (t
           (error-message-string "Fail to get path name.")))))

(defun put-current-filename-with-line-to-clipboard ()
  (interactive)
  (let ((file-path buffer-file-name)
        (dir-path default-directory))
    (cond (file-path
           (kill-new (format "%s:%s"
                             (file-name-nondirectory file-path)
                             (count-lines (point-min) (point))))
           (message "This file path is on the clipboard!"))
          (dir-path
           (kill-new (file-name-nondirectory dir-path))
           (message "This directory path is on the clipboard!"))
          (t
           (error-message-string "Fail to get path name.")))))


;;
;; Dashboard
;;

(use-package dashboard
  :diminish
  (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-center-content t)
  (dashboard-startup-banner 4)
  (dashboard-items '((recents . 15)
                     (projects . 5)
                     (bookmarks . 5)))
  :custom-face
  (dashboard-heading ((t (:foreground "#f1fa8c" :weight bold))))
  :hook
  (after-init . dashboard-setup-startup-hook))


;;
;; imenu
;;

(use-package imenu-list
  :diminish
  )
(global-set-key (kbd "<f10>") #'imenu-list-smart-toggle)


;;
;; Highlight
;;

(use-package hl-line
  :ensure nil
  :hook
  (after-init . global-hl-line-mode))

(use-package highlight-symbol
  :bind
  (:map prog-mode-map
        ("M-o h" . highlight-symbol)
        ("M-p" . highlight-symbol-prev)
        ("M-n" . highlight-symbol-next)))

(use-package beacon
  :custom
  (beacon-color "#f1fa8c")
  :hook (after-init . beacon-mode))

(use-package volatile-highlights
  :diminish
  :hook
  (after-init . volatile-highlights-mode)
  :custom-face
  (vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))

(use-package highlight-indent-guides
  :diminish
  :hook
  ((prog-mode yaml-mode) . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-auto-enabled t)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-method 'character)) ; column


;;
;; Mark
;;

(use-package backward-forward
  :disabled
  :bind
  ("C-," . backward-forward-previous-location)
  ("C-." . backward-forward-next-location)
  :custom
  (mark-ring-max 60)
  (set-mark-command-repeat-pop t)
  :config
  (backward-forward-mode t))



;;
;; keyconfig
;;

(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
(define-key global-map (kbd "C-x ?") 'help-command)
(define-key global-map (kbd "C-t") 'other-window)


;;
;; special thanks
;;
;; https://ladicle.com/post/config/

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-migemo-function-names
   (quote
    (swiper--add-overlays-migemo
     (swiper--re-builder :around swiper--re-builder-migemo-around)
     (ivy--regex :around ivy--regex-migemo-around)
     (ivy--regex-ignore-order :around ivy--regex-ignore-order-migemo-around)
     (ivy--regex-plus :around ivy--regex-plus-migemo-around)
     ivy--highlight-default-migemo ivy-occur-revert-buffer-migemo ivy-occur-press-migemo avy-migemo-goto-char avy-migemo-goto-char-2 avy-migemo-goto-char-in-line avy-migemo-goto-char-timer avy-migemo-goto-subword-1 avy-migemo-goto-word-1 avy-migemo-isearch avy-migemo-org-goto-heading-timer avy-migemo--overlay-at avy-migemo--overlay-at-full)))
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(package-selected-packages
   (quote
    (mwim which-key use-package undohist undo-tree smartparens quickrun quelpa popwin pbcopy multiple-cursors magit ivy-rich ivy-posframe ivy-explorer init-loader hydra hungry-delete git-gutter flx exec-path-from-shell doom-themes doom-modeline diminish counsel-projectile avy-zap avy-migemo anzu amx ag ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:height 4.0 :foreground "#f1fa8c"))))
 '(dashboard-heading ((t (:foreground "#f1fa8c" :weight bold))))
 '(flymake-posframe-foreground-face ((t (:foreground "white"))))
 '(font-lock-variable-name-face ((t (:foreground "violet"))))
 '(git-gutter:added ((t (:foreground "#50fa7b" :background "#50fa7b"))))
 '(git-gutter:deleted ((t (:foreground "#ff79c6" :background "#ff79c6"))))
 '(git-gutter:modified ((t (:foreground "#f1fa8c" :background "#f1fa8c"))))
 '(hydra-posframe-border-face ((t (:background "#6272a4"))))
 '(ivy-posframe ((t (:background "#282a36"))))
 '(ivy-posframe-border ((t (:background "#6272a4"))))
 '(ivy-posframe-cursor ((t (:background "#61bfff"))))
 '(markdown-header-delimiter-face ((t (:foreground "mediumpurple"))))
 '(markdown-header-face-1 ((t (:foreground "violet" :weight bold :height 1.0))))
 '(markdown-header-face-2 ((t (:foreground "lightslateblue" :weight bold :height 1.0))))
 '(markdown-header-face-3 ((t (:foreground "mediumpurple1" :weight bold :height 1.0))))
 '(markdown-link-face ((t (:background "#0e1014" :foreground "#bd93f9"))))
 '(markdown-list-face ((t (:foreground "mediumpurple"))))
 '(markdown-pre-face ((t (:foreground "#bd98fe"))))
 '(show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c"))))
 '(vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))
