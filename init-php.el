(add-hook 'php-mode-hook 'flymake-php-load)

(autoload 'smarty-mode "smarty-mode" "Smarty Mode" t)
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . smarty-mode))

(provide 'init-php)
