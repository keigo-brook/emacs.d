;; Japanese font settings
(defun set-japanese-font (family)
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208        (font-spec :family family))
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0212        (font-spec :family family))
  (set-fontset-font (frame-parameter nil 'font) 'katakana-jisx0201        (font-spec :family family)))

(when (eq system-type 'darwin)
  (setq default-font-family "Menlo")
  (setq jp-font-family "Hiragino Kaku Gothic Pro")
  (set-face-attribute 'default nil :family default-font-family))

(set-japanese-font jp-font-family)
(add-to-list 'face-font-rescale-alist (cons default-font-family 0.86))
(add-to-list 'face-font-rescale-alist (cons jp-font-family 1.0))
