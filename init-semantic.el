;; (defvar user-include-dirs
;;   '("." "./include" "./inc" "./common" "./public"
;;     ".." "../include" "../inc" "../common" "../public"
;;     "../.." "../../include" "../../inc" "../../common" "../../public"
;;     )
;;   "User include dirs for c/c++ mode")

;; (eval-after-load "semantic"
;;   '(progn
;;      ;; any other config specific to sql
;;      (defun my-semantic-hook ()
;;        (global-semanticdb-minor-mode t)
;;        (global-semantic-mru-bookmark-mode t)
;;        (global-semantic-decoration-mode nil)
;;        (define-key semantic-mode-map [f12] 'semantic-ia-fast-jump)
;;        ;; (define-key semantic-mode-map [S-f12] 'semantic-ia-fast-jump-back)
;;        (define-key semantic-mode-map [C-f12] 'semantic-mrub-switch-tags)
;;        ;; (define-key semantic-mode-map (kbd "ESC ESC <f12>")
;;        ;;   'semantic-ia-fast-jump-back)
;;        ;; (define-key semantic-mode-map [S-f12] 'pop-global-mark)
;;        (global-set-key [mouse-2] 'semantic-ia-fast-jump-mouse)
;;        ;; (define-key semantic-mode-map [mouse-2] 'semantic-ia-fast-jump-mouse)
;;        ;; (define-key semantic-mode-map [S-mouse-2] 'semantic-ia-fast-jump-back)
;;        (define-key semantic-mode-map [double-mouse-2] 'semantic-ia-fast-jump-back)
;;        (define-key semantic-mode-map [M-S-f12] 'semantic-analyze-proto-impl-toggle)
;;        (define-key semantic-mode-map (kbd "C-c , ,") 'semantic-force-refresh)
;;        (mapc (lambda (dir)
;;                (semantic-add-system-include dir 'c++-mode)
;;                (semantic-add-system-include dir 'c-mode))
;;              user-include-dirs)
;;        ;; (semantic-add-system-include "./include" 'c++-mode)
;;        ;; (semantic-add-system-include "./include" 'c-mode)
;;        )
;;      (add-hook 'semantic-init-hooks 'my-semantic-hook)
;;      ))


;; ---------------------------------------------------------------
;;; environment path
;; c/c++ include dir (ffap use mingw dirs)
(defvar user-include-dirs
  '("." "./include" "./inc" "./common" "./public"
    ".." "../include" "../inc" "../common" "../public"
    "../.." "../../include" "../../inc" "../../common" "../../public"
    ;; "D:/MinGW/include"
    ;; "D:/MinGW/include/c++/3.4.5"
    ;; "D:/MinGW/include/c++/3.4.5/mingw32"
    ;; "D:/MinGW/include/c++/3.4.5/backward"
    ;; "D:/MinGW/lib/gcc/mingw32/3.4.5/include"
    ;; "D:/Program Files/Microsoft Visual Studio/VC98/Include"
    ;; "D:/Program Files/Microsoft Visual Studio/VC98/MFC/Include"
    ;; "D:/Program Files/Microsoft Visual Studio 10.0/VC/include"
    )
  "User include dirs for c/c++ mode")

(defvar c-preprocessor-symbol-files
  '(;; "D:/MinGW/include/c++/3.4.5/mingw32/bits/c++config.h"
    ;; "D:/Program Files/Microsoft Visual Studio/VC98/Include/xstddef"
    ;; "D:/Program Files/Microsoft Visual Studio 10.0/VC/include/yvals.h"
    ;; "D:/Program Files/Microsoft Visual Studio 10.0/VC/include/crtdefs.h"
    )
  "Preprocessor symbol files for cedet")

;; ===============================================================
;; buildin cedet (semantic)
;; ===============================================================
(when (and (fboundp 'semantic-mode)
           (not (locate-library "semantic-ctxt"))) ; can't found offical cedet
  (setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                    global-semanticdb-minor-mode
                                    global-semantic-idle-summary-mode
                                    global-semantic-mru-bookmark-mode))
  (semantic-mode 1)
;;  (global-semantic-decoration-mode 1)
  (require 'semantic/decorate/include nil 'noerror)
  (semantic-toggle-decoration-style "semantic-tag-boundary" -1)
;;(global-semantic-highlight-edits-mode (if window-system 1 -1))
  (global-semantic-show-unmatched-syntax-mode 1)
  (global-semantic-show-parser-state-mode 1)
;;  (global-ede-mode 1)
  (when (executable-find "global")
    (semanticdb-enable-gnu-global-databases 'c-mode)
    (semanticdb-enable-gnu-global-databases 'c++-mode)
    (setq ede-locate-setup-options '(ede-locate-global ede-locate-base)))
  ;; (setq semantic-c-obey-conditional-section-parsing-flag nil) ; ignore #if

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

  ;; (eval-after-load "semantic/bovine/c"
  ;;   '(dolist (d (list  "D:/MinGW/include"
  ;;                      "D:/MinGW/include/c++/3.4.5"
  ;;                      "D:/MinGW/include/c++/3.4.5/mingw32"
  ;;                      "D:/MinGW/include/c++/3.4.5/backward"
  ;;                      "D:/MinGW/lib/gcc/mingw32/3.4.5/include"
  ;;                      ;; "D:/Program Files/Microsoft Visual Studio/VC98/Include"
  ;;                      ;; "D:/Program Files/Microsoft Visual Studio/VC98/MFC/Include"
  ;;                      "D:/Program Files/Microsoft Visual Studio 10.0/VC/include"

  ;;                      "D:/MinGW/include/c++/3.4.5/mingw32/bits/c++config.h"
  ;;                      ;; "D:/Program Files/Microsoft Visual Studio/VC98/Include/xstddef"
  ;;                      "D:/Program Files/Microsoft Visual Studio 10.0/VC/include/yvals.h"
  ;;                      "D:/Program Files/Microsoft Visual Studio 10.0/VC/include/crtdefs.h"
  ;;                      ))
  ;;      (semantic-add-system-include d)))


  (dolist (file c-preprocessor-symbol-files)
    (when (file-exists-p file)
      (require 'semantic/bovine/c)
      (setq semantic-lex-c-preprocessor-symbol-file
            (append semantic-lex-c-preprocessor-symbol-file (list file)))))

  (require 'semantic/bovine/el nil 'noerror)

  (require 'semantic/analyze/refs)      ; for semantic-ia-fast-jump
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
        (error "Semantic Bookmark ring is currently empty"))
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

  ;; (autoload 'pulse-momentary-highlight-one-line "pulse" "" nil)
  ;; (autoload 'pulse-line-hook-function "pulse" "" nil)
  ;; (setq pulse-command-advice-flag t)    ; (if window-system 1 nil)
  ;; (defadvice goto-line (after pulse-advice activate)
  ;;   "Cause the line that is `goto'd to pulse when the cursor gets there."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice exchange-point-and-mark (after pulse-advice activate)
  ;;   "Cause the line that is `goto'd to pulse when the cursor gets there."
  ;;   (when (and pulse-command-advice-flag (interactive-p)
  ;;              (> (abs (- (point) (mark))) 400))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice find-tag (after pulse-advice activate)
  ;;   "After going to a tag, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice tags-search (after pulse-advice activate)
  ;;   "After going to a hit, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice tags-loop-continue (after pulse-advice activate)
  ;;   "After going to a hit, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice pop-tag-mark (after pulse-advice activate)
  ;;   "After going to a hit, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice imenu-default-goto-function (after pulse-advice activate)
  ;;   "After going to a tag, pulse the line the cursor lands on."
  ;;   (when pulse-command-advice-flag
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice cua-exchange-point-and-mark (after pulse-advice activate)
  ;;   "Cause the line that is `goto'd to pulse when the cursor gets there."
  ;;   (when (and pulse-command-advice-flag (interactive-p)
  ;;              (> (abs (- (point) (mark))) 400))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice switch-to-buffer (after pulse-advice activate)
  ;;   "After switch-to-buffer, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice previous-buffer (after pulse-advice activate)
  ;;   "After previous-buffer, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice next-buffer (after pulse-advice activate)
  ;;   "After next-buffer, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice ido-switch-buffer (after pulse-advice activate)
  ;;   "After ido-switch-buffer, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  ;; (defadvice beginning-of-buffer (after pulse-advice activate)
  ;;   "After beginning-of-buffer, pulse the line the cursor lands on."
  ;;   (when (and pulse-command-advice-flag (interactive-p))
  ;;     (pulse-momentary-highlight-one-line (point))))
  (add-hook 'next-error-hook 'pulse-line-hook-function))

;; Try completion with semantic-mode, it may slow the emacs,
;; `M-x complete-symbol` (Hotkey: C-M-i) will trigger the completion
;; Uncomment below code if you want semantic plus complete-symbol
;; (semantic-mode)
;; (add-to-list 'completion-at-point-functions 'semantic-completion-at-point-function)

(provide 'init-semantic)
