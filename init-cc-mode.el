(require 'cc-mode)
(defun c-wx-lineup-topmost-intro-cont (langelem)
  (save-excursion
    (beginning-of-line)
    (if (re-search-forward "EVT_" (line-end-position) t)
        'c-basic-offset
      (c-lineup-topmost-intro-cont langelem))))

(require 'cl)

(defun file-in-directory-list-p (file dirlist)
  "Returns true if the file specified is contained within one of
the directories in the list. The directories must also exist."
  (let ((dirs (mapcar 'expand-file-name dirlist))
        (filedir (expand-file-name (file-name-directory file))))
    (and
     (file-directory-p filedir)
     (member-if (lambda (x) ; Check directory prefix matches
                  (string-match (substring x 0 (min(length filedir) (length x))) filedir))
                dirs))))

(defun buffer-standard-include-p ()
  "Returns true if the current buffer is contained within one of
the directories in the INCLUDE environment variable."
  (and (getenv "INCLUDE")
       (file-in-directory-list-p buffer-file-name (split-string (getenv "INCLUDE") path-separator))))

(add-to-list 'magic-fallback-mode-alist '(buffer-standard-include-p . c++-mode))

;; ===============================================================
;; gdb (gud)
;; ===============================================================
;; (require 'gdb-ui nil 'noerror)
(require 'gdb-mi nil 'noerror)

(defadvice gdb-setup-windows (after my-setup-gdb-windows activate)
  "my gdb ui,fix sizes of every buffer"
  (gdb-get-buffer-create 'gdb-locals-buffer)
  (gdb-get-buffer-create 'gdb-stack-buffer)
  (gdb-get-buffer-create 'gdb-breakpoints-buffer)
  (set-window-dedicated-p (selected-window) nil)
  (switch-to-buffer gud-comint-buffer)
  (delete-other-windows)
  (let ((win0 (selected-window))
        (win1 (split-window nil ( / ( * (window-height) 8) 10)))
        (win2 (split-window nil ( / ( * (window-height) 3) 8)))
        ;; (win3 (split-window nil ( - ( / ( * (window-width) 2) 3) 1) 'right))
        (win3 (split-window nil ( / (window-width) 2) 'right)) ;input/output
	)
    (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io) nil win3)
    (select-window win2)
    (set-window-buffer
     win2
     (if gud-last-last-frame
         (gud-find-file (car gud-last-last-frame))
       (if gdb-main-file
           (gud-find-file gdb-main-file)
         ;; Put buffer list in window if we
         ;; can't find a source file.
         (list-buffers-noselect))))
    (setq gdb-source-window (selected-window))
    (let ((win4 (split-window nil (- (window-width) 40) 'right))) ;locals
      (gdb-set-window-buffer (gdb-locals-buffer-name) nil win4))
    (select-window win1)
    (gdb-set-window-buffer (gdb-stack-buffer-name))
    (let ((win5 (split-window-right)))
      (gdb-set-window-buffer (if gdb-show-threads-by-default
                                 (gdb-threads-buffer-name)
                               (gdb-breakpoints-buffer-name))
                             nil win5))
    (select-window win0)))

;; (defadvice gdb-setup-windows (after my-setup-gdb-windows activate)
;;   "my gdb ui, just source,gdb,io,stack buffers"
;;   (gdb-get-buffer-create 'gdb-locals-buffer)
;;   (gdb-get-buffer-create 'gdb-stack-buffer)
;;   (set-window-dedicated-p (selected-window) nil)
;;   (switch-to-buffer gud-comint-buffer)
;;   (delete-other-windows)
;;   (let ((win0 (selected-window))
;;         (win1 (split-window nil (/ (* (window-width) 1) 2) 'left))                     ;code and output
;;         (win2 (split-window-below (/ (* (window-height) 3) 4))) ;stack
;;         )
;;     (select-window win2)
;;     (gdb-set-window-buffer (gdb-stack-buffer-name))
;;     (select-window win1)
;;     (set-window-buffer
;;      win1
;;      (if gud-last-last-frame
;;          (gud-find-file (car gud-last-last-frame))
;;        (if gdb-main-file
;;            (gud-find-file gdb-main-file)
;;          ;; Put buffer list in window if we
;;          ;; can't find a source file.
;;          (list-buffers-noselect))))
;;     (setq gdb-source-window (selected-window))
;;     (let ((win3 (split-window nil (/ (* (window-height) 3) 4)))) ;io
;;       (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io) nil win3)) ;gdb-inferior-io
;;       ;; (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-locals-buffer) nil win3)
;;     (select-window win0)
;;  ))

;; (defadvice gdb-setup-windows (after my-setup-gdb-windows activate)
;;   "my gdb ui, just source,gdb,io,locals,stack buffers"
;;   (gdb-get-buffer-create 'gdb-locals-buffer)
;;   (gdb-get-buffer-create 'gdb-stack-buffer)
;;   (set-window-dedicated-p (selected-window) nil)
;;   (switch-to-buffer gud-comint-buffer)
;;   (delete-other-windows)
;;   (let ((win0 (selected-window))
;;         (win1 (split-window nil (/ ( * (window-height) 3) 4)))
;;         (win2 (split-window nil (/ (* (window-width) 1) 2) 'left))
;;         ;; (win1 (split-window nil (/ (* (window-width) 1) 2) 'left))                     ;code and output
;;         ;; (win2 (split-window-below (/ (* (window-height) 3) 4))) ;stack
;;         )
;;     (gdb-set-window-buffer (gdb-locals-buffer-name) nil win1)
;;     (select-window win2)
;;     (set-window-buffer
;;      win2
;;      (if gud-last-last-frame
;;          (gud-find-file (car gud-last-last-frame))
;;        (if gdb-main-file
;;            (gud-find-file gdb-main-file)
;;          ;; Put buffer list in window if we
;;          ;; can't find a source file.
;;          (list-buffers-noselect))))
;;     (setq gdb-source-window (selected-window))
;;     (select-window win1)
;;     (let ((win3 (split-window nil (/ (* (window-width) 2) 3) 'left))) ;io
;;       (gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io) nil win3)) ;gdb-inferior-io
;;     (select-window win1)
;;     (let ((win4 (split-window nil (/ (* (window-width) 1) 2) 'right)))
;;       (gdb-set-window-buffer (gdb-stack-buffer-name) nil win4))
;;     (select-window win0)))

(defun gud-break-or-remove (&optional force-remove)
  "Set/clear breakpoin."
  (interactive "P")
  (save-excursion
    (if (or force-remove
            (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint))
        (gud-remove nil)
      (gud-break nil))))

(defun gud-enable-or-disable ()
  "Enable/disable breakpoint."
  (interactive)
  (let ((obj))
    (save-excursion
      (move-beginning-of-line nil)
      (dolist (overlay (overlays-in (point) (point)))
        (when (overlay-get overlay 'put-break)
          (setq obj (overlay-get overlay 'before-string))))
      (if  (and obj (stringp obj))
          (cond ((featurep 'gdb-ui)
                 (let* ((bptno (get-text-property 0 'gdb-bptno obj)))
                   (string-match "\\([0-9+]\\)*" bptno)
                   (gdb-enqueue-input
                    (list
                     (concat gdb-server-prefix
                             (if (get-text-property 0 'gdb-enabled obj)
                                 "disable "
                               "enable ")
                             (match-string 1 bptno) "\n")
                     'ignore))))
                ((featurep 'gdb-mi)
                 (gud-basic-call
                  (concat
                   (if (get-text-property 0 'gdb-enabled obj)
                       "-break-disable "
                     "-break-enable ")
                   (get-text-property 0 'gdb-bptno obj))))
                (t (error "No gud-ui or gui-mi?")))
        (message "May be there isn't have a breakpoint.")))))

(defun gud-kill ()
  "Kill gdb process."
  (interactive)
  (with-current-buffer gud-comint-buffer (comint-skip-input))
  ;; (set-process-query-on-exit-flag (get-buffer-process gud-comint-buffer) nil)
  ;; (kill-buffer gud-comint-buffer)
  (dolist (buffer '(gdba gdb-stack-buffer gdb-breakpoints-buffer
                         gdb-threads-buffer gdb-inferior-io
                         gdb-registers-buffer gdb-memory-buffer
                         gdb-locals-buffer gdb-assembler-buffer))
    (when (gdb-get-buffer buffer)
      (let ((proc (get-buffer-process (gdb-get-buffer buffer))))
        (when proc (set-process-query-on-exit-flag proc nil)))
      (kill-buffer (gdb-get-buffer buffer)))))

(defadvice gdb (before ecb-deactivate activate)
  "if ecb activated, deactivate it."
  (when (and (boundp 'ecb-minor-mode) ecb-minor-mode)
    (ecb-deactivate)))

;; (defun gdb-tooltip-hook ()
;;   (gud-tooltip-mode 1)
;;   (let ((process (ignore-errors (get-buffer-process (current-buffer)))))
;;     (when process
;;       (set-process-sentinel process
;;                             (lambda (proc change)
;;                               (let ((status (process-status proc)))
;;                                 (when (or (eq status 'exit)
;;                                           (eq status 'signal))
;;                                   (gud-tooltip-mode -1))))))))
;; (add-hook 'gdb-mode-hook 'gdb-tooltip-hook)
(add-hook 'gdb-mode-hook (lambda () (gud-tooltip-mode 1)))
(defadvice gud-kill-buffer-hook (after gud-tooltip-mode activate)
  "After gdb killed, disable gud-tooltip-mode."
  (gud-tooltip-mode -1))

(setq gdb-many-windows t)
(setq gdb-use-separate-io-buffer nil)
;; (gud-tooltip-mode t)
(define-key c-mode-base-map [f5] 'gdb)
(eval-after-load "gud"
  '(progn
     (define-key gud-minor-mode-map [f5] (lambda (&optional kill)
                                           (interactive "P")
                                           (if kill
                                               (gud-kill)
                                             (gud-go))))
     (define-key gud-minor-mode-map [f5] 'gud-go)
     (define-key gud-minor-mode-map [S-f5] 'gud-kill)
     (define-key gud-minor-mode-map (kbd "ESC <f5>") 'gud-kill)
     (define-key gud-minor-mode-map [f17] 'gud-kill) ; S-f5
     (define-key gud-minor-mode-map [f8] 'gud-print)
     (define-key gud-minor-mode-map [C-f8] 'gud-pstar)
     (define-key gud-minor-mode-map [f9] 'gud-break-or-remove)
     (define-key gud-minor-mode-map [C-f9] 'gud-enable-or-disable)
     (define-key gud-minor-mode-map [S-f9] 'gud-watch)
     (define-key gud-minor-mode-map [f10] 'gud-next)
     (define-key gud-minor-mode-map [C-f10] 'gud-until)
     (define-key gud-minor-mode-map [C-S-f10] 'gud-jump)
     (define-key gud-minor-mode-map [f11] 'gud-step)
     (define-key gud-minor-mode-map [S-f11] 'gud-finish)
     (define-key gud-minor-mode-map (kbd "ESC <f11>") 'gud-finish)))


;;===== hack gud-mode begin
;; move the cursor to the end of last line if it's gud-mode
(defun hack-gud-mode ()
  (when (string= major-mode "gud-mode")
    (goto-char (point-max))))

(defadvice switch-to-buffer (after switch-to-buffer-after activate)
  (hack-gud-mode))

;; from switch-window is from 3rd party plugin switch windows.el
(defadvice switch-window (after switch-window-after activate)
  (hack-gud-mode))

;; windmove-do-window-select is from windmove.el
(defadvice windmove-do-window-select (after windmove-do-window-select-after activate)
  (hack-gud-mode))
;; ==== end

;C/C++ SECTION
(defun my-c-mode-hook ()
  ;; @see http://stackoverflow.com/questions/3509919/ \
  ;; emacs-c-opening-corresponding-header-file
  (local-set-key (kbd "C-x C-o") 'ff-find-other-file)
  (local-set-key "\M-f" 'c-forward-into-nomenclature)
  (local-set-key "\M-b" 'c-backward-into-nomenclature)
  (setq cc-search-directories '("." "/usr/include" "/usr/local/include/*" "../*/include" "$WXWIN/include"))
  (setq c-basic-offset 4)
  (setq c-style-variables-are-local-p nil)
  ;give me NO newline automatically after electric expressions are entered
  (setq c-auto-newline nil)

  ; @see http://xugx2007.blogspot.com.au/2007/06/benjamin-rutts-emacs-c-development-tips.html
  (setq compilation-window-height 8)
  (setq compilation-finish-function
        (lambda (buf str)
          (if (string-match "exited abnormally" str)
              ;;there were errors
              (message "compilation errors, press C-x ` to visit")
            ;;no errors, make the compilation window go away in 0.5 seconds
            (when (string-match "*compilation*" (buffer-name buf))
              ;; @see http://emacswiki.org/emacs/ModeCompile#toc2
              (bury-buffer "*compilation*")
              (winner-undo)
              (message "NO COMPILATION ERRORS!")
              ))))

  ;if (0)          becomes        if (0)
  ;    {                          {
  ;       ;                           ;
  ;    }                          }
  (c-set-offset 'substatement-open 0)

  ;first arg of arglist to functions: tabbed in once
  ;(default was c-lineup-arglist-intro-after-paren)
  (c-set-offset 'arglist-intro '+)

  ;second line of arglist to functions: tabbed in once
  ;(default was c-lineup-arglist)
  (c-set-offset 'arglist-cont-nonempty '+)

  ;switch/case:  make each case line indent from switch
  (c-set-offset 'case-label '+)

  ;make the ENTER key indent next line properly
  (local-set-key "\C-m" 'newline-and-indent)

  ;syntax-highlight aggressively
  ;(setq font-lock-support-mode 'lazy-lock-mode)
  (setq lazy-lock-defer-contextually t)
  (setq lazy-lock-defer-time 0)

  ;make DEL take all previous whitespace with it
  (c-toggle-hungry-state 1)

  ;make open-braces after a case: statement indent to 0 (default was '+)
  (c-set-offset 'statement-case-open 0)

  ;make a #define be left-aligned
  (setq c-electric-pound-behavior (quote (alignleft)))

  ;wxwdigets stuff
  (c-set-offset 'topmost-intro-cont 'c-wx-lineup-topmost-intro-cont)

  ;do not impose restriction that all lines not top-level be indented at least
  ;1 (was imposed by gnu style by default)
  (setq c-label-minimum-indentation 0)

  (setq gtags-suggested-key-mapping t)
  (gtags-mode 1)

  (require 'fic-mode)
  (add-hook 'c++-mode-hook 'turn-on-fic-mode)

  ; @see https://github.com/seanfisk/cmake-flymake
  ; make sure you project use cmake
  (flymake-mode)
  (cppcm-reload-all)

  )
;; donot use c-mode-common-hook or cc-mode-hook because many major-modes use this hook
(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(provide 'init-cc-mode)
