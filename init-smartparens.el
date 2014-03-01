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

(provide 'init-smartparens)
