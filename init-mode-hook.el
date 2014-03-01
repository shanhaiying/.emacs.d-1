;; --------------------------------------------------------------------------
;; mode associated with filename extensions
;; --------------------------------------------------------------------------
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)

(add-to-list 'auto-mode-alist '("\\.[ch]\\'" . c-mode))
;; (setq c-default-style "bsd")
(add-hook 'c-mode-hook
          (lambda ()
            (hs-minor-mode 1)
            (flyspell-mode -1)
            (c-set-style "stroustrup")))

(add-to-list 'auto-mode-alist '("\\.[cC][pP][pP]\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook
          (lambda ()
            (hs-minor-mode 1)
            (flyspell-mode -1)
            (c-set-style "stroustrup")
            ;; (c-toggle-auto-hungry-state 1)
            (c-set-offset 'innamespace 0)))

(add-hook 'java-mode-hook
          (lambda ()
            (hs-minor-mode 1)
            (flyspell-mode -1)
            (c-set-style "java")))

;; (when (boundp 'magic-mode-alist)
;;   (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@implementation" . objc-mode))
;;   (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@interface" . objc-mode))
;;   (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*@protocol" . objc-mode)))
;; ;; (add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*#import" . objc-mode))
;; (add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
;; (add-hook 'objc-mode-hook
;;           (lambda ()
;;             (hs-minor-mode 1)
;;             (flyspell-mode -1)
;;             (c-set-style "stroustrup")))

(add-to-list 'auto-mode-alist '("\\.[pP][rR][cC]\\'" . sql-mode))
;; (add-hook 'sql-mode-hook 'prog-common-function)

(add-to-list 'auto-mode-alist '("\\.[eE][lL]\\'" . emacs-lisp-mode))
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            ;; (prog-common-function)
            (hs-minor-mode 1)
            (flyspell-mode -1)
            (turn-on-eldoc-mode)))

(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook
          (lambda ()
            (hs-minor-mode 1)
            (flyspell-mode -1)))

;; (add-hook 'python-mode-hook 'prog-common-function)

(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))
;; (add-hook 'sh-mode-hook 'prog-common-function)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

(add-to-list 'auto-mode-alist '("\\.[a-zA-Z]+rc$" . conf-mode))

(add-hook 'makefile-mode-hook
          (lambda ()
            (hs-minor-mode 1)
            (flyspell-mode -1)
            (when (fboundp 'whitespace-mode)
              (whitespace-mode -1))
            (linum-mode 1)
            (imenu-add-menubar-index)))

(add-hook 'autoconf-mode-hook
          (lambda ()
            (hs-minor-mode 1)
            (flyspell-mode -1)
            (when (fboundp 'whitespace-mode)
              (whitespace-mode -1))
            (linum-mode 1)))

;; (add-hook 'perl-mode-hook 'prog-common-function)
(add-to-list 'auto-mode-alist
             '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
(add-hook 'cperl-mode-hook
          '(lambda ()
             ;; (prog-common-function)
             (hs-minor-mode 1)
             (flyspell-mode -1)
             (cperl-set-style "PerlStyle")
             (setq cperl-continued-brace-offset -4)
             (abbrev-mode t)))

(add-auto-mode 'tcl-mode "Portfile\\'")

(provide 'init-mode-hook)