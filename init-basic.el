;;; -*- mode: emacs-lisp; mode: goto-address; coding: utf-8; -*-
;; Copyright (C) 2013-2014 zhenglj
;;
;; This code has been released into the Public Domain.
;; You may do whatever you like with it.
;;
;; @file
;; @author zhenglj
;; @date 2014-02-25
;;
;; ---------------------------------------------------------------
;;; global setting
;; ---------------------------------------------------------------
;; user information
(setq user-full-name "zhenglj")
(setq user-mail-address "zhenglj89@gmail.com")

;; ---------------------------------------------------------------
;; ui
;; ---------------------------------------------------------------
(setq suggest-key-bindings-1 t)        ;suggest-key-bindings in minibuffer

(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space nil)

;; cursor
;; (setq-default cursor-type 'bar)
;; (blink-cursor-mode -1)
(setq x-stretch-cursor t)

;; (mouse-avoidance-mode 'animate)
;; (setq mouse-autoselect-window t)

;; ;; color theme
;; (require 'color-theme)
;; (color-theme-molokai)

;; ---------------------------------------------------------------
;; edit
;; ---------------------------------------------------------------
(setq-default major-mode 'text-mode)    ; (setq default-major-mode 'text-mode)

(global-auto-revert-mode t)
(setq cua-enable-cua-keys nil)
(setq mouse-drag-copy-region nil)
(setq x-select-enable-clipboard t)

;; advanced comment function
(defun my-comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command. If no region is selected and current line is not blank and we are not at the end of the line, then comment current line. Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))

;; ---------------------------------------------------------------
;; input/select operation
;; ---------------------------------------------------------------
(if (fboundp 'cua-mode)
    (progn
      (setq cua-rectangle-mark-key [C-M-return])
      (cua-mode t)
      (setq cua-keep-region-after-copy t))
  (when (fboundp 'pc-selection-mode)
    (setq pc-select-selection-keys-only t)
    (pc-selection-mode)))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq kill-ring-max 200)

;; ---------------------------------------------------------------
;; coding
;; ---------------------------------------------------------------
;; (setq system-time-locale "C")

;; (when (daemonp)
;;   (add-hook 'after-make-frame-functions
;;             (lambda (frame)
;;               (with-selected-frame frame
;;                 (set-locale-environment (getenv "LANG"))))))

;; ---------------------------------------------------------------
;; session
;; ---------------------------------------------------------------
;; (require 'saveplace)
;; (setq-default save-place t)

;; (when (fboundp 'savehist-mode)
;;   (savehist-mode t))
;; (setq recentf-menu-open-all-flag t
;;       recentf-max-saved-items 100
;;       recentf-max-menu-items 30)
;; (recentf-mode t)
;; (defadvice recentf-track-closed-file (after push-beginning activate)
;;   "Move current buffer to the beginning of the recent list after killed."
;;   (recentf-track-opened-file))
;; (defun undo-kill-buffer (arg)
;;   "Re-open the last buffer killed.  With ARG, re-open the nth buffer."
;;   (interactive "p")
;;   (let ((recently-killed-list (copy-sequence recentf-list))
;;         (buffer-files-list
;;          (delq nil (mapcar (lambda (buf)
;;                              (when (buffer-file-name buf)
;;                                (expand-file-name (buffer-file-name buf))))
;;                            (buffer-list)))))
;;     (mapc
;;      (lambda (buf-file)
;;        (setq recently-killed-list
;;              (delete buf-file recently-killed-list)))
;;      buffer-files-list)
;;     (find-file (nth (- arg 1) recently-killed-list))))
;; (and (fboundp 'desktop-save-mode)
;;      (not (daemonp))
;;      (desktop-save-mode (if window-system 1 -1)))

;; ---------------------------------------------------------------
;; backup
;; ---------------------------------------------------------------
;; (setq make-backup-files t)

;; Write backup files to own directory
(if (not (file-exists-p (expand-file-name "~/.backups")))
    (make-directory (expand-file-name "~/.backups"))
  )
(setq
 backup-by-coping t ; don't clobber symlinks
 backup-directory-alist '(("." . "~/.backups"))
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t  ;use versioned backups
 )
;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; (setq backup-by-copying t)
;; (setq delete-old-versions t)
;; (setq kept-old-versions 2)
;; (setq kept-new-versions 5)
;; (setq version-control t)

;; ---------------------------------------------------------------
;; highlight
;; ---------------------------------------------------------------
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))
;; (setq jit-lock-defer-time 0.05)         ; Make c mode faster
(when (fboundp 'transient-mark-mode)
  (transient-mark-mode t))
;; (setq hl-line-face 'underline)          ; for highlight-symbol
;; (global-hl-line-mode 1)                 ; (if window-system 1 -1)
;; (global-highlight-changes-mode t)       ; use cedet instead
(dolist (mode '(c-mode c++-mode objc-mode java-mode jde-mode
                       perl-mode cperl-mode php-mode python-mode ruby-mode
                       lisp-mode emacs-lisp-mode xml-mode nxml-mode html-mode
                       lisp-interaction-mode sh-mode sgml-mode))
  (font-lock-add-keywords
   mode
   '(("\\<\\(FIXME\\|TODO\\|Todo\\)\\>" 1 font-lock-warning-face prepend)
     ("\\<\\(FIXME\\|TODO\\|Todo\\):" 1 font-lock-warning-face prepend))))

;; ;; (setq-default show-trailing-whitespace t) ; use whitespace-mode instead
;; (setq whitespace-style '(face trailing lines-tail newline empty tab-mark))
;; (when window-system
;;   (setq whitespace-style (append whitespace-style '(tabs newline-mark))))
;; (eval-after-load "whitespace"
;;   `(defun whitespace-post-command-hook ()
;;      "Hack whitespace, it's very slow in c++-mode."))
(global-whitespace-mode -1)             ; ;; (global-whitespace-mode t)

;; ---------------------------------------------------------------
;; calendar
;; ---------------------------------------------------------------
(setq calendar-chinese-all-holidays-flag t)
(setq mark-holidays-in-calendar t)
;; (setq calendar-week-start-day 1)
;; (setq mark-diary-entries-in-calendar t)
(setq diary-file "~/.emacs.d/diary")
;; (add-hook 'diary-hook 'appt-make-list)
;; (setq appt-display-format 'window)
;; (setq appt-display-mode-line t)
;; (setq appt-display-diary nil)
(setq appt-display-duration (* 365 24 60 60))
(unless (daemonp)
  (appt-activate 1)
  (delete-other-windows))
;; (diary 0)

;; cal-china-x
(eval-after-load "calendar"
  '(when (require 'cal-china-x nil 'noerror)
     (setq cal-china-x-priority1-holidays
           (append cal-china-x-chinese-holidays
                   '((holiday-fixed 2 14 "情人节")
                     (holiday-fixed 3 8 "妇女节")
                     (holiday-fixed 3 12 "植树节")
                     (holiday-fixed 5 4 "青年节")
                     (holiday-fixed 6 1 "儿童节")
                     (holiday-fixed 9 10 "教师节")
                     (holiday-lunar 1 15 "元宵节(正月十五)" 0)
                     (holiday-lunar 7 7 "七夕节")
                     (holiday-lunar 9 9 "重阳节(九月初九)"))))
     (setq cal-china-x-priority2-holidays
           ((holiday-chinese 2 22 "Miss Gu's birthday")
             (holiday-chinese 5 29 "zhenglj's birthday")
             (holiday-fixed 10 16 "")
             (holiday-chinese 11 13 "")))
     (setq calendar-holidays
           (append calendar-holidays
                   cal-china-x-priority1-holidays
                   cal-china-x-priority2-holidays))))

;; cn-weather
(setq cn-weather-city "hangzhou")
(autoload 'display-cn-weather-mode "cn-weather"
  "Display weather information in the mode line." t)
(autoload 'cn-weather "cn-weather"
  "Print Now today's and realtime weather in the echo area." t)
(autoload 'cn-weather-forecast "cn-weather"
  "Print future two days' weather info in minibuffer." t)

;; ---------------------------------------------------------------
;; autoinsert
;; ---------------------------------------------------------------
(auto-insert-mode 1)
;; (setq auto-insert t)
;; (setq auto-insert-query nil)
(setq auto-insert-directory
      (file-name-as-directory
       (expand-file-name "etc/templates"
                         (file-name-directory (or buffer-file-name
                                                  load-file-name)))))
(setq auto-insert-expansion-alist
      '(("(>>>DIR<<<)" . (file-name-directory buffer-file-name))
        ("(>>>FILE<<<)" . (file-name-nondirectory buffer-file-name))
        ("(>>>FILE_SANS<<<)" . (file-name-sans-extension
                                (file-name-nondirectory buffer-file-name)))
        ("(>>>FILE_UPCASE<<<)" . (upcase
                                  (file-name-sans-extension
                                   (file-name-nondirectory buffer-file-name))))
        ("(>>>FILE_UPCASE_INIT<<<)" . (upcase-initials
                                       (file-name-sans-extension
                                        (file-name-nondirectory buffer-file-name))))
        ("(>>>FILE_EXT<<<)" . (file-name-extension buffer-file-name))
        ("(>>>FILE_EXT_UPCASE<<<)" . (upcase (file-name-extension buffer-file-name)))
        ("(>>>DATE<<<)" . (format-time-string "%d %b %Y"))
        ("(>>>TIME<<<)" . (format-time-string "%T"))
        ("(>>>VC_DATE<<<)" . (let ((ret ""))
                               (set-time-zone-rule "UTC")
                               (setq ret (format-time-string "%Y/%m/%d %T"))
                               (set-time-zone-rule nil)
                               ret))
        ("(>>>YEAR<<<)" . (format-time-string "%Y"))
        ("(>>>ISO_DATE<<<)" . (format-time-string "%Y-%m-%d"))
        ("(>>>AUTHOR<<<)" . (or user-mail-address
                                (and (fboundp 'user-mail-address)
                                     (user-mail-address))
                                (concat (user-login-name) "@" (system-name))))
        ("(>>>USER_NAME<<<)" . (or (and (boundp 'user-full-name)
                                        user-full-name)
                                   (user-full-name)))
        ("(>>>LOGIN_NAME<<<)" . (user-login-name))
        ("(>>>HOST_ADDR<<<)" . (or (and (boundp 'mail-host-address)
                                        (stringp mail-host-address)
                                        mail-host-address)
                                   (system-name)))))
(defun auto-insert-expand ()
  (dolist (val auto-insert-expansion-alist)
    (let ((from (car val))
          (to (eval (cdr val))))
      (goto-char (point-min))
      (replace-string from to))))
(define-auto-insert "\\.\\([Hh]\\|hh\\|hpp\\)\\'"
  ["h.tpl" auto-insert-expand])
(define-auto-insert "\\.\\([Cc]\\|cc\\|cpp\\)\\'"
  ["cpp.tpl" auto-insert-expand])
(define-auto-insert "\\.java\\'"
  ["java.tpl" auto-insert-expand])
(define-auto-insert "\\.py\\'"
  ["py.tpl" auto-insert-expand])

;; ---------------------------------------------------------------
;; misc functions
;; ---------------------------------------------------------------
(setq inhibit-startup-message t)        ; for no desktop
(setq inhibit-default-init t)           ; for frame-title-format
(setq generic-define-mswindows-modes t)
(setq generic-define-unix-modes t)
(require 'generic-x nil 'noerror)
(setq ring-bell-function 'ignore)
(auto-image-file-mode t)
;; (setq message-log-max t)
;; (add-hook 'find-file-hook 'goto-address-mode)
;; (setq max-specpdl-size 4000)
;; (setq max-lisp-eval-depth 4000)
;; (setq debug-on-error t)
(autoload 'zone-when-idle "zone" nil t)
(zone-when-idle 600)
;; zone-pgm-stress will destroy the clipboard
(setq zone-programs (append zone-programs nil))
(setq zone-programs (remq 'zone-pgm-stress zone-programs))
(setq zone-programs (remq 'zone-pgm-stress-destress zone-programs))
(add-hook 'after-init-hook
          (lambda ()
            (message "emacs-init-time: %s" (emacs-init-time))))

(defadvice find-tag (before tags-file-name-advice activate)
  "Find TAGS file in ./ or ../ or ../../ dirs"
  (let ((list (mapcar 'expand-file-name '("./TAGS" "../TAGS" "../../TAGS"))))
    (while list
      (if (file-exists-p (car list))
          (progn
            (setq tags-file-name (car list))
            (setq list nil))
        (setq list (cdr list))))))

(defun find-dotemacs-file ()
  "Open .emacs file"
  (interactive)
  (let* ((paths '("~/.emacs" "~/.emacs.el" "~/.emacs.d/init.el" "~/_emacs"))
         (dotemacs-path))
    (dolist (path paths)
      (and (not dotemacs-path)
           (file-exists-p path)
           (setq dotemacs-path path)))
    (find-file (or dotemacs-path
                   (locate-file "site-start.el" load-path)
                   "~/.emacs"))))

;; (defun move-line-up (p)
;;   "Move current line up, copy from crazycool@smth"
;;   (interactive "*p")
;;   (let ((c (current-column)))
;;     (beginning-of-line)
;;     (kill-line 1)
;;     (previous-line p)
;;     (beginning-of-line)
;;     (yank)
;;     (previous-line 1)
;;     (move-to-column c)))

;; (defun move-line-down (p)
;;   "Move current line down, copy from crazycool@smth"
;;   (interactive "*p")
;;   (let ((c (current-column)))
;;     (beginning-of-line)
;;     (kill-line 1)
;;     (next-line p)
;;     (beginning-of-line)
;;     (yank)
;;     (previous-line 1)
;;     (move-to-column c)))

(defun format-region ()
  "Format region, if no region actived, format current buffer.
Like eclipse's Ctrl+Alt+F."
  (interactive)
  (let ((start (point-min))
        (end (point-max)))
    (if (and (fboundp 'region-active-p) (region-active-p))
        (progn (setq start (region-beginning))
               (setq end (region-end)))
      (progn (when (fboundp 'whitespace-cleanup)
               (whitespace-cleanup))
             (setq end (point-max))))
    (save-excursion
      (save-restriction
        (narrow-to-region (point-min) end)
        (push-mark (point))
        (push-mark (point-max) nil t)
        (goto-char start)
        (when (fboundp 'whitespace-cleanup)
          (whitespace-cleanup))
        (untabify start (point-max))
        (indent-region start (point-max) nil)))))

(defun cxx-file-p (file)
  (let ((file-extension (file-name-extension file)))
    (and file-extension
         (string= file (file-name-sans-versions file))
         (find file-extension
               '("h" "hpp" "hxx" "c" "cpp" "cxx")
               :test 'string=))))

(defun format-cxx-file (file)
  "Format a c/c++ file."
  (interactive "F")
  (if (cxx-file-p file)
      (let ((buffer (find-file-noselect file))) ;; open buffer
        (save-excursion
          (set-buffer buffer)
          ;; (mark-whole-buffer)
          (when (fboundp 'whitespace-cleanup)
            (whitespace-cleanup))
          (untabify (point-min) (point-max))
          (indent-region (point-min) (point-max))
          (save-buffer)
          (kill-buffer)
          (message "Formated c++ file:%s" file)))
    (message "%s isn't a c++ file" file)))

(defun format-cxx-directory (dirname)
  "Format all c/c++ file in a directory."
  (interactive "D")
  ;; (message "directory:%s" dirname)
  (let ((files (directory-files dirname t)))
    (dolist (x files)
      (if (not (string= "." (substring (file-name-nondirectory x) 0 1)))
          (if (file-directory-p x)
              (format-cxx-directory x)
            (if (and (file-regular-p x)
                     (not (file-symlink-p x))
                     (cxx-file-p x))
                (format-cxx-file x)))))))

;;fullscreen
(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))
;; (defun toggle-fullscreen ()
;;   (interactive)
;;   (x-send-client-message
;;    nil 0 nil "_NET_WM_STATE" 32
;;    '(2 "_NET_WM_STATE_FULLSCREEN" 0))
;;   )
(global-set-key [f11] 'toggle-fullscreen)

;; ---------------------------------------------------------------
;; global key bindings (kbd)
;; ---------------------------------------------------------------
(global-set-key (kbd "C-M-;") 'my-comment-dwim-line)
;; (global-set-key (kbd "M-SPC") 'set-mark-command) ;
;; (define-key cua-global-keymap (kbd "M-SPC") 'cua-set-mark)
;; (global-set-key (kbd "<M-up>") 'move-line-up)
;; (global-set-key (kbd "<M-down>") 'move-line-down)
(global-set-key (kbd "<find>") 'move-beginning-of-line) ; putty
(global-set-key (kbd "<select>") 'move-end-of-line) ; putty
(unless (key-binding [mouse-4])
  (global-set-key [mouse-4] 'mwheel-scroll)) ; putty
(unless (key-binding [mouse-5])
  (global-set-key [mouse-5] 'mwheel-scroll)) ; putty
(global-set-key (kbd "C-=") 'align)
(global-set-key (kbd "C-S-u") 'upcase-region)
(global-set-key (kbd "C-S-l") 'downcase-region)
;; (global-set-key (kbd "C-M-;") 'comment-or-uncomment-region)
;; (global-set-key (kbd "ESC M-;") 'comment-or-uncomment-region) ; putty
;; (global-set-key [M-f8] 'format-region)
(global-set-key (kbd "ESC <f8>") 'format-region) ; putty
(global-set-key (kbd "C-S-f") 'format-region)
;; (global-set-key (kbd "M-p") 'previous-buffer)
;; (global-set-key (kbd "M-n") 'next-buffer)
;; (global-set-key [C-prior] 'previous-buffer)
;; (global-set-key [C-next] 'next-buffer)
;; (global-set-key [(control tab)] 'switch-to-other-buffer)
;; (global-set-key (kbd "C-x C-b") 'ibuffer)
;; (global-set-key (kbd "C-c q") 'auto-fill-mode)
(define-key global-map "\C-x\C-j" 'dired-jump)

;; (global-set-key [f4] 'next-error)
(global-set-key [f4] (lambda (&optional previous)
                       (interactive "P")
                       (if previous
                           (previous-error)
                         (next-error))))
(global-set-key [S-f4] 'previous-error)
(global-set-key [f16] 'previous-error)  ; S-f4
(global-set-key [C-f4] 'kill-this-buffer)
(global-set-key (kbd "ESC <f4>") 'kill-this-buffer) ; putty
(global-set-key [(control ?.)] 'repeat)

(global-set-key [f6] 'grep-current-dir)
(global-set-key [C-f6] 'moccur-all-buffers)
(global-set-key [M-f6] 'grep-todo-current-dir)
;; (lambda () (interactive) (grep-current-dir nil "TODO|FIXME"))
(global-set-key (kbd "ESC <f6>") (key-binding [M-f6]))
(global-set-key [C-M-f6] 'moccur-todo-all-buffers)
;; '(lambda ()
;;    (interactive)
;;    (moccur-word-all-buffers
;;     "\\<\\([Tt][Oo][Dd][Oo]\\|[Ff][Ii][Xx][Mm][Ee]\\)\\>"))
(global-set-key (kbd "ESC <C-f6>") (key-binding [C-M-f6]))

(global-set-key [f7] '(lambda () (interactive) (compile compile-command)))

;; (global-set-key [f11] 'toggle-fullscreen)
;; (global-set-key [header-line double-mouse-1] 'kill-this-buffer)
(global-set-key [header-line double-mouse-1]
                '(lambda ()
                   (interactive)
                   (let* ((i 1)
                          (name (format "new %d" i)))
                     (while (get-buffer name)
                       (setq i (1+ i))
                       (setq name (format "new %d" i)))
                     (switch-to-buffer name))))
;; (global-set-key [header-line double-mouse-1]
;;                 '(lambda () (interactive) (switch-to-buffer "new")))
(global-set-key [header-line mouse-3] 'kill-this-buffer)
(global-set-key [mouse-2] nil)
(global-set-key [left-fringe mouse-2] nil)
(global-set-key [left-margin mouse-2] nil)
(global-set-key [mouse-3] menu-bar-edit-menu)
(global-set-key (kbd "<left-margin> <mouse-2>") 'mark-current-line-mouse)
(global-set-key (kbd "C-S-t") 'undo-kill-buffer)
(global-set-key (kbd "C-c C-v") 'view-mode)
(global-set-key [(control %)] 'goto-match-paren)
(when (eq system-type 'aix)
  (global-set-key (kbd "C-d") 'backward-delete-char-untabify)
  (eval-after-load "cc-mode"
    '(progn
       (define-key c-mode-base-map "\C-d" 'c-electric-backspace)))
  (eval-after-load "comint"
    '(progn
       (define-key comint-mode-map "\C-d" 'delete-backward-char))))

;; ---------------------------------------------------------------
;; hide or show
;; ---------------------------------------------------------------
(defvar hs--overlay-keymap nil "keymap for folding overlay")
(let ((map (make-sparse-keymap)))
  (define-key map [mouse-1] 'hs-show-block)
  (setq hs--overlay-keymap map))
(setq hs-set-up-overlay
      (defun my-display-code-line-counts (ov)
        (when (eq 'code (overlay-get ov 'hs))
          (overlay-put ov 'display
                       (propertize
                        (format "...<%d>"
                                (count-lines (overlay-start ov)
                                             (overlay-end ov)))
                        'face 'mode-line))
          (overlay-put ov 'priority (overlay-end ov))
          (overlay-put ov 'keymap hs--overlay-keymap)
          (overlay-put ov 'pointer 'hand))))
(eval-after-load "hideshow"
  '(progn (define-key hs-minor-mode-map [(shift mouse-2)] nil)
          (define-key hs-minor-mode-map (kbd "C-+") 'hs-toggle-hiding)
          (define-key hs-minor-mode-map (kbd "C-;") 'hs-hide-all)
          (define-key hs-minor-mode-map (kbd "C-\'") 'hs-show-all)
          ;; (define-key hs-minor-mode-map (kbd "C-:") 'hs-hide-block)
          ;; (define-key hs-minor-mode-map (kbd "C-\"") 'hs-show-block)
          ;; (define-key hs-minor-mode-map [/C-c l] 'hs-hide-level)
          ;; (define-key hs-minor-mode-map [/C-c t] 'hs-toggle-hiding)
          (define-key hs-minor-mode-map (kbd "<left-fringe> <mouse-2>")
            'hs-mouse-toggle-hiding)))
;; (global-set-key (kbd "C-?") 'hs-minor-mode)

;; ---------------------------------------------------------------
;; workspace
;; ---------------------------------------------------------------

(setq default-directory "~/projects/")
;; (setq default-directory "~/.emacs.d/dotemacs")

;; ---------------------------------------------------------------
;; eshell
;; ---------------------------------------------------------------
;;open (e)shell
(defun open-eshell-other-buffer ()
  "Open eshell in other buffer"
  (interactive)
  (split-window-vertically)
  (eshell))

(global-set-key [(f6)] 'open-eshell-other-buffer) ;open eshell in other buffer
;; (global-set-key [C-f6] 'eshell)                   ;open eshell in current buffer


(provide 'init-basic)
