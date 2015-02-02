(require 'python-mode)
(custom-set-variables
 '(py-shell-name "/usr/bin/python3")
 ;; '(py-shell-name "/usr/bin/X11/ipython3")
 '(py-which-bufname "Python3")
 ;; '(py-which-bufname "IPython3")
 '(py-which-shell "/usr/bin/python3")
 '(py-python-command "/usr/bin/python3")
 '(python-shell-interpreter "/usr/bin/python3")
 )
;; (setq py-shell-name "/usr/bin/python3")
;; (setq py-shell-name "/usr/bin/X11/ipython")

;; ;; use the wx backend, for both mayavi and matplotlib
;; (setq py-python-command-args
;;   '("--gui=wx" "--pylab=wx" "-colors" "Linux"))

;; ;; switch to the interpreter after executing code
;; (setq py-shell-switch-buffers-on-execute-p nil)
;; (setq py-switch-buffers-on-execute-p t)
;; try to automagically figure out indentation
(setq py-smart-indentation t)

(define-key py-shell-map [(control tab)] 'py-shell-complete)

;; "C-c C-e" py-help-at-point is useless, so rebind it.
(define-key python-mode-map (kbd "C-c C-e") 'py-execute-region-default)

(defun my-py-execute-buffer-python (pythonver)
  "Call the python interpreter."
  (interactive "sExecute with Python[2-3]? (Default 3):")
  (save-buffer)
  (if (string-equal pythonver "2")
      (py-execute-buffer)
    (py-execute-buffer-python3)))

(define-key python-mode-map (kbd "C-c C-c") #'my-py-execute-buffer-python)

(autoload 'doctest-mode "doctest-mode" "Python doctest editing mode." t)

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

;; {{
;; Support for C Python core developers
;; Both Emacs and XEmacs have support for developers hacking on the Python C code itself. If you're developing Python 2.x, just use the standard python style that comes with c-mode. If you're hacking on Python 3.x, you'll want to add the following code.
(c-add-style
 "python-new"
 '((indent-tabs-mode . nil)
   (fill-column      . 78)
   (c-basic-offset   . 4)
   (c-offsets-alist  . ((substatement-open . 0)
			(inextern-lang . 0)
			(arglist-intro . +)
			(knr-argdecl-intro . +)))
   (c-hanging-braces-alist . ((brace-list-open)
			      (brace-list-intro)
			      (brace-list-close)
			      (brace-entry-open)
			      (substatement-open after)
			      (block-close . c-snug-do-while)))
   (c-block-comment-prefix . "* "))
 )
;; This is a very crude hook that auto-selects the C style depending on
;; whether it finds a line starting with tab in the first 3000 characters
;; in the file
(defun c-select-style ()
   (save-excursion
     (if (re-search-forward "^\t" 3000 t)
         (c-set-style "python")
       (c-set-style "python-new"))))
(add-hook 'c-mode-hook 'c-select-style)
;; }}

;; {{
;; use pymacs + rope + ropemacs code refactoring
(setq py-load-pymacs-p nil)
(require 'pymacs)
;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
;; }}

;; {{
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
;; }}

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
(define-key py-shell-map "\C-ch" 'pylookup-lookup)
(define-key python-mode-map "\C-ch" 'pylookup-lookup)

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
                                 ;; (add-to-list 'company-backends 'company-anaconda)
				 )
                               (flymake-python-pyflakes-load)))


(provide 'init-python-mode)
