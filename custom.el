(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(counsel-grep-base-command
   "ag -S --noheading --nocolor --nofilename --numbers '%s' %s")
 '(counsel-yank-pop-height 15)
 '(doom-modeline-buffer-file-name-style (quote truncate-with-project) t)
 '(doom-modeline-icon t t)
 '(doom-modeline-major-mode-icon nil t)
 '(doom-modeline-minor-modes nil t)
 '(doom-themes-enable-bold t)
 '(doom-themes-enable-italic t)
 '(enable-recursive-minibuffers t)
 '(ivy-display-function (quote ivy-posframe-display-at-frame-center))
 '(ivy-on-del-error-function nil)
 '(ivy-posframe-height 11)
 '(ivy-posframe-parameters (quote ((left-fringe . 5) (right-fringe . 5))))
 '(ivy-posframe-width 130)
 '(ivy-use-selectable-prompt t)
 '(ivy-use-virtual-buffers t)
 '(package-selected-packages
   (quote
	(ivy-explorer init-loader git-gutter magit quickrun undohist undo-tree ivy-rich ivy-posframe counsel-projectile amx flx counsel doom-modeline doom-themes bind-key quelpa diminish use-package)))
 '(show-paren-style (quote mixed))
 '(show-paren-when-point-in-periphery t)
 '(show-paren-when-point-inside-paren t)
 '(swiper-action-recenter t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ivy-posframe ((t (:background "#282a36"))))
 '(ivy-posframe-border ((t (:background "#6272a4"))))
 '(ivy-posframe-cursor ((t (:background "#61bfff"))))
 '(show-paren-match ((nil (:background "#44475a" :foreground "#f1fa8c")))))
