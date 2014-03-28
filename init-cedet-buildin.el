;; Load CEDET.
;; See cedet/common/cedet.info for configuration details.
;; IMPORTANT: For Emacs >= 23.2, you must place this *before* any
;; CEDET component (including EIEIO) gets activated by another
;; package (Gnus, auth-source, ...).
;; (load-file "~/.emacs.d/cedet-1.1/common/cedet.el")

;; Enable EDE (Project Management) features
;; (global-ede-mode 1)

;; Enable EDE for a pre-existing C++ project
;; (ede-cpp-root-project "NAME" :file "~/myproject/Makefile")


;; Enabling Semantic (code-parsing, smart completion) features
;; Select one of the following:

;; * This enables the database and idle reparse engines
;; (semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode,
;;   imenu support, and the semantic navigator
;; (semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as intellisense mode,
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-gaudy-code-helpers)

;; * This enables the use of Exuberant ctags if you have it installed.
;;   If you use C++ templates or boost, you should NOT enable it.
;; (semantic-load-enable-all-exuberent-ctags-support)
;;   Or, use one of these two types of support.
;;   Add support for new languages only via ctags.
;; (semantic-load-enable-primary-exuberent-ctags-support)
;;   Add support for using ctags as a backup parser.
;; (semantic-load-enable-secondary-exuberent-ctags-support)

;; Enable SRecode (Template management) minor-mode.
;; (global-srecode-minor-mode 1)

;; c/c++ include dir (ffap use mingw dirs)
(defvar user-include-dirs
  '("." "./include" "./inc" "./common" "./public"
    ".." "../include" "../inc" "../common" "../public"
    "../.." "../../include" "../../inc" "../../common" "../../public"
    )
  "User include dirs for c/c++ mode")

(defvar c-preprocessor-symbol-files
  '(
    ;; "D:/Program Files/Microsoft Visual Studio/VC98/Include/xstddef"
    ;; "D:/Program Files/Microsoft Visual Studio 10.0/VC/include/yvals.h"
    ;; "D:/Program Files/Microsoft Visual Studio 10.0/VC/include/crtdefs.h"
    )
  "Preprocessor symbol files for cedet")

(when (and (fboundp 'semantic-mode)
           (not (locate-library "semantic-ctxt"))) ; can't found offical cedet
  (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                    global-semanticdb-minor-mode
                                    global-semantic-idle-summary-mode
                                    global-semantic-mru-bookmark-mode))
  (semantic-mode 1)
  ;; (global-semantic-decoration-mode 1)
  (require 'semantic/decorate/include nil 'noerror)
  (semantic-toggle-decoration-style "semantic-tag-boundary" -1)
  (global-semantic-highlight-edits-mode (if window-system 1 -1))
  (global-semantic-show-unmatched-syntax-mode 1)
  (global-semantic-show-parser-state-mode 1)
  (global-ede-mode 1)
  (when (executable-find "global")
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode)
    (setq ede-locate-setup-options '(ede-locate-global ede-locate-base)))
  (setq semantic-c-obey-conditional-section-parsing-flag nil) ; ignore #if

  ;; (defun my-semantic-inhibit-func ()
  ;;   (cond
  ;;    ((member major-mode '(Info-mode))
  ;;     ;; to disable semantic, return non-nil.
  ;;     t)
  ;;    (t nil)))
  ;; (add-to-list 'semantic-inhibit-functions 'my-semantic-inhibit-func)

  (when (executable-find "gcc")
    (require 'semantic/bovine/c nil 'noerror)
    (and (eq system-type 'windows-nt)
         (semantic-gcc-setup)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        user-include-dirs)

  (dolist (file c-preprocessor-symbol-files)
    (when (file-exists-p file)
      (require 'semantic/bovine/gcc)
      (setq semantic-lex-c-preprocessor-symbol-file
            (append semantic-lex-c-preprocessor-symbol-file (list file)))))

  (require 'semantic/bovine/el nil 'noerror)

  (require 'semantic/analyze/refs)      ; for semantic-ia-fast-jump
  (require 'semantic/ia)
  (defadvice push-mark (around semantic-mru-bookmark activate)
    "Push a mark at LOCATION with NOMSG and ACTIVATE passed to `push-mark'.
If `semantic-mru-bookmark-mode' is active, also push a tag onto
the mru bookmark stack."
    (semantic-mrub-push semantic-mru-bookmark-ring
                        (point)
                        'mark)
    ad-do-it)
  (defun semantic-ia-fast-jump-back ()
    (interactive)
    (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
        (error "Semantic Bookmark ring is currently empty, can't jump-back"))
    (let* ((ring (oref semantic-mru-bookmark-ring ring))
           (alist (semantic-mrub-ring-to-assoc-list ring))
           (first (cdr (car alist))))
      ;; (if (semantic-equivalent-tag-p (oref first tag) (semantic-current-tag))
      ;;     (setq first (cdr (car (cdr alist)))))
      (semantic-mrub-visit first)
      (ring-remove ring 0)))
  (defun semantic-ia-fast-jump-or-back (&optional back)
    (interactive "P")
    (if back
        (semantic-ia-fast-jump-back)
      (semantic-ia-fast-jump (point))))
  (defun semantic-ia-fast-jump-mouse (ev)
    "semantic-ia-fast-jump with a mouse click. EV is the mouse event."
    (interactive "e")
    (mouse-set-point ev)
    (semantic-ia-fast-jump (point)))
  ;; (define-key semantic-mode-map [(control tab)] 'semantic-ia-complete-symbol-menu)
  (define-key semantic-mode-map "\C-c\C-c" 'semantic-ia-show-doc)
  ;; (define-key semantic-mode-map "\C-c\C-s" 'semantic-ia-show-summary)
  (define-key semantic-mode-map [f12] 'semantic-ia-fast-jump-or-back)
  (define-key semantic-mode-map [C-f12] 'semantic-mrub-switch-tags)
  (define-key semantic-mode-map [S-f12] 'semantic-ia-fast-jump-back)
  ;; (define-key semantic-mode-map (kbd "ESC ESC <f12>")
  ;;   'semantic-ia-fast-jump-back)
  ;; (define-key semantic-mode-map [S-f12] 'pop-global-mark)
  (global-set-key [mouse-2] 'semantic-ia-fast-jump-mouse)
  ;; (define-key semantic-mode-map [mouse-2] 'semantic-ia-fast-jump-mouse)
  (define-key semantic-mode-map [S-mouse-2] 'semantic-ia-fast-jump-back)
  (define-key semantic-mode-map [double-mouse-2] 'semantic-ia-fast-jump-back)
  (define-key semantic-mode-map [M-S-f12] 'semantic-analyze-proto-impl-toggle)
  (define-key semantic-mode-map (kbd "C-c , ,") 'semantic-force-refresh)
  (add-hook 'next-error-hook 'pulse-line-hook-function))

;; Semantic
;; (global-semantic-idle-completions-mode t)
;; (global-semantic-decoration-mode t)
(global-semantic-highlight-func-mode t)
;; (global-semantic-show-unmatched-syntax-mode t)

;; SRecode
(global-srecode-minor-mode 1)

;; EDE
(global-ede-mode 1)
(ede-enable-generic-projects)

(provide 'init-cedet-buildin)