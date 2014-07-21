(setq py-install-directory "~/.emacs.d/site-lisp/python-mode")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)
(setq py-shell-name "/usr/bin/python")
;; (setq py-shell-name "/usr/bin/X11/ipython")
(setq py-load-pymacs-p nil)

(setq py-shell-map
      (let ((map (copy-keymap comint-mode-map)))
        (define-key map [(tab)] 'py-shell-complete)
        map))

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

;; needed by jedi
(require 'python-environment)
;; (defun YOUR-PLUGIN-install-python-dependencies ()
;;   (interactive)
;;   (python-environment-run "pip" "install" "epc"))

;; jedi (Python auto-completion for Emacs)
(autoload 'jedi:setup "jedi" nil t)
(setq jedi:setup-keys t)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)                 ; optional

;; pdee (Python Development Emacs Environment)


;;----------------------------------------------------------------------------
;; Pylookup is a mode to search python documents especially within emacs.
;;----------------------------------------------------------------------------
(setq pylookup-dir "~/.emacs.d/site-lisp/pylookup")
;; load pylookup when compile time
;; (require 'pylookup)
(eval-when-compile (require 'pylookup))

;; set executable file and db file
(setq pylookup-program (concat pylookup-dir "/pylookup.py"))
(setq pylookup-db-file (concat pylookup-dir "/pylookup.db"))

;; to speedup, just load it on demand
(autoload 'pylookup-lookup "pylookup"
  "Lookup SEARCH-TERM in the Python HTML indexes." t)
(autoload 'pylookup-update "pylookup" 
  "Run pylookup-update and create the database at `pylookup-db-file'." t)

;; (global-set-key "\C-ch" 'pylookup-lookup)
(setq py-shell-map
      (let ((map (copy-keymap comint-mode-map)))
        (define-key map "\C-ch" 'pylookup-lookup)
        map))
(setq python-mode-map
      (let ((map (make-sparse-keymap)))
	(define-key map "\C-ch" 'pylookup-lookup)
	map))

(setq browse-url-browser-function 'w3m-browse-url) ;; w3m
(setq browse-url-default-browser "w3m")

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
