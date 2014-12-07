;; --------------------------------------------------------------------------
;; mode associated with filename extensions
;; --------------------------------------------------------------------------
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)

;; (add-hook 'text-mode-hook
;;           (lambda ()
;;             (undo-tree-mode 1)
;;             (hs-minor-mode 1)
;;             (flyspell-mode t)))

(defun prog-common-function ()
  (progn
    (interactive)
    (undo-tree-mode 1)
    (hs-minor-mode 1)
    (flyspell-mode -1)
    (flyspell-mode-off)
    ;; (flyspell-prog-mode)
    (linum-mode 1)))

(require 'google-c-style)
;; donot use c-mode-common-hook or cc-mode-hook because many major-modes use this hook
;; (add-hook 'c-mode-common-hook 'google-set-c-style)
;; (add-hook 'c-mode-common-hook 'google-make-newline-indent)

(add-to-list 'auto-mode-alist '("\\.[ch]\\'" . c-mode))
;; (setq c-default-style "bsd")
(add-hook 'c-mode-hook (lambda () (prog-common-function)))
(add-hook 'c-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)
            ;; (c-set-style "stroustrup")
	    (google-set-c-style)
	    (google-make-newline-indent)
            ))

(add-to-list 'auto-mode-alist '("\\.[cC][pP][pP]\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.[hH][pP][pP]\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.[hH]\\'" . c++-mode))
(add-hook 'c++-mode-hook (lambda () (prog-common-function)))
(add-hook 'c++-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)
            ;; (c-set-style "stroustrup")
	    (google-set-c-style)
	    (google-make-newline-indent)
	    ))

(add-hook 'java-mode-hook (lambda () (prog-common-function)))
(add-hook 'java-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)
            (c-set-style "java")
            ))

(add-to-list 'auto-mode-alist '("\\.[gG][oO]\\'" . go-mode))
(add-hook 'go-mode-hook (lambda () (prog-common-function)))
;; configure company/auto-complete in "init-go-mode.el"
;; (add-hook 'go-mode-hook
;;           (lambda ()
;;             (company-mode -1)
;;             (auto-complete-mode 1)))

(add-to-list 'auto-mode-alist '("\\.[eE][lL]\\'" . emacs-lisp-mode))
(add-hook 'emacs-lisp-mode-hook (lambda () (prog-common-function)))
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)
            (turn-on-eldoc-mode)))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook (lambda () (prog-common-function)))
(add-hook 'markdown-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)))

(add-to-list 'auto-mode-alist '("\\.tex$" . LaTeX-mode))
(add-hook 'TeX-mode-hook (lambda () (prog-common-function)))
(add-hook 'TeX-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)))

;; (when (boundp 'magic-mode-alist)
;;   (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@implementation" . objc-mode))
;;   (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@interface" . objc-mode))
;;   (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@protocol" . objc-mode)))
;; ;; (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*#import" . objc-mode))
;; (add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
;; (add-hook 'objc-mode-hook
;;           (lambda ()
;;             (hs-minor-mode 1)
;;             (c-set-style "stroustrup")))

(add-to-list 'auto-mode-alist '("\\.[pP][rR][cC]\\'" . sql-mode))
(add-hook 'sql-mode-hook (lambda () (prog-common-function)))
;; (add-hook 'sql-mode-hook
;;           (lambda ()))

(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-hook 'python-mode-hook (lambda () (prog-common-function)))
(add-hook 'python-mode-hook
          (lambda ()
            (company-mode -1)
            (auto-complete-mode 1)))

(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)
(add-hook 'shell-mode-hook (lambda () (prog-common-function)))
(add-hook 'shell-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)))

(add-hook 'sh-mode-hook (lambda () (prog-common-function)))
(add-hook 'sh-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)))

(add-to-list 'auto-mode-alist '("/[mM]ake\\." . makefile-gmake-mode))
(add-hook 'makefile-mode-hook (lambda () (prog-common-function)))
(add-hook 'makefile-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)
            (when (fboundp 'whitespace-mode)
              (whitespace-mode -1))
            (imenu-add-menubar-index)))

(add-to-list 'auto-mode-alist '("\\.[a-zA-Z]+rc$" . conf-mode))
(add-hook 'autoconf-mode-hook (lambda () (prog-common-function)))
(add-hook 'autoconf-mode-hook
          (lambda ()
            (company-mode 1)
            (auto-complete-mode -1)
            (when (fboundp 'whitespace-mode)
              (whitespace-mode -1))))

(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(add-hook 'cperl-mode-hook (lambda () (prog-common-function)))
(add-hook 'cperl-mode-hook
          '(lambda ()
             (company-mode 1)
             (auto-complete-mode -1)
             (cperl-set-style "PerlStyle")
             (setq cperl-continued-brace-offset -4)
             (abbrev-mode t)))

(add-to-list 'auto-mode-alist '("Portfile\\'" . tcl-mode))

(add-hook 'gitignore-mode-hook (lambda () (prog-common-function)))

(add-hook 'cmake-mode-hook (lambda () (prog-common-function)))

(add-hook 'yaml-mode-hook (lambda () (prog-common-function)))

(add-hook 'web-mode-hook (lambda () (prog-common-function)))

(add-hook 'css-mode-hook (lambda () (prog-common-function)))

(add-hook 'conf-mode-hook (lambda () (prog-common-function)))

(add-hook 'conf-unix-mode-hook (lambda () (prog-common-function)))

(add-hook 'conf-windows-mode-hook (lambda () (prog-common-function)))

(add-hook 'conf-space-mode-hook (lambda () (prog-common-function)))

(add-hook 'text-mode-hook (lambda () (prog-common-function)))

(provide 'init-mode-hook)
