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

;; auto-pair
(require 'autopair)
;; (autopair-global-mode)

;; {{
;; Using with paredit-mode
;; Autopair doesn’t make much sense when paredit-mode is turned on, so it actually defers to paredit-mode when that is installed and enabled.
;; Using autopair-global-mode is thus safe but anyway the following code sample turns on autopairs for the modes listed in autopair-modes, but disables it when paredit-mode is turned on:
(defvar autopair-modes '(c-mode c++-mode))
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
