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
(add-hook 'c-mode-hook                #'enable-paredit-mode)
(add-hook 'c++-mode-hook              #'enable-paredit-mode)
(add-hook 'TeX-mode-hook              #'enable-paredit-mode)
(add-hook 'markdown-mode-hook         #'enable-paredit-mode)

(provide 'init-parens)
