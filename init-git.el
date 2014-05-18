(setq magit-save-some-buffers nil
      magit-process-popup-time 10
      magit-completing-read-function 'magit-ido-completing-read)

;; turn off the overlay, I do NOT want to lose original syntax highlight!
(setq magit-highlight-overlay t)

(defun magit-status-somedir ()
  (interactive)
  (let ((current-prefix-arg t))
    (magit-status default-directory)))

;; Sometimes I want check other developer's commit
;; show file of specific version
(autoload 'magit-show "magit" "" t nil)
;; show the commit
(autoload 'magit-show-commit "magit" "" t nil)

(global-set-key [(meta f12)] 'magit-status)
;; (global-set-key [(shift meta f12)] 'magit-status-somedir)

(eval-after-load 'magit
  '(progn
     ;; Don't let magit-status mess up window configurations
     ;; http://whattheemacsd.com/setup-magit.el-01.html
     (defadvice magit-status (around magit-fullscreen activate)
       (window-configuration-to-register :magit-fullscreen)
       ad-do-it
       (delete-other-windows))

     (defun kill-buffer-if-exists (bufname)
       (if (not (eq nil (get-buffer bufname)))
           (kill-buffer bufname)))

     (defun magit-quit-session ()
       "Restores the previous window configuration and kills the magit buffer"
       (interactive)
       (kill-buffer-if-exists magit-branches-buffer-name)
       (kill-buffer-if-exists magit-commit-buffer-name)
       (kill-buffer-if-exists magit-log-buffer-name)
       (kill-buffer-if-exists magit-log-edit-buffer-name)
       (kill-buffer-if-exists magit-process-buffer-name)
       (kill-buffer-if-exists magit-stash-buffer-name)
       (kill-buffer-if-exists magit-tmp-buffer-name)
       (kill-buffer-if-exists magit-key-mode-buf-name)
       (kill-buffer)
       (jump-to-register :magit-fullscreen))

     (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)))

(when *is-a-mac*
  (add-hook 'magit-mode-hook (lambda () (local-unset-key [(meta h)]))))

(eval-after-load 'magit
  '(progn
     (require 'magit-key-mode)
     (require 'magit-svn)
     ))

;; {{ git-gutter
(require 'git-gutter)
;; (require 'git-gutter-fringe)
;; If you enable global minor mode
(global-git-gutter-mode t)

(defun toggle-gutter-or-linum ()
  "enable either git-gutter-mode of linum-mode"
  (interactive)
  (let ((git-gutter:force t))
    (if (compare-strings (substring-no-properties vc-mode 1 4) 0 3 "Git" 0 3)
	(if git-gutter:enabled
	    (progn
	      (git-gutter:clear)
	      (setq git-gutter-mode nil)
	      (setq linum-mode t))
	  (progn
	    (git-gutter)
	    (setq linum-mode nil)
	    (setq git-gutter-mode t))))
    (setq git-gutter:toggle-flag git-gutter:enabled)
    (force-mode-line-update)))

(global-set-key (kbd "C-x g") 'toggle-gutter-or-linum)
;; (global-set-key (kbd "C-x g") 'git-gutter:toggle)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)

;; Jump to next/previous hunk
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)

;; Stage current hunk
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)

;; Revert current hunk
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)
;; }}

;;----------------------------------------------------------------------------
;; git-svn conveniences
;;----------------------------------------------------------------------------
(eval-after-load 'compile
  '(progn
     (dolist (defn (list '(git-svn-updated "^\t[A-Z]\t\\(.*\\)$" 1 nil nil 0 1)
                         '(git-svn-needs-update "^\\(.*\\): needs update$" 1 nil nil 2 1)))
       (add-to-list 'compilation-error-regexp-alist-alist defn))
     (dolist (defn '(git-svn-updated git-svn-needs-update))
       (add-to-list 'compilation-error-regexp-alist defn))))

(defvar git-svn--available-commands nil "Cached list of git svn subcommands")

(defun git-svn (dir)
  "Run git svn"
  (interactive "DSelect directory: ")
  (unless git-svn--available-commands
    (setq git-svn--available-commands
          (string-all-matches "^  \\([a-z\\-]+\\) +" (shell-command-to-string "git svn help") 1)))
  (let* ((default-directory (vc-git-root dir))
         (compilation-buffer-name-function (lambda (major-mode-name) "*git-svn*")))
    (compile (concat "git svn "
                     (ido-completing-read "git-svn command: " git-svn--available-commands nil t)))))

(defun git-reset-current-file ()
  "git reset file of current buffer"
  (interactive)
  (let ((filename))
    (when buffer-file-name
      (setq filename (file-truename buffer-file-name))
      (shell-command (concat "git reset " filename))
      (message "DONE! git reset %s" filename)
      )))

(defun git-add-current-file ()
  "git add file of current buffer"
  (interactive)
  (let ((filename))
    (when buffer-file-name
      (setq filename (file-truename buffer-file-name))
      (shell-command (concat "git add " filename))
      (message "DONE! git add %s" filename)
      )))

(defun git-add-option-update ()
  "git add only tracked files of default directory"
  (interactive)
  (when buffer-file-name
    (shell-command "git add -u")
    (message "DONE! git add -u %s" default-directory)
    ))

;; ;; {{ git-messenger
;; (require 'git-messenger)
;; ;; show to details to play `git blame' game
;; (setq git-messenger:show-detail t)
;; (add-hook 'git-messenger:after-popup-hook (lambda (msg)
;;                                             ;; extract commit id and put into the kill ring
;;                                             (when (string-match "\\(commit *: *\\)\\([0-9a-z]+\\)" msg)
;;                                               (kill-new (match-string 2 msg)))
;;                                             (kill-new msg)
;;                                             (with-temp-buffer
;;                                               (insert msg)
;;                                               (shell-command-on-region (point-min) (point-max)
;;                                                                        (cond
;;                                                                         ((eq system-type 'cygwin) "putclip")
;;                                                                         ((eq system-type 'darwin) "pbcopy")
;;                                                                         (t "xsel -ib")
;;                                                                         )))
;;                                             (message "commit details > clipboard & kill-ring")))
;; (global-set-key (kbd "C-x v p") 'git-messenger:popup-message)
;; ;; }}

;; {{ goto next/previous hunk/section
(defun my-goto-next-section (arg)
  "wrap magit and other diff plugins next/previous command"
  (interactive "p")
  (cond
   ((string= major-mode "magit-commit-mode")
    (setq arg (abs arg))
    (while (> arg 0)
      (condition-case nil
          ;; buggy when start from first line
          (magit-goto-next-sibling-section)
        (error
         (magit-goto-next-section)))
      (setq arg (1- arg))))
   (t (git-gutter:next-hunk arg))
   ))

(defun my-goto-previous-section (arg)
  "wrap magit and other diff plugins next/previous command"
  (interactive "p")
  (cond
   ((string= major-mode "magit-commit-mode")
    (setq arg (abs arg))
    (while (> arg 0)
      (condition-case nil
          ;; buggy when start from first line
          (magit-goto-previous-sibling-section)
        (error
         (magit-goto-previous-section)))
      (setq arg (1- arg))))
   (t (git-gutter:previous-hunk arg))
   ))

(defun my-goto-next-hunk (arg)
  "wrap magit and other diff plugins next/previous command"
  (interactive "p")
  (cond
   ((string= major-mode "magit-commit-mode")
    (diff-hunk-next arg))
   (t (git-gutter:next-hunk arg))
   ))

(defun my-goto-previous-hunk (arg)
  "wrap magit and other diff plugins next/previous command"
  (interactive "p")
  (cond
   ((string= major-mode "magit-commit-mode")
    (diff-hunk-prev arg))
   (t (git-gutter:previous-hunk arg))
   ))
;; }}

;; http://stackoverflow.com/questions/14769044/undo-tree-style-git-in-terminal
(defun my-magit-visit-file-at-commit (&optional other-window)
  "Visit current commit's file in another window.
This command makes sense from a `magit-file-log' buffer. "
  (interactive "P")
  (magit-section-action (item info "visit")
    ((commit)
     (let ((filename (expand-file-name (car magit-refresh-args)
				       (concat (magit-git-dir) "../"))))
       (if (file-readable-p filename)
	   (progn
	     (find-file-noselect filename)
	     (with-current-buffer (find-buffer-visiting filename)
	       (vc-revision-other-window info)))
	 (message "not able to access %s" filename))))))

(eval-after-load "magit.el"
  '(define-key magit-log-mode-map (kbd "C-c o") 'my-magit-visit-file-at-commit))

(provide 'init-git)
