(defvar preferred-javascript-indent-level 2)

;; ---------------------------------------------------------------------------
;; Run and interact with an inferior JS via js-comint.el
;; ---------------------------------------------------------------------------
(setq inferior-js-program-command "js")
(defun add-inferior-js-keys ()
  (moz-minor-mode 1)
  (local-set-key "\C-x\C-e" 'js-send-last-sexp)
  (local-set-key "\C-\M-x" 'js-send-last-sexp-and-go)
  (local-set-key "\C-cb" 'js-send-buffer)
  (local-set-key "\C-c\C-b" 'js-send-buffer-and-go)
  (local-set-key "\C-cl" 'js-load-file-and-go))

;; may be in an arbitrary order
(eval-when-compile (require 'cl))

;; json
(setq auto-mode-alist (cons '("\\.json$" . json-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.jason$" . json-mode) auto-mode-alist))

;; {{ js2-mode or js-mode
(if (and (>= emacs-major-version 24) (>= emacs-minor-version 1))
    (progn
      (setq auto-mode-alist (cons '("\\.js\\(\\.erb\\)?\\'" . js2-mode) auto-mode-alist))
      (autoload 'js2-mode "js2-mode" nil t)
      (add-hook 'js2-mode-hook '(lambda ()
                                  (js2-imenu-extras-mode)
                                  (setq mode-name "JS2")
                                  (require 'requirejs-mode)
                                  (requirejs-mode)
                                  (require 'js-doc)
                                  (define-key js2-mode-map "\C-cd" 'js-doc-insert-function-doc)
                                  (define-key js2-mode-map "@" 'js-doc-insert-tag)
                                  (add-inferior-js-keys)
                                  ))

      (setq js2-use-font-lock-faces t
            js2-mode-must-byte-compile nil
            js2-basic-offset preferred-javascript-indent-level
            js2-indent-on-enter-key t
            js2-skip-preprocessor-directives t
            js2-auto-indent-p t
            js2-bounce-indent-p t)

      (add-to-list 'interpreter-mode-alist (cons "node" 'js2-mode))

      (eval-after-load 'coffee-mode
        `(setq coffee-js-mode 'js2-mode
               coffee-tab-width preferred-javascript-indent-level))
      )
  (progn
    ;; js-mode
    (setq auto-mode-alist (cons '("\\.js\\(\\.erb\\)?\\'" . js-mode) auto-mode-alist))
    (setq js-indent-level preferred-javascript-indent-level)

    ;; Need to first remove from list if present, since elpa adds entries too
    (add-hook 'js-mode-hook 'add-inferior-js-keys)

    )
  )
;; }}

;; standard javascript-mode
(setq javascript-indent-level preferred-javascript-indent-level)

(add-hook 'coffee-mode-hook 'flymake-coffee-load)

(provide 'init-javascript)
