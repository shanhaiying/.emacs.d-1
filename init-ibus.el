(require 'ibus)
;; Turn on ibus-mode automatically after loading .emacs
(add-hook 'after-init-hook 'ibus-mode-on)
(setq ibus-agent-file-name "~/.emacs.d/site-lisp/ibus/ibus-el-agent")

;; If you use the client-server mode of emacs, replace the after-init-hook line by this:
;; (add-hook 'after-make-frame-functions
;;           (lambda (new-frame)
;;             (select-frame new-frame)
;;             (or ibus-mode (ibus-mode-on))))

;; Use C-SPC for Set Mark command
(ibus-define-common-key ?\C-\s nil)
;; Use C-/ for Undo command
(ibus-define-common-key ?\C-/ nil)
(global-set-key (kbd "\C-\\") 'ibus-toggle)
;; Change cursor color depending on IBus status
(setq ibus-cursor-color '("blue" "snow" "limegreen"))

(provide 'init-ibus)
