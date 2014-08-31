;; (autoload 'sr-speedbar-toggle "sr-speedbar")

;; ;; sr-speedbar config
;; (setq sr-speedbar-right-side nil)
;; (setq sr-speedbar-skip-other-window-p t)
;; ;; no auto-refresh
;; (setq sr-speedbar-auto-refresh nil)
;; (setq sr-speedbar-width-console 30)
;; (setq sr-speedbar-width-x 30)

;; (global-set-key (kbd "C-c j s") 'sr-speedbar-toggle)
;; (global-set-key (kbd "C-c j r") 'sr-speedbar-refresh-toggle)

;; regular speedbar config
(setq speedbar-show-unknown-files t)
(setq speedbar-verbosity-level 0)
(setq speedbar-frame-parameters (quote ((minibuffer) (width . 35))))
;; (setq speedbar-use-images nil)

(defun speedbar-edit-line-and-switch-to-window ()
  (interactive)
  (speedbar-edit-line)
  (other-window 1))
(global-set-key [(meta f11)] 'speedbar-get-focus)

;; (custom-set-variables  '(speedbar-frame-parameters (quote ((minibuffer) (width . 35) (height . 36)))))

(provide 'init-speedbar)
