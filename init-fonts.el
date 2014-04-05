;; text scale
;; ;; windows
;; (global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)
;; (global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
;; linux
(global-set-key (kbd "<C-mouse-5>") 'text-scale-decrease)
(global-set-key (kbd "<C-mouse-4>") 'text-scale-increase)

;; ===============================================================
;; font setting
;; ===============================================================
;; auto select for Linux or windows

(defun my-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defun my-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))

(defun my-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)                         ; for find if
  (let ((en-font (my-make-font-string
                  (find-if #'my-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'my-font-existsp chinese-fonts)
                            :size chinese-font-size)))

    ;; Set the default English font
    ;;
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    ;; (message "Set English Font to %s" en-font)
    (set-face-attribute
     'default nil :font en-font)

    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    ;; (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))

;; (setq face-font-rescale-alist '(("Microsoft Yahei" . 1.2) ("WenQuanYi Zen Hei" . 1.2)))

;; (defvar emacs-english-font "Droid Sans Mono"
;;   "The font name of English.")
;; (defvar emacs-cjk-font "Droid Sans Fallback"
;;   "The font name of CJK.")
;; (defvar emacs-font-size 12
;;   "The default font size.")
;; ;; 英文字体
;; (set-frame-font (format "%s-%s" emacs-english-font emacs-font-size))
;; ;; 中文字体
;; (set-fontset-font (frame-parameter nil 'font)
;;                   'unicode emacs-cjk-font)



(provide 'init-fonts)
