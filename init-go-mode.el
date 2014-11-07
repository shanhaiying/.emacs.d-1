(require 'go-mode)

(defun go-run-buffer()
  (interactive)
  (shell-command (concat "go run " (buffer-name))))

(defun go-kill()
  (interactive)
  (if (go-mode-in-string)
      (paredit-kill-line-in-string)
    (paredit-kill)))

(defun go-backward-delete()
  (interactive)
  (if (go-mode-in-string)
      (paredit-backward-delete-in-string)
    (paredit-backward-delete)))

(define-key go-mode-map (kbd "C-c C-c") #'go-run-buffer)
(define-key go-mode-map (kbd "C-c C-f") #'gofmt)
(define-key go-mode-map (kbd "C-c C-d") #'godoc)
(define-key go-mode-map (kbd "C-c C-a") #'go-import-add)
(define-key go-mode-map (kbd "C-k") #'go-kill)
(define-key go-mode-map (kbd "M-o") #'go-backward-delete)

(provide 'init-go-mode)
