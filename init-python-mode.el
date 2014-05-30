(require 'python-mode)
(setq py-shell-name "/usr/bin/python")
;; (setq py-shell-name "/usr/bin/X11/ipython")
(setq py-load-pymacs-p nil)

(autoload 'doctest-mode "doctest-mode" "Python doctest editing mode." t)

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
		("SConscript\\'" . python-mode))
              auto-mode-alist))

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

;;----------------------------------------------------------------------------
;; On-the-fly syntax checking via flymake
;;----------------------------------------------------------------------------
(eval-after-load 'python
  '(require 'flymake-python-pyflakes))

(add-hook 'python-mode-hook '(lambda ()
                               (when *emacs24*
                                 (anaconda-eldoc)
                                 (add-to-list 'company-backends 'company-anaconda))
                               (flymake-python-pyflakes-load)))


(provide 'init-python-mode)
