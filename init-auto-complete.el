;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
;; (ac-config-default)

(when (and (> emacs-major-version 21)
           (require 'auto-complete)
           (require 'auto-complete-config))
  (setq ac-use-comphist nil)
  (define-key ac-completing-map [return] 'ac-complete)
  (setq ac-modes
        (append ac-modes '(org-mode objc-mode csharp-mode jde-mode sql-mode
                                    plsql-mode sqlplus-mode
                                    inferior-emacs-lisp-mode
                                    ;; eshell-mode
                                    change-log-mode text-mode markdown-mode
                                    xml-mode nxml-mode html-mode
                                    tex-mode latex-mode plain-tex-mode
                                    conf-unix-mode conf-windows-mode
                                    conf-colon-mode conf-space-mode
                                    conf-javaprop-mode
                                    inetd-conf-generic-mode
                                    etc-services-generic-mode
                                    etc-passwd-generic-mode
                                    etc-fstab-generic-mode
                                    etc-sudoers-generic-mode
                                    resolve-conf-generic-mode
                                    etc-modules-conf-generic-mode
                                    apache-conf-generic-mode
                                    apache-log-generic-mode
                                    samba-generic-mode reg-generic-mode
                                    fvwm-generic-mode ini-generic-mode
                                    x-resource-generic-mode
                                    hosts-generic-mode inf-generic-mode
                                    bat-generic-mode javascript-generic-mode
                                    vrml-generic-mode java-manifest-generic-mode
                                    java-properties-generic-mode
                                    alias-generic-mode rc-generic-mode
                                    makefile-gmake-mode makefile-bsdmake-mode
                                    autoconf-mode makefile-automake-mode)))
  (let ((ac-path (locate-library "auto-complete")))
    (unless (null ac-path)
      (let ((dict-dir (expand-file-name "dict" (file-name-directory ac-path))))
        (add-to-list 'ac-dictionary-directories dict-dir))))
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (defadvice ac-update-word-index-1 (around exclude-hidden-buffer activate)
    "Exclude hidden buffer, hack for eim."
    (unless (string= (substring (buffer-name) 0 1) " ")
      ad-do-it))
  (ac-config-default)
  ;; (global-set-key (kbd "M-n") 'auto-complete)
  (setq ac-disable-faces nil)
  (add-hook 'ielm-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'eshell-mode-hook 'ac-emacs-lisp-mode-setup)
  (defun ac-semantic-setup ()
    ;; (setq ac-sources (append '(ac-source-semantic) ac-sources))
    (local-set-key (kbd "M-n") 'ac-complete-semantic))
  (add-hook 'c-mode-common-hook 'ac-semantic-setup)
  (when (require 'auto-complete-clang nil 'noerror)
    (setq ac-clang-flags
          '("-I.." "-I../include" "-I../inc" "-I../common" "-I../public"
            "-I../.." "-I../../include" "-I../../inc" "-I../../common"
            "-I../../public"))
    (when (fboundp 'semantic-gcc-get-include-paths)
      (let ((dirs (semantic-gcc-get-include-paths "c++")))
        (dolist (dir dirs)
          (add-to-list 'ac-clang-flags (concat "-I" dir)))))
    (defun ac-clang-setup ()
      (local-set-key (kbd "M-p") 'ac-complete-clang))
    (add-hook 'c-mode-common-hook 'ac-clang-setup))
  (setq ac-source-ropemacs              ; Redefine ac-source-ropemacs
        '((candidates . (lambda ()
                          (setq ac-ropemacs-completions-cache
                                (mapcar
                                 (lambda (completion)
                                   (concat ac-prefix completion))
                                 (ignore-errors
                                   (rope-completions))))))
          (prefix . c-dot)
          (requires . 0)))
  (defun ac-complete-ropemacs ()
    (interactive)
    (auto-complete '(ac-source-ropemacs)))
  (defun ac-ropemacs-setup ()
    (when (locate-library "pymacs")
      (ac-ropemacs-require)
      ;; (setq ac-sources (append (list 'ac-source-ropemacs) ac-sources))
      (local-set-key (kbd "M-n") 'ac-complete-ropemacs)))
  (ac-ropemacs-initialize)
  (defun ac-yasnippet-setup ()
    (add-to-list 'ac-sources 'ac-source-yasnippet))
  (add-hook 'auto-complete-mode-hook 'ac-yasnippet-setup))

;; (require 'auto-complete-auctex)         ;Dependencies yasnippet 0.6.1 / auto-complete 1.4

(provide 'init-auto-complete)
