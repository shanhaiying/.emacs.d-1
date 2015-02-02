;; config bm
(setq bm-restore-repository-on-load t)
(when (require 'bm nil 'noerror)
  (setq-default bm-buffer-persistence t)
  (setq bm-cycle-all-buffers t)
  (setq bm-highlight-style
        (if (and window-system (> emacs-major-version 21))
            'bm-highlight-only-fringe
          'bm-highlight-only-line))
  ;; (add-hook' after-init-hook 'bm-repository-load)
  (add-hook 'find-file-hooks 'bm-buffer-restore)
  (add-hook 'kill-buffer-hook 'bm-buffer-save)
  (add-hook 'kill-emacs-hook '(lambda nil
                                (bm-buffer-save-all)
                                (bm-repository-save)))
  ;; (add-hook 'after-save-hook 'bm-buffer-save)
  ;; (add-hook 'after-revert-hook 'bm-buffer-restore)
  (defun bm-next-or-previous (&optional previous)
    (interactive "P")
    (if previous
        (bm-previous)
      (bm-next)))
  (global-set-key (kbd "<C-f2>") 'bm-toggle)
  ;; (global-set-key [M-f2] 'bm-toggle)
  ;; (global-set-key (kbd "ESC <f2>") 'bm-toggle) ; putty
  (global-set-key (kbd "<f2>")   'bm-next-or-previous)
  (global-set-key (kbd "<S-f2>") 'bm-previous)
  (global-set-key (kbd " ESC <f2>") 'bm-previous)
  (global-set-key [f14] 'bm-previous)   ; S-f2
  ;; (global-set-key (kbd "ESC ESC <f2>") 'bm-previous)
  (global-set-key (kbd "<C-S-f2>") 'bm-remove-all-current-buffer)
  ;; (global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)
  ;; (global-set-key (kbd "<left-fringe> <mouse-2>") 'bm-toggle-mouse)
  ;; (global-set-key (kbd "<left-fringe> <mouse-3>") 'bm-next-mouse)
  ;; (global-set-key [left-margin mouse-1] 'bm-toggle-mouse)
  (global-set-key [left-margin mouse-1] 'bm-toggle-mouse)
  (global-set-key [left-margin mouse-3] 'bm-next-mouse)
  (defadvice bm-next (after pulse-advice activate)
    "After bm-next, pulse the line the cursor lands on."
    (when (and (boundp 'pulse-command-advice-flag) pulse-command-advice-flag
               (called-interactively-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice bm-previous (after pulse-advice activate)
    "After bm-previous, pulse the line the cursor lands on."
    (when (and (boundp 'pulse-command-advice-flag) pulse-command-advice-flag
               (called-interactively-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice bm-next-or-previous (after pulse-advice activate)
    "After bm-next-or-previous, pulse the line the cursor lands on."
    (when (and (boundp 'pulse-command-advice-flag) pulse-command-advice-flag
               (called-interactively-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice bm-next-mouse (after pulse-advice activate)
    "After bm-next-mouse, pulse the line the cursor lands on."
    (when (and (boundp 'pulse-command-advice-flag) pulse-command-advice-flag
               (called-interactively-p))
      (pulse-momentary-highlight-one-line (point))))
  (defadvice bm-previous-mouse (after pulse-advice activate)
    "After bm-previous-mouse, pulse the line the cursor lands on."
    (when (and (boundp 'pulse-command-advice-flag) pulse-command-advice-flag
               (called-interactively-p))
      (pulse-momentary-highlight-one-line (point)))))

(provide 'init-bm)
;;; init-bm.el ends here
