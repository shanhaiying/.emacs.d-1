(defun my-smartparens-config ()
  (setq sp-navigate-consider-sgml-tags '(html-mode
                                         nxml-mode
                                         web-mode
                                         xml-mode))
  ;; highlights matching pairs
  (show-smartparens-global-mode t)
  (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  )

(add-hook 'prog-mode-hook (lambda ()
                            (require 'smartparens-config)
                            (my-smartparens-config)
                            ))

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'minibuffer-setup-hook      #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'TeX-mode-hook              #'enable-paredit-mode)
(add-hook 'markdown-mode-hook         #'enable-paredit-mode)

;; electric-pair-mode
(electric-pair-mode nil)

;; autopair-mode
(require 'autopair)
;; (autopair-global-mode)

(setq skeleton-pair t)
(setq skeleton-pair-alist
      '((?\( _ ?\))
	(?[  _ ?])
	(?{  _ ?})
	(?\" _ ?\")))
;; (add-to-list 'skeleton-pair-alist '(?<  _ ?>))
(defun autopair-insert (arg)
  (interactive "P")
  (let (pair)
    (cond
     ((assq last-command-event skeleton-pair-alist)
      (autopair-open arg))
     (t
      (autopair-close arg)))))
(defalias 'autopair-insert-opening 'autopair-insert)
(defalias 'autopair-skip-close-maybe 'autopair-insert)
(defalias 'autopair-insert-or-skip-quote 'autopair-insert)
(defun autopair-open (arg)
  (interactive "P")
  (let ((pair (assq last-command-event
		    skeleton-pair-alist)))
    (cond
     ((and (not mark-active)
	   (eq (car pair) (car (last pair)))
	   (eq (car pair) (char-after)))
      (autopair-close arg))
     (t
      (skeleton-pair-insert-maybe arg)))))
(defun autopair-close (arg)
  (interactive "P")
  (cond
   (mark-active
    (let (pair open)
      (dolist (pair skeleton-pair-alist)
	(when (eq last-command-event (car (last pair)))
	  (setq open (car pair))))
      (setq last-command-event open)
      (skeleton-pair-insert-maybe arg)))
   ((looking-at
     (concat "[ \t\n]*"
	     (regexp-quote (string last-command-event))))
    (replace-match (string last-command-event))
    (indent-according-to-mode))
   (t
    (self-insert-command (prefix-numeric-value arg))
    (indent-according-to-mode))))
(defadvice delete-backward-char (before autopair activate)
  (when (and (char-after)
	     (eq this-command 'delete-backward-char)
	     (eq (char-after)
		 (car (last (assq (char-before) skeleton-pair-alist)))))
    (delete-char 1)))
(global-set-key "("  'autopair-insert)
(global-set-key ")"  'autopair-insert)
(global-set-key "["  'autopair-insert)
(global-set-key "]"  'autopair-insert)
(global-set-key "{"  'autopair-insert)
(global-set-key "}"  'autopair-insert)
(global-set-key "\"" 'autopair-insert)

;; To use these commands in CC Mode: (cc-mode)
(defun autopair-close-block (arg)
  (interactive "P")
  (cond
   (mark-active
    (autopair-close arg))
   ((not (looking-back "^[[:space:]]*"))
    (newline-and-indent)
    (autopair-close arg))
   (t
    (autopair-close arg))))
(defun autopairs-ret (arg)
      (interactive "P")
      (let (pair)
        (dolist (pair skeleton-pair-alist)
          (when (eq (char-after) (car (last pair)))
            (save-excursion (newline-and-indent))))
        (newline arg)
        (indent-according-to-mode)))
(add-hook 'c-mode-common-hook
          '(lambda ()
             (local-set-key "(" 'autopair-insert)
             (local-set-key ")" 'autopair-insert)
             (local-set-key "{" 'autopair-insert)
             (local-set-key "}" 'autopair-close-block)
             (local-set-key "["  'autopair-insert)
             (local-set-key "]"  'autopair-insert)
             (local-set-key "\"" 'autopair-insert)
	     (local-set-key (kbd "RET") 'autopairs-ret)))

;; {{
;; Using with paredit-mode
;; Autopair doesn’t make much sense when paredit-mode is turned on, so it actually defers to paredit-mode when that is installed and enabled.
;; Using autopair-global-mode is thus safe but anyway the following code sample turns on autopairs for the modes listed in autopair-modes, but disables it when paredit-mode is turned on:
(defvar autopair-modes '(c-mode c++-mode shell-script-mode))
(defun turn-on-autopair-mode () (autopair-mode 1))
(dolist (mode autopair-modes) (add-hook (intern (concat (symbol-name mode) "-hook")) 'turn-on-autopair-mode))

(require 'paredit)
(defadvice paredit-mode (around disable-autopairs-around (arg))
  "Disable autopairs mode if paredit-mode is turned on"
  ad-do-it
  (if (null ad-return-value)
      (autopair-mode 1)
    (autopair-mode 0)
    ))

(ad-activate 'paredit-mode)
;; }}

(provide 'init-parens)
